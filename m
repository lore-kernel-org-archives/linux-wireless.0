Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53642 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbZGGMh0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 08:37:26 -0400
Subject: [PATCH -1/3] cfg80211: let SME control reassociation vs.
 association
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090707014515.024822579@sipsolutions.net>
References: <20090707014515.024822579@sipsolutions.net>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 14:37:26 +0200
Message-Id: <1246970246.4755.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we don't really know that well in the kernel,
let's let the SME control whether it wants to use
reassociation or not, by allowing it to give the
previous BSSID in the associate() parameters.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Oops, forgot to send this one out, it needs to be in front of this
series (and this series needs to be in front of the cfg80211 series) for
it all to apply properly.

 include/linux/nl80211.h |    5 +++++
 include/net/cfg80211.h  |    3 ++-
 net/mac80211/cfg.c      |    6 ++++++
 net/mac80211/mlme.c     |    7 -------
 net/wireless/core.h     |    3 ++-
 net/wireless/mlme.c     |    4 +++-
 net/wireless/nl80211.c  |   10 +++++++---
 net/wireless/sme.c      |    8 +++++++-
 8 files changed, 32 insertions(+), 14 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2009-07-07 03:29:38.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2009-07-07 03:36:58.000000000 +0200
@@ -564,6 +564,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_RESP_IE: (Re)association response information elements as
  *	sent by peer, for ROAM and successful CONNECT events.
  *
+ * @NL80211_ATTR_PREV_BSSID: previous BSSID, to be used by in ASSOCIATE
+ *	commands to specify using a reassociate frame
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -687,6 +690,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_REQ_IE,
 	NL80211_ATTR_RESP_IE,
 
+	NL80211_ATTR_PREV_BSSID,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- wireless-testing.orig/net/wireless/nl80211.c	2009-07-07 03:29:39.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-07-07 03:36:58.000000000 +0200
@@ -71,6 +71,7 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_IFNAME] = { .type = NLA_NUL_STRING, .len = IFNAMSIZ-1 },
 
 	[NL80211_ATTR_MAC] = { .type = NLA_BINARY, .len = ETH_ALEN },
+	[NL80211_ATTR_PREV_BSSID] = { .type = NLA_BINARY, .len = ETH_ALEN },
 
 	[NL80211_ATTR_KEY_DATA] = { .type = NLA_BINARY,
 				    .len = WLAN_MAX_KEY_LEN },
@@ -3187,7 +3188,7 @@ static int nl80211_associate(struct sk_b
 	struct net_device *dev;
 	struct cfg80211_crypto_settings crypto;
 	struct ieee80211_channel *chan;
-	const u8 *bssid, *ssid, *ie = NULL;
+	const u8 *bssid, *ssid, *ie = NULL, *prev_bssid = NULL;
 	int err, ssid_len, ie_len = 0;
 	bool use_mfp = false;
 
@@ -3248,10 +3249,13 @@ static int nl80211_associate(struct sk_b
 		}
 	}
 
+	if (info->attrs[NL80211_ATTR_PREV_BSSID])
+		prev_bssid = nla_data(info->attrs[NL80211_ATTR_PREV_BSSID]);
+
 	err = nl80211_crypto_settings(info, &crypto, 1);
 	if (!err)
