Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0049.outbound.protection.outlook.com ([104.47.37.49]:63024
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752185AbeBUK4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Feb 2018 05:56:55 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>
Subject: [PATCH] cfg80211/nl80211: add DFS offload flag
Date: Wed, 21 Feb 2018 13:56:35 +0300
Message-Id: <20180221105635.5824-1-sergey.matyukevich.os@quantenna.com> (sfid-20180221_115659_857749_DB8136D5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dmitry Lebed <dlebed@quantenna.com>

Add wiphy flag to indicate that HW does all DFS actions by itself.
User-space functionality already implemented in hostapd using
vendor-specific (QCA) OUI to advertise HW support.
Need to introduce generic flag to inform about DFS offload support.
For deivces with DFS_OFFLOAD flag set user-space will no longer
need to issue CAC or do any actions in response to
"radar detected" events. HW will do everything by itself and send
events to user-space to idicate that CAC was started/finished, etc.

Signed-off-by: Dmitrii Lebed <dlebed@quantenna.com>
---
 include/net/cfg80211.h       | 7 ++++++-
 include/uapi/linux/nl80211.h | 9 +++++++++
 net/wireless/nl80211.c       | 7 +++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ed3a28105d6c..b2d17993ae4d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3241,6 +3241,11 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_IBSS_RSN: The device supports IBSS RSN.
  * @WIPHY_FLAG_MESH_AUTH: The device supports mesh authentication by routing
  *	auth frames to userspace. See @NL80211_MESH_SETUP_USERSPACE_AUTH.
+ * @WIPHY_FLAG_DFS_OFFLOAD: Device will do all DFS-related actions by itself,
+ *	informing user-space about CAC progress, radar detection event,
+ *	channel change triggered by radar detection event.
+ *	No need to start CAC from user-space, no need to react to
+ *	"radar detected" event.
  * @WIPHY_FLAG_SUPPORTS_FW_ROAM: The device supports roaming feature in the
  *	firmware.
  * @WIPHY_FLAG_AP_UAPSD: The device supports uapsd on AP.
@@ -3275,7 +3280,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
 	WIPHY_FLAG_IBSS_RSN			= BIT(8),
 	WIPHY_FLAG_MESH_AUTH			= BIT(10),
-	/* use hole at 11 */
+	WIPHY_FLAG_DFS_OFFLOAD			= BIT(11),
 	/* use hole at 12 */
 	WIPHY_FLAG_SUPPORTS_FW_ROAM		= BIT(13),
 	WIPHY_FLAG_AP_UAPSD			= BIT(14),
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 22cca373161d..c53281397be6 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2156,6 +2156,13 @@ enum nl80211_commands {
  * @NL80211_ATTR_PMKR0_NAME: PMK-R0 Name for offloaded FT.
  * @NL80211_ATTR_PORT_AUTHORIZED: (reserved)
  *
+ * @NL80211_ATTR_DFS_OFFLOAD: Indicates that the HW will offload DFS actions.
+ *	Device will do all DFS-related actions by itself,
+ *	informing user-space about CAC progress, radar detection event,
+ *	channel change triggered by radar detection event.
+ *	No need to start CAC from user-space, no need to react to
+ *	"radar detected" event.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2582,6 +2589,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_PMKR0_NAME,
 	NL80211_ATTR_PORT_AUTHORIZED,
 
+	NL80211_ATTR_DFS_OFFLOAD,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b5e613d14d6a..635bf4143d03 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1530,6 +1530,9 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		if ((rdev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP) &&
 		    nla_put_flag(msg, NL80211_ATTR_TDLS_EXTERNAL_SETUP))
 			goto nla_put_failure;
+		if ((rdev->wiphy.flags & WIPHY_FLAG_DFS_OFFLOAD) &&
+		    nla_put_flag(msg, NL80211_ATTR_DFS_OFFLOAD))
+			goto nla_put_failure;
 		state->split_start++;
 		if (state->split)
 			break;
@@ -7816,6 +7819,10 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (!cfg80211_chandef_dfs_usable(wdev->wiphy, &chandef))
 		return -EINVAL;
 
+	/* CAC start is offloaded to HW and can't be started manually */
+	if (wdev->wiphy->flags & WIPHY_FLAG_DFS_OFFLOAD)
+		return -EOPNOTSUPP;
+
 	if (!rdev->ops->start_radar_detection)
 		return -EOPNOTSUPP;
 
-- 
2.11.0
