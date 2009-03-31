Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55512 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbZCaKRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 06:17:09 -0400
Message-Id: <20090331101316.432913299@sipsolutions.net> (sfid-20090331_121712_767270_22D0673B)
References: <20090331101204.540183860@sipsolutions.net>
Date: Tue, 31 Mar 2009 12:12:06 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Subject: [PATCH v3 2/3] mac80211: pass all probe request IEs to driver
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of just passing the cfg80211-requested IEs, pass
the locally generated ones as well.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: * assume wiphy->max_scan_ie_len contains the limit *including*
      the IEs mac80211 passes (since the driver cannot know how long
      those will be) and adjust the driver's limit accordingly
    * keep track of original IEs and hand back the pristine cfg80211
      request structure
    * mark the IE pointer const in the request struct
v3: * move code to correct place (register_hw)
    * calculate upper limit for userspace scan IEs more accurately

 include/net/cfg80211.h     |    2 -
 include/net/mac80211.h     |   13 ++++---
 net/mac80211/ieee80211_i.h |    9 +++--
 net/mac80211/main.c        |   49 +++++++++++++++++++--------
 net/mac80211/scan.c        |   24 +++++++++++++
 net/mac80211/util.c        |   79 +++++++++++++++++++++++++++------------------
 net/wireless/nl80211.c     |    3 +
 7 files changed, 123 insertions(+), 56 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-03-31 11:42:15.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-03-31 11:48:51.000000000 +0200
@@ -1330,11 +1330,14 @@ enum ieee80211_ampdu_mlme_action {
  *	the scan state machine in stack. The scan must honour the channel
  *	configuration done by the regulatory agent in the wiphy's
  *	registered bands. The hardware (or the driver) needs to make sure
- *	that power save is disabled. When the scan finishes,
- *	ieee80211_scan_completed() must be called; note that it also must
- *	be called when the scan cannot finish because the hardware is
- *	turned off! Anything else is a bug! Returns a negative error code
- *	which will be seen in userspace.
+ *	that power save is disabled.
+ *	The @req ie/ie_len members are rewritten by mac80211 to contain the
+ *	entire IEs after the SSID, so that drivers need not look at these
+ *	at all but just send them after the SSID -- mac80211 includes the
+ *	(extended) supported rates and HT information (where applicable).
+ *	When the scan finishes, ieee80211_scan_completed() must be called;
+ *	note that it also must be called when the scan cannot finish due to
+ *	any error unless this callback returned a negative error code.
  *
  * @sw_scan_start: Notifier function that is called just before a software scan
  *	is started. Can be NULL, if the driver doesn't need this notification.
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-03-31 11:42:15.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-03-31 11:48:51.000000000 +0200
@@ -671,7 +671,10 @@ struct ieee80211_local {
 	struct cfg80211_scan_request int_scan_req;
 	struct cfg80211_scan_request *scan_req;
 	struct ieee80211_channel *scan_channel;
+	const u8 *orig_ies;
+	int orig_ies_len;
 	int scan_channel_idx;
+	int scan_ies_len;
 
 	enum { SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
 	unsigned long last_scan_completed;
@@ -1093,9 +1096,11 @@ void ieee80211_send_auth(struct ieee8021
 			 u16 transaction, u16 auth_alg,
 			 u8 *extra, size_t extra_len,
 			 const u8 *bssid, int encrypt);
+int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
+			     const u8 *ie, size_t ie_len);
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
-			      u8 *ssid, size_t ssid_len,
-			      u8 *ie, size_t ie_len);
+			      const u8 *ssid, size_t ssid_len,
+			      const u8 *ie, size_t ie_len);
 
 void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 				  const size_t supp_rates_len,
--- wireless-testing.orig/net/mac80211/util.c	2009-03-31 11:48:50.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-03-31 11:48:51.000000000 +0200
@@ -832,16 +832,57 @@ void ieee80211_send_auth(struct ieee8021
 	ieee80211_tx_skb(sdata, skb, encrypt);
 }
 