-		err = cfg80211_mlme_assoc(rdev, dev, chan, bssid, ssid,
-					  ssid_len, ie, ie_len, use_mfp,
+		err = cfg80211_mlme_assoc(rdev, dev, chan, bssid, prev_bssid,
+					  ssid, ssid_len, ie, ie_len, use_mfp,
 					  &crypto);
 
 out:
--- wireless-testing.orig/include/net/cfg80211.h	2009-07-07 03:29:38.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-07-07 03:36:58.000000000 +0200
@@ -664,10 +664,11 @@ struct cfg80211_auth_request {
  * @ie_len: Length of ie buffer in octets
  * @use_mfp: Use management frame protection (IEEE 802.11w) in this association
  * @crypto: crypto settings
+ * @prev_bssid: previous BSSID, if not %NULL use reassociate frame
  */
 struct cfg80211_assoc_request {
 	struct cfg80211_bss *bss;
-	const u8 *ie;
+	const u8 *ie, *prev_bssid;
 	size_t ie_len;
 	struct cfg80211_crypto_settings crypto;
 	bool use_mfp;
--- wireless-testing.orig/net/wireless/core.h	2009-07-07 03:29:39.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-07-07 03:36:58.000000000 +0200
@@ -202,7 +202,8 @@ int cfg80211_mlme_auth(struct cfg80211_r
 		       const u8 *ie, int ie_len);
 int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, struct ieee80211_channel *chan,
-			const u8 *bssid, const u8 *ssid, int ssid_len,
+			const u8 *bssid, const u8 *prev_bssid,
+			const u8 *ssid, int ssid_len,
 			const u8 *ie, int ie_len, bool use_mfp,
 			struct cfg80211_crypto_settings *crypt);
 int cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
--- wireless-testing.orig/net/wireless/mlme.c	2009-07-07 03:29:39.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2009-07-07 03:36:58.000000000 +0200
@@ -335,7 +335,8 @@ int cfg80211_mlme_auth(struct cfg80211_r
 
 int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, struct ieee80211_channel *chan,
-			const u8 *bssid, const u8 *ssid, int ssid_len,
+			const u8 *bssid, const u8 *prev_bssid,
+			const u8 *ssid, int ssid_len,
 			const u8 *ie, int ie_len, bool use_mfp,
 			struct cfg80211_crypto_settings *crypt)
 {
@@ -353,6 +354,7 @@ int cfg80211_mlme_assoc(struct cfg80211_
 	req.ie_len = ie_len;
 	memcpy(&req.crypto, crypt, sizeof(req.crypto));
 	req.use_mfp = use_mfp;
+	req.prev_bssid = prev_bssid;
 	req.bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
 				   WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
 	if (!req.bss)
--- wireless-testing.orig/net/wireless/sme.c	2009-07-07 03:29:39.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-07-07 03:36:58.000000000 +0200
@@ -125,8 +125,14 @@ static int cfg80211_conn_do_work(struct 
 	case CFG80211_CONN_ASSOCIATE_NEXT:
 		BUG_ON(!drv->ops->assoc);
 		wdev->conn->state = CFG80211_CONN_ASSOCIATING;
+		/*
+		 * We could, later, implement roaming here and then actually
+		 * set prev_bssid to non-NULL. But then we need to be aware
+		 * that some APs don't like that -- so we'd need to retry
+		 * the association.
+		 */
 		err = cfg80211_mlme_assoc(drv, wdev->netdev,
-					  params->channel, params->bssid,
+					  params->channel, params->bssid, NULL,
 					  params->ssid, params->ssid_len,
 					  params->ie, params->ie_len,
 					  false, &params->crypto);
--- wireless-testing.orig/net/mac80211/cfg.c	2009-07-07 03:29:38.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-07-07 03:36:58.000000000 +0200
@@ -1256,6 +1256,12 @@ static int ieee80211_assoc(struct wiphy 
 		sdata->u.mgd.flags &= ~IEEE80211_STA_MFP_ENABLED;
 	}
 
+	if (req->prev_bssid) {
+		sdata->u.mgd.flags |= IEEE80211_STA_PREV_BSSID_SET;
+		memcpy(sdata->u.mgd.prev_bssid, req->prev_bssid, ETH_ALEN);
+	} else
+		sdata->u.mgd.flags &= ~IEEE80211_STA_PREV_BSSID_SET;
+
 	if (req->crypto.control_port)
 		sdata->u.mgd.flags |= IEEE80211_STA_CONTROL_PORT;
 	else
--- wireless-testing.orig/net/mac80211/mlme.c	2009-07-07 03:29:38.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-07-07 03:36:58.000000000 +0200
@@ -879,9 +879,6 @@ static void ieee80211_set_associated(str
 		ieee80211_rx_bss_put(local, bss);
 	}
 
-	ifmgd->flags |= IEEE80211_STA_PREV_BSSID_SET;
-	memcpy(ifmgd->prev_bssid, sdata->u.mgd.bssid, ETH_ALEN);
-
 	ifmgd->last_probe = jiffies;
 	ieee80211_led_assoc(local, 1);
 
@@ -1470,10 +1467,6 @@ static void ieee80211_rx_mgmt_assoc_resp
 	if (status_code != WLAN_STATUS_SUCCESS) {
 		printk(KERN_DEBUG "%s: AP denied association (code=%d)\n",
 		       sdata->dev->name, status_code);
-		/* if this was a reassociation, ensure we try a "full"
-		 * association next time. This works around some broken APs
-		 * which do not correctly reject reassociation requests. */
-		ifmgd->flags &= ~IEEE80211_STA_PREV_BSSID_SET;
 		cfg80211_send_rx_assoc(sdata->dev, (u8 *) mgmt, len,
 				       GFP_KERNEL);
 		/* Wait for SME to decide what to do next */


