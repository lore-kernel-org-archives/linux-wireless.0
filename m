Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:54559 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab1KYLRn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 06:17:43 -0500
Subject: [PATCH] ath6kl: cleanup ath6kl_priv()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 25 Nov 2011 13:17:37 +0200
Message-ID: <20111125111736.31760.12343.stgit@localhost6.localdomain6> (sfid-20111125_121746_311573_36EFC5E7)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It really should not return a void pointer. Also remove useless casts
from its users.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   10 +++++-----
 drivers/net/wireless/ath/ath6kl/core.h     |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index aa93527..196eb24 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -706,7 +706,7 @@ void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
 static int ath6kl_cfg80211_disconnect(struct wiphy *wiphy,
 				      struct net_device *dev, u16 reason_code)
 {
-	struct ath6kl *ar = (struct ath6kl *)ath6kl_priv(dev);
+	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_vif *vif = netdev_priv(dev);
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: reason=%u\n", __func__,
@@ -804,7 +804,7 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 				struct cfg80211_scan_request *request)
 {
-	struct ath6kl *ar = (struct ath6kl *)ath6kl_priv(ndev);
+	struct ath6kl *ar = ath6kl_priv(ndev);
 	struct ath6kl_vif *vif = netdev_priv(ndev);
 	s8 n_channels = 0;
 	u16 *channels = NULL;
@@ -920,7 +920,7 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 				   const u8 *mac_addr,
 				   struct key_params *params)
 {
-	struct ath6kl *ar = (struct ath6kl *)ath6kl_priv(ndev);
+	struct ath6kl *ar = ath6kl_priv(ndev);
 	struct ath6kl_vif *vif = netdev_priv(ndev);
 	struct ath6kl_key *key = NULL;
 	u8 key_usage;
@@ -1045,7 +1045,7 @@ static int ath6kl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 				   u8 key_index, bool pairwise,
 				   const u8 *mac_addr)
 {
-	struct ath6kl *ar = (struct ath6kl *)ath6kl_priv(ndev);
+	struct ath6kl *ar = ath6kl_priv(ndev);
 	struct ath6kl_vif *vif = netdev_priv(ndev);
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: index %d\n", __func__, key_index);
@@ -1111,7 +1111,7 @@ static int ath6kl_cfg80211_set_default_key(struct wiphy *wiphy,
 					   u8 key_index, bool unicast,
 					   bool multicast)
 {
-	struct ath6kl *ar = (struct ath6kl *)ath6kl_priv(ndev);
+	struct ath6kl *ar = ath6kl_priv(ndev);
 	struct ath6kl_vif *vif = netdev_priv(ndev);
 	struct ath6kl_key *key = NULL;
 	u8 key_usage;
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 96f65c9..36bd85d 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -618,7 +618,7 @@ struct ath6kl {
 #endif /* CONFIG_ATH6KL_DEBUG */
 };
 
-static inline void *ath6kl_priv(struct net_device *dev)
+static inline struct ath6kl *ath6kl_priv(struct net_device *dev)
 {
 	return ((struct ath6kl_vif *) netdev_priv(dev))->ar;
 }