+int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
+			     const u8 *ie, size_t ie_len)
+{
+	struct ieee80211_supported_band *sband;
+	u8 *pos, *supp_rates_len, *esupp_rates_len = NULL;
+	int i;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+	pos = buffer;
+
+	*pos++ = WLAN_EID_SUPP_RATES;
+	supp_rates_len = pos;
+	*pos++ = 0;
+
+	for (i = 0; i < sband->n_bitrates; i++) {
+		struct ieee80211_rate *rate = &sband->bitrates[i];
+
+		if (esupp_rates_len) {
+			*esupp_rates_len += 1;
+		} else if (*supp_rates_len == 8) {
+			*pos++ = WLAN_EID_EXT_SUPP_RATES;
+			esupp_rates_len = pos;
+			*pos++ = 1;
+		} else
+			*supp_rates_len += 1;
+
+		*pos++ = rate->bitrate / 5;
+	}
+
+	/*
+	 * If adding more here, adjust code in main.c
+	 * that calculates local->scan_ies_len.
+	 */
+
+	if (ie) {
+		memcpy(pos, ie, ie_len);
+		pos += ie_len;
+	}
+
+	return pos - buffer;
+}
+
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
-			      u8 *ssid, size_t ssid_len,
-			      u8 *ie, size_t ie_len)
+			      const u8 *ssid, size_t ssid_len,
+			      const u8 *ie, size_t ie_len)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_supported_band *sband;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
-	u8 *pos, *supp_rates, *esupp_rates = NULL;
-	int i;
+	u8 *pos;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt) + 200 +
 			    ie_len);
@@ -868,33 +909,9 @@ void ieee80211_send_probe_req(struct iee
 	*pos++ = WLAN_EID_SSID;
 	*pos++ = ssid_len;
 	memcpy(pos, ssid, ssid_len);
+	pos += ssid_len;
 
-	supp_rates = skb_put(skb, 2);
-	supp_rates[0] = WLAN_EID_SUPP_RATES;
-	supp_rates[1] = 0;
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
-	for (i = 0; i < sband->n_bitrates; i++) {
-		struct ieee80211_rate *rate = &sband->bitrates[i];
-		if (esupp_rates) {
-			pos = skb_put(skb, 1);
-			esupp_rates[1]++;
-		} else if (supp_rates[1] == 8) {
-			esupp_rates = skb_put(skb, 3);
-			esupp_rates[0] = WLAN_EID_EXT_SUPP_RATES;
-			esupp_rates[1] = 1;
-			pos = &esupp_rates[2];
-		} else {
-			pos = skb_put(skb, 1);
-			supp_rates[1]++;
-		}
-		*pos = rate->bitrate / 5;
-	}
-
-	/* if adding more here, adjust max_scan_ie_len */
-
-	if (ie)
-		memcpy(skb_put(skb, ie_len), ie, ie_len);
+	skb_put(skb, ieee80211_build_preq_ies(local, pos, ie, ie_len));
 
 	ieee80211_tx_skb(sdata, skb, 0);
 }
--- wireless-testing.orig/net/mac80211/main.c	2009-03-31 11:48:50.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-03-31 11:48:51.000000000 +0200
@@ -725,22 +725,12 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	wiphy->privid = mac80211_wiphy_privid;
 
-	if (!ops->hw_scan) {
-		/* For hw_scan, driver needs to set these up. */
-		wiphy->max_scan_ssids = 4;
-
-		/* we support a maximum of 32 rates in cfg80211 */
-		wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN
-					 - 2 - 32 /* SSID */
-					 - 4 - 32 /* (ext) supp rates */;
-
-	}
-
 	/* Yes, putting cfg80211_bss into ieee80211_bss is a hack */
 	wiphy->bss_priv_size = sizeof(struct ieee80211_bss) -
 			       sizeof(struct cfg80211_bss);
 
 	local = wiphy_priv(wiphy);
+
 	local->hw.wiphy = wiphy;
 
 	local->hw.priv = (char *)local +
