Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38387 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbbDGL5P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 07:57:15 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] cfg80211: send extended capabilities IE in connect
Date: Tue,  7 Apr 2015 13:57:00 +0200
Message-Id: <1428407820-4099-2-git-send-email-johannes@sipsolutions.net> (sfid-20150407_135718_195032_D2FD09DA)
In-Reply-To: <1428407820-4099-1-git-send-email-johannes@sipsolutions.net>
References: <1428407820-4099-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the connect request from userspace didn't include an extended
capabilities IE, create one using the driver capabilities. This
fixes VHT associations, since those need to set the operating mode
notification capability.

Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/sme.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 64 insertions(+), 10 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index ea1da6621ff0..d11454f87bac 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -42,7 +42,7 @@ struct cfg80211_conn {
 		CFG80211_CONN_CONNECTED,
 	} state;
 	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
-	u8 *ie;
+	const u8 *ie;
 	size_t ie_len;
 	bool auto_auth, prev_bssid_valid;
 };
@@ -423,6 +423,62 @@ void cfg80211_sme_assoc_timeout(struct wireless_dev *wdev)
 	schedule_work(&rdev->conn_work);
 }
 
+static int cfg80211_sme_get_conn_ies(struct wireless_dev *wdev,
+				     const u8 *ies, size_t ies_len,
+				     const u8 **out_ies, size_t *out_ies_len)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	u8 *buf;
+	size_t offs;
+
+	if (!rdev->wiphy.extended_capabilities_len ||
+	    (ies && cfg80211_find_ie(WLAN_EID_EXT_CAPABILITY, ies, ies_len))) {
+		*out_ies = kmemdup(ies, ies_len, GFP_KERNEL);
+		if (!*out_ies)
+			return -ENOMEM;
+		*out_ies_len = ies_len;
+		return 0;
+	}
+
+	buf = kmalloc(ies_len + rdev->wiphy.extended_capabilities_len + 2,
+		      GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	if (ies_len) {
+		static const u8 before_extcapa[] = {
+			/* not listing IEs expected to be created by driver */
+			WLAN_EID_RSN,
+			WLAN_EID_QOS_CAPA,
+			WLAN_EID_RRM_ENABLED_CAPABILITIES,
+			WLAN_EID_MOBILITY_DOMAIN,
+			WLAN_EID_SUPPORTED_REGULATORY_CLASSES,
+			WLAN_EID_BSS_COEX_2040,
+		};
+
+		offs = ieee80211_ie_split(ies, ies_len, before_extcapa,
+					  ARRAY_SIZE(before_extcapa), 0);
+		memcpy(buf, ies, offs);
+		/* leave a whole for extended capabilities IE */
+		memcpy(buf + offs + rdev->wiphy.extended_capabilities_len + 2,
+		       ies + offs, ies_len - offs);
+	} else {
+		offs = 0;
+	}
+
+	/* place extended capabilities IE (with only driver capabilities) */
+	buf[offs] = WLAN_EID_EXT_CAPABILITY;
+	buf[offs + 1] = rdev->wiphy.extended_capabilities_len;
+	memcpy(buf + offs + 2,
+	       rdev->wiphy.extended_capabilities,
+	       rdev->wiphy.extended_capabilities_len);
+
+	*out_ies = buf;
+	*out_ies_len = ies_len + rdev->wiphy.extended_capabilities_len + 2;
+
+	return 0;
+}
+
 static int cfg80211_sme_connect(struct wireless_dev *wdev,
 				struct cfg80211_connect_params *connect,
 				const u8 *prev_bssid)
@@ -453,16 +509,14 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
 		memcpy(wdev->conn->bssid, connect->bssid, ETH_ALEN);
 	}
 
-	if (connect->ie) {
-		wdev->conn->ie = kmemdup(connect->ie, connect->ie_len,
-					GFP_KERNEL);
-		wdev->conn->params.ie = wdev->conn->ie;
-		if (!wdev->conn->ie) {
-			kfree(wdev->conn);
-			wdev->conn = NULL;
-			return -ENOMEM;
-		}
+	if (cfg80211_sme_get_conn_ies(wdev, connect->ie, connect->ie_len,
+				      &wdev->conn->ie,
+				      &wdev->conn->params.ie_len)) {
+		kfree(wdev->conn);
+		wdev->conn = NULL;
+		return -ENOMEM;
 	}
+	wdev->conn->params.ie = wdev->conn->ie;
 
 	if (connect->auth_type == NL80211_AUTHTYPE_AUTOMATIC) {
 		wdev->conn->auto_auth = true;
-- 
2.1.4

