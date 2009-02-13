Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:42153 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536AbZBMKxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 05:53:25 -0500
Date: Fri, 13 Feb 2009 12:53:06 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Optional IEs into scan request
Message-ID: <20090213105306.GA18754@jm.kir.nu> (sfid-20090213_115331_325403_65643DA6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This extends the NL80211_CMD_TRIGGER_SCAN command to allow applications
to specify a set of information element(s) to be added into Probe
Request frames with NL80211_ATTR_IE. This provides support for the
MLME-SCAN.request primitive parameter VendorSpecificInfo and can be
used, e.g., to implement WPS scanning.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 include/net/cfg80211.h     |    4 ++++
 net/mac80211/ieee80211_i.h |    3 ++-
 net/mac80211/mlme.c        |   14 +++++++++-----
 net/mac80211/scan.c        |    3 ++-
 net/wireless/nl80211.c     |   21 ++++++++++++++++++++-
 5 files changed, 37 insertions(+), 8 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-02-13 12:47:56.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-02-13 12:48:45.000000000 +0200
@@ -525,6 +525,8 @@ struct cfg80211_ssid {
  * @n_ssids: number of SSIDs
  * @channels: channels to scan on.
  * @n_channels: number of channels for each band
+ * @ie: optional information element(s) to add into Probe Request or %NULL
+ * @ie_len: length of ie in octets
  * @wiphy: the wiphy this was for
  * @ifidx: the interface index
  */
@@ -533,6 +535,8 @@ struct cfg80211_scan_request {
 	int n_ssids;
 	struct ieee80211_channel **channels;
 	u32 n_channels;
+	u8 *ie;
+	size_t ie_len;
 
 	/* internal */
 	struct wiphy *wiphy;
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-02-13 12:47:56.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-02-13 12:48:45.000000000 +0200
@@ -911,7 +911,8 @@ u32 ieee80211_sta_get_rates(struct ieee8
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band);
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
-			      u8 *ssid, size_t ssid_len);
+			      u8 *ssid, size_t ssid_len,
+			      u8 *ie, size_t ie_len);
 void ieee80211_send_pspoll(struct ieee80211_local *local,
 			   struct ieee80211_sub_if_data *sdata);
 
--- wireless-testing.orig/net/mac80211/mlme.c	2009-02-13 12:47:56.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-02-13 12:48:45.000000000 +0200
@@ -139,7 +139,8 @@ static void add_extra_ies(struct sk_buff
 
 /* also used by scanning code */
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
-			      u8 *ssid, size_t ssid_len)
+			      u8 *ssid, size_t ssid_len,
+			      u8 *ie, size_t ie_len)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
@@ -149,7 +150,7 @@ void ieee80211_send_probe_req(struct iee
 	int i;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt) + 200 +
-			    sdata->u.sta.ie_probereq_len);
+			    ie_len + sdata->u.sta.ie_probereq_len);
 	if (!skb) {
 		printk(KERN_DEBUG "%s: failed to allocate buffer for probe "
 		       "request\n", sdata->dev->name);
@@ -196,6 +197,7 @@ void ieee80211_send_probe_req(struct iee
 		*pos = rate->bitrate / 5;
 	}
 
+	add_extra_ies(skb, ie, ie_len);
 	add_extra_ies(skb, sdata->u.sta.ie_probereq,
 		      sdata->u.sta.ie_probereq_len);
 
@@ -891,7 +893,7 @@ static void ieee80211_direct_probe(struc
 	 * will not answer to direct packet in unassociated state.
 	 */
 	ieee80211_send_probe_req(sdata, NULL,
-				 ifsta->ssid, ifsta->ssid_len);
+				 ifsta->ssid, ifsta->ssid_len, NULL, 0);
 
 	mod_timer(&ifsta->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
 }
@@ -1116,7 +1118,8 @@ static void ieee80211_associated(struct 
 			} else
 				ieee80211_send_probe_req(sdata, ifsta->bssid,
 							 ifsta->ssid,
-							 ifsta->ssid_len);
+							 ifsta->ssid_len,
+							 NULL, 0);
 			ifsta->flags ^= IEEE80211_STA_PROBEREQ_POLL;
 		} else {
 			ifsta->flags &= ~IEEE80211_STA_PROBEREQ_POLL;
@@ -1125,7 +1128,8 @@ static void ieee80211_associated(struct 
 				ifsta->last_probe = jiffies;
 				ieee80211_send_probe_req(sdata, ifsta->bssid,
 							 ifsta->ssid,
-							 ifsta->ssid_len);
+							 ifsta->ssid_len,
+							 NULL, 0);
 			}
 		}
 	}
--- wireless-testing.orig/net/mac80211/scan.c	2009-02-13 12:47:56.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-02-13 12:48:45.000000000 +0200
@@ -367,7 +367,8 @@ void ieee80211_scan_work(struct work_str
 			ieee80211_send_probe_req(
 				sdata, NULL,
 				local->scan_req->ssids[i].ssid,
-				local->scan_req->ssids[i].ssid_len);
+				local->scan_req->ssids[i].ssid_len,
+				local->scan_req->ie, local->scan_req->ie_len);
 		next_delay = IEEE80211_CHANNEL_TIME;
 		break;
 	}
--- wireless-testing.orig/net/wireless/nl80211.c	2009-02-13 12:47:56.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-02-13 12:48:45.000000000 +0200
@@ -2286,6 +2286,7 @@ static int nl80211_trigger_scan(struct s
 	struct wiphy *wiphy;
 	int err, tmp, n_ssids = 0, n_channels = 0, i;
 	enum ieee80211_band band;
+	size_t ie_len;
 
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
@@ -2327,9 +2328,15 @@ static int nl80211_trigger_scan(struct s
 		goto out_unlock;
 	}
 
+	if (info->attrs[NL80211_ATTR_IE])
+		ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+	else
+		ie_len = 0;
+
 	request = kzalloc(sizeof(*request)
 			+ sizeof(*ssid) * n_ssids
-			+ sizeof(channel) * n_channels, GFP_KERNEL);
+			+ sizeof(channel) * n_channels
+			+ ie_len, GFP_KERNEL);
 	if (!request) {
 		err = -ENOMEM;
 		goto out_unlock;
@@ -2340,6 +2347,12 @@ static int nl80211_trigger_scan(struct s
 	if (n_ssids)
 		request->ssids = (void *)(request->channels + n_channels);
 	request->n_ssids = n_ssids;
+	if (ie_len) {
+		if (request->ssids)
+			request->ie = (void *)(request->ssids + n_ssids);
+		else
+			request->ie = (void *)(request->channels + n_channels);
+	}
 
 	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
 		/* user specified, bail out if channel not found */
@@ -2380,6 +2393,12 @@ static int nl80211_trigger_scan(struct s
 		}
 	}
 
+	if (info->attrs[NL80211_ATTR_IE]) {
+		request->ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+		memcpy(request->ie, nla_data(info->attrs[NL80211_ATTR_IE]),
+		       request->ie_len);
+	}
+
 	request->ifidx = dev->ifindex;
 	request->wiphy = &drv->wiphy;
 

-- 
Jouni Malinen                                            PGP id EFC895FA