@@ -827,7 +817,7 @@ int ieee80211_register_hw(struct ieee802
 	enum ieee80211_band band;
 	struct net_device *mdev;
 	struct ieee80211_master_priv *mpriv;
-	int channels, i, j;
+	int channels, i, j, max_bitrates;
 
 	/*
 	 * generic code guarantees at least one band,
@@ -835,18 +825,23 @@ int ieee80211_register_hw(struct ieee802
 	 * that hw.conf.channel is assigned
 	 */
 	channels = 0;
+	max_bitrates = 0;
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		struct ieee80211_supported_band *sband;
 
 		sband = local->hw.wiphy->bands[band];
-		if (sband && !local->oper_channel) {
+		if (!sband)
+			continue;
+		if (!local->oper_channel) {
 			/* init channel we're on */
 			local->hw.conf.channel =
 			local->oper_channel =
 			local->scan_channel = &sband->channels[0];
 		}
-		if (sband)
-			channels += sband->n_channels;
+		channels += sband->n_channels;
+
+		if (max_bitrates < sband->n_bitrates)
+			max_bitrates = sband->n_bitrates;
 	}
 
 	local->int_scan_req.n_channels = channels;
@@ -866,6 +861,30 @@ int ieee80211_register_hw(struct ieee802
 	else if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
 		local->hw.wiphy->signal_type = CFG80211_SIGNAL_TYPE_UNSPEC;
 
+	/*
+	 * Calculate scan IE length -- we need this to alloc
+	 * memory and to subtract from the driver limit. It
+	 * includes the (extended) supported rates and HT
+	 * information -- SSID is the driver's responsibility.
+	 */
+	local->scan_ies_len = 4 + max_bitrates; /* (ext) supp rates */
+
+	if (!local->ops->hw_scan) {
+		/* For hw_scan, driver needs to set these up. */
+		local->hw.wiphy->max_scan_ssids = 4;
+		local->hw.wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
+	}
+
+	/*
+	 * If the driver supports any scan IEs, then assume the
+	 * limit includes the IEs mac80211 will add, otherwise
+	 * leave it at zero and let the driver sort it out; we
+	 * still pass our IEs to the driver but userspace will
+	 * not be allowed to in that case.
+	 */
+	if (local->hw.wiphy->max_scan_ie_len)
+		local->hw.wiphy->max_scan_ie_len -= local->scan_ies_len;
+
 	result = wiphy_register(local->hw.wiphy);
 	if (result < 0)
 		goto fail_wiphy_register;
--- wireless-testing.orig/net/mac80211/scan.c	2009-03-31 11:48:49.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-03-31 11:48:51.000000000 +0200
@@ -286,6 +286,12 @@ void ieee80211_scan_completed(struct iee
 	if (WARN_ON(!local->scan_req))
 		return;
 
+	if (local->hw_scanning) {
+		kfree(local->scan_req->ie);
+		local->scan_req->ie = local->orig_ies;
+		local->scan_req->ie_len = local->orig_ies_len;
+	}
+
 	if (local->scan_req != &local->int_scan_req)
 		cfg80211_scan_done(local->scan_req, aborted);
 	local->scan_req = NULL;
@@ -456,12 +462,28 @@ int ieee80211_start_scan(struct ieee8021
 	}
 
 	if (local->ops->hw_scan) {
-		int rc;
+		u8 *ies;
+		int rc, ielen;
+
+		ies = kmalloc(2 + IEEE80211_MAX_SSID_LEN +
+			      local->scan_ies_len + req->ie_len, GFP_KERNEL);
+		if (!ies)
+			return -ENOMEM;
+
+		ielen = ieee80211_build_preq_ies(local, ies,
+						 req->ie, req->ie_len);
+		local->orig_ies = req->ie;
+		local->orig_ies_len = req->ie_len;
+		req->ie = ies;
+		req->ie_len = ielen;
 
 		local->hw_scanning = true;
 		rc = drv_hw_scan(local, req);
 		if (rc) {
 			local->hw_scanning = false;
+			kfree(ies);
+			req->ie_len = local->orig_ies_len;
+			req->ie = local->orig_ies;
 			return rc;
 		}
 		local->scan_sdata = scan_sdata;
--- wireless-testing.orig/include/net/cfg80211.h	2009-03-31 11:42:15.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-03-31 11:48:51.000000000 +0200
@@ -504,7 +504,7 @@ struct cfg80211_scan_request {
 	int n_ssids;
 	struct ieee80211_channel **channels;
 	u32 n_channels;
-	u8 *ie;
+	const u8 *ie;
 	size_t ie_len;
 
 	/* internal */
--- wireless-testing.orig/net/wireless/nl80211.c	2009-03-31 11:48:50.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-03-31 11:48:51.000000000 +0200
@@ -2561,7 +2561,8 @@ static int nl80211_trigger_scan(struct s
 
 	if (info->attrs[NL80211_ATTR_IE]) {
 		request->ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
-		memcpy(request->ie, nla_data(info->attrs[NL80211_ATTR_IE]),
+		memcpy((void *)request->ie,
+		       nla_data(info->attrs[NL80211_ATTR_IE]),
 		       request->ie_len);
 	}
 

-- 

