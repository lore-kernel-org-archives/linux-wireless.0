Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:27289 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab2JCIzX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 04:55:23 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [RFC] nl/cfg80211: force scan using an AP vif if requested
Date: Wed,  3 Oct 2012 10:54:42 +0200
Message-Id: <1349254482-31743-1-git-send-email-ordex@autistici.org> (sfid-20121003_105939_571713_10D0C349)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the user wants to scan using a vif configured as AP, cfg80211 must give him a
chance to do it, even if this will disrupt the stations performance due to
off-channel scanning. To do so, this patch adds a 'force' flag to the
SCAN_TRIGGER command which tells cfg80211 to perform the scanning operation even
if the vif is an AP and the beaconing has already started.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---

* in several scenarios the user would like to perform a scan while an AP vif is
  running. This can happen when the user wants to check if there is a less
  polluted channel on which he wants to move the AP. In the current
  implementation this is not allowed at all. The only way to perform this
  operation consists in creating another vif configured as managed and scan
  channels using it. With the approach proposed by this patch, instead, the
  user can simply "force" the scan on the AP interface (e.g. using iw).




 include/linux/nl80211.h | 8 ++++++++
 include/net/cfg80211.h  | 2 ++
 net/mac80211/cfg.c      | 9 ++++++++-
 net/wireless/nl80211.c  | 2 ++
 4 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 179a0c2..7e347c1 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1276,6 +1276,12 @@ enum nl80211_commands {
  * @NL80211_ATTR_SAE_DATA: SAE elements in Authentication frames. This starts
  *	with the Authentication transaction sequence number field.
  *
+ * @NL80211_ATTR_SCAN_FORCE: force a scan even if the interface is configured as
+ *	AP and the beaconing has already been configured. This attribute is
+ *	dangerous because will destroy stations performance as a lot of frames
+ *	will be lost while scanning off-channel, therefore it must be used only
+ *	when really needed.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1535,6 +1541,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SAE_DATA,
 
+	NL80211_ATTR_SCAN_FORCE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 04df773..600e2c7 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1005,6 +1005,7 @@ struct cfg80211_ssid {
  * @wdev: the wireless device to scan for
  * @aborted: (internal) scan request was notified as aborted
  * @no_cck: used to send probe requests at non CCK rate in 2GHz band
+ * @force: scan even if the vif is in AP mode and beacon has been set already
  */
 struct cfg80211_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -1021,6 +1022,7 @@ struct cfg80211_scan_request {
 	struct wiphy *wiphy;
 	bool aborted;
 	bool no_cck;
+	bool force;
 
 	/* keep last */
 	struct ieee80211_channel *channels[0];
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 03216b0..4f932c5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1850,7 +1850,14 @@ static int ieee80211_scan(struct wiphy *wiphy,
 		 * beaconing hasn't been configured yet
 		 */
 	case NL80211_IFTYPE_AP:
-		if (sdata->u.ap.beacon)
+		/*
+		 * If the scan has been forced, don't care about being beaconing
+		 * already.
+		 * This will create problems to the attached stations (e.g. all
+		 * the  frames sent while scanning on other channel will be
+		 * lost)
+		 */
+		if (sdata->u.ap.beacon && !req->force)
 			return -EOPNOTSUPP;
 		break;
 	default:
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 746f649..94758df 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4362,6 +4362,8 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
+	request->force = nla_get_flag(info->attrs[NL80211_ATTR_SCAN_FORCE]);
+
 	request->no_cck =
 		nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
 
-- 
1.7.12

