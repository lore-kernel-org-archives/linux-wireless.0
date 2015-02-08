Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:52783 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbbBHNx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2015 08:53:27 -0500
From: Dedy Lansky <dlansky@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dedy Lansky <dlansky@codeaurora.org>,
	linux-wireless@vger.kernel.org,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Subject: [PATCH v2 2/2] cfg80211: add support for connecting to PBSS network type
Date: Sun,  8 Feb 2015 15:52:04 +0200
Message-Id: <1423403524-22540-3-git-send-email-dlansky@codeaurora.org> (sfid-20150208_145334_053325_F37E970B)
In-Reply-To: <1423403524-22540-1-git-send-email-dlansky@codeaurora.org>
References: <1423403524-22540-1-git-send-email-dlansky@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sme.c assumes BSS is of ESS type. With 802.11ad and the new PBSS network
type, this is not always true.
On DMG (60GHz) band, P2P connection uses PBSS network. Detect P2P
connection for DMG band and adjust BSS type to PBSS.

When connect starts (cfg80211_connect), store the bss type in new field in wdev
(conn_bss_type). This field is used later (e.g. in __cfg80211_connect_result)
when calling cfg80211_get_bss() for finding the BSS we are connecting to.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
---
 include/net/cfg80211.h |  2 ++
 net/wireless/sme.c     | 12 +++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index acf8f09..da346b1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3426,6 +3426,7 @@ struct cfg80211_cached_keys;
  *	registered for unexpected class 3 frames (AP mode)
  * @conn: (private) cfg80211 software SME connection state machine data
  * @connect_keys: (private) keys to set after connection is established
+ * @conn_bss_type: connecting/connected BSS type
  * @ibss_fixed: (private) IBSS is using fixed BSSID
  * @ibss_dfs_possible: (private) IBSS may change to a DFS channel
  * @event_list: (private) list for internal event processing
@@ -3456,6 +3457,7 @@ struct wireless_dev {
 	u8 ssid_len, mesh_id_len, mesh_id_up_len;
 	struct cfg80211_conn *conn;
 	struct cfg80211_cached_keys *connect_keys;
+	enum ieee80211_bss_type conn_bss_type;
 
 	struct list_head event_list;
 	spinlock_t event_lock;
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index ea1da66..bf79bf2 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -264,7 +264,7 @@ static struct cfg80211_bss *cfg80211_get_conn_bss(struct wireless_dev *wdev)
 			       wdev->conn->params.bssid,
 			       wdev->conn->params.ssid,
 			       wdev->conn->params.ssid_len,
-			       IEEE80211_BSS_TYPE_ESS,
+			       wdev->conn_bss_type,
 			       IEEE80211_PRIVACY(wdev->conn->params.privacy));
 	if (!bss)
 		return NULL;
@@ -633,7 +633,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 		WARN_ON_ONCE(!wiphy_to_rdev(wdev->wiphy)->ops->connect);
 		bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
 				       wdev->ssid, wdev->ssid_len,
-				       IEEE80211_BSS_TYPE_ESS,
+				       wdev->conn_bss_type,
 				       IEEE80211_PRIVACY_ANY);
 		if (bss)
 			cfg80211_hold_bss(bss_from_pub(bss));
@@ -792,7 +792,7 @@ void cfg80211_roamed(struct net_device *dev,
 
 	bss = cfg80211_get_bss(wdev->wiphy, channel, bssid, wdev->ssid,
 			       wdev->ssid_len,
-			       IEEE80211_BSS_TYPE_ESS, IEEE80211_PRIVACY_ANY);
+			       wdev->conn_bss_type, IEEE80211_PRIVACY_ANY);
 	if (WARN_ON(!bss))
 		return;
 
@@ -961,6 +961,12 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 	memcpy(wdev->ssid, connect->ssid, connect->ssid_len);
 	wdev->ssid_len = connect->ssid_len;
 
+	wdev->conn_bss_type = IEEE80211_BSS_TYPE_ESS;
+	if (connect->channel &&
+	    connect->channel->band == IEEE80211_BAND_60GHZ &&
+	    wdev->iftype == NL80211_IFTYPE_P2P_CLIENT)
+		wdev->conn_bss_type = IEEE80211_BSS_TYPE_PBSS;
+
 	if (!rdev->ops->connect)
 		err = cfg80211_sme_connect(wdev, connect, prev_bssid);
 	else
-- 
1.9.1

