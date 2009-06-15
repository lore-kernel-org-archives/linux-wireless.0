Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:9011 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756448AbZFOPjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 11:39:09 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 12/12][w-t] iwmc3200wifi: rfkill cleanup
Date: Mon, 15 Jun 2009 17:39:28 +0200
Message-Id: <16e288a191db4b51e665c35c4dab20182f4725ac.1245076752.git.samuel@sortiz.org>
In-Reply-To: <24a1d38ec78a5a86d953e25c07ba4461d4552289.1245076752.git.samuel@sortiz.org>
References: <cover.1245076752.git.samuel@sortiz.org>
 <8843005a4ec0cad33483426a4ecc7656bce24243.1245076752.git.samuel@sortiz.org>
 <afbb543a0654cc171faa882457cc603d3f038d27.1245076752.git.samuel@sortiz.org>
 <9b2b9b463d1313b871f56ad77b48b4960653b766.1245076752.git.samuel@sortiz.org>
 <ed1078e3b1524ac3bf3888b0881e40bddc8fb690.1245076752.git.samuel@sortiz.org>
 <99a6f971c65b2fb751206cff9e428eb60037629b.1245076752.git.samuel@sortiz.org>
 <f3d3b8fac2046f9c26773232c585b4c688b8df03.1245076752.git.samuel@sortiz.org>
 <87c8d2a38226859644cfd3217366a4e42d9e7d81.1245076752.git.samuel@sortiz.org>
 <d0337f0d1ddef69bbb0144eb894bafd0580550d6.1245076752.git.samuel@sortiz.org>
 <d0765f00e18e0501dc41d8507f05eb03ec940cdc.1245076752.git.samuel@sortiz.org>
 <d23bf33585e775f6432e246ecb232e29cf0b49ed.1245076752.git.samuel@sortiz.org>
 <24a1d38ec78a5a86d953e25c07ba4461d4552289.1245076752.git.samuel@sortiz.org>
In-Reply-To: <cover.1245076752.git.samuel@sortiz.org>
References: <cover.1245076752.git.samuel@sortiz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

The patch cleans up the unused rfkill related structures and flags.
It also adds wext and cfg80211 handlers for txpower auto and off so
that software rfkill could be issued by user space.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |   24 ++++++++++++++++++++++++
 drivers/net/wireless/iwmc3200wifi/iwm.h      |    7 +------
 drivers/net/wireless/iwmc3200wifi/netdev.c   |    6 ++----
 drivers/net/wireless/iwmc3200wifi/rx.c       |   18 +++++++++---------
 drivers/net/wireless/iwmc3200wifi/sdio.c     |    6 +-----
 drivers/net/wireless/iwmc3200wifi/wext.c     |    4 ++--
 6 files changed, 39 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index 71efbc1..e58026f 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -505,6 +505,28 @@ static int iwm_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 	return 0;
 }
 
+static int iwm_cfg80211_set_txpower(struct wiphy *wiphy,
+				    enum tx_power_setting type, int dbm)
+{
+	switch (type) {
+	case TX_POWER_AUTOMATIC:
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int iwm_cfg80211_get_txpower(struct wiphy *wiphy, int *dbm)
+{
+	struct iwm_priv *iwm = wiphy_to_iwm(wiphy);
+
+	*dbm = iwm->txpower;
+
+	return 0;
+}
+
 static struct cfg80211_ops iwm_cfg80211_ops = {
 	.change_virtual_intf = iwm_cfg80211_change_iface,
 	.add_key = iwm_cfg80211_add_key,
@@ -515,6 +537,8 @@ static struct cfg80211_ops iwm_cfg80211_ops = {
 	.set_wiphy_params = iwm_cfg80211_set_wiphy_params,
 	.join_ibss = iwm_cfg80211_join_ibss,
 	.leave_ibss = iwm_cfg80211_leave_ibss,
+	.set_tx_power = iwm_cfg80211_set_txpower,
+	.get_tx_power = iwm_cfg80211_get_txpower,
 };
 
 struct wireless_dev *iwm_wdev_alloc(int sizeof_bus, struct device *dev)
diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index a08c6e9..f187f34 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -185,10 +185,6 @@ struct iwm_key {
 #define IWM_STATUS_ASSOCIATING		4
 #define IWM_STATUS_ASSOCIATED		5
 
-#define IWM_RADIO_RFKILL_OFF		0
-#define IWM_RADIO_RFKILL_HW		1
-#define IWM_RADIO_RFKILL_SW		2
-
 struct iwm_tx_queue {
 	int id;
 	struct sk_buff_head queue;
@@ -222,7 +218,6 @@ struct iwm_priv {
 	struct iwm_conf conf;
 
 	unsigned long status;
-	unsigned long radio;
 
 	struct list_head pending_notif;
 	wait_queue_head_t notif_queue;
@@ -241,6 +236,7 @@ struct iwm_priv {
 	u8 bssid[ETH_ALEN];
 	u8 channel;
 	u16 rate;
+	u32 txpower;
 
 	struct iwm_sta_info sta_table[IWM_STA_TABLE_NUM];
 	struct list_head bss_list;
@@ -291,7 +287,6 @@ struct iwm_priv {
 	struct timer_list watchdog;
 	struct work_struct reset_worker;
 	struct mutex mutex;
-	struct rfkill *rfkill;
 
 	char private[0] __attribute__((__aligned__(NETDEV_ALIGN)));
 };
diff --git a/drivers/net/wireless/iwmc3200wifi/netdev.c b/drivers/net/wireless/iwmc3200wifi/netdev.c
index 48e626f..5064a31 100644
--- a/drivers/net/wireless/iwmc3200wifi/netdev.c
+++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
@@ -57,8 +57,7 @@ static int iwm_open(struct net_device *ndev)
 	struct iwm_priv *iwm = ndev_to_iwm(ndev);
 	int ret = -ENODEV;
 
-	if (!test_bit(IWM_RADIO_RFKILL_SW, &iwm->radio)
-	    && test_bit(IWM_STATUS_BUS_READY, &iwm->status))
+	if (test_bit(IWM_STATUS_BUS_READY, &iwm->status))
 		ret = iwm_up(iwm);
 
 	return ret;
@@ -69,8 +68,7 @@ static int iwm_stop(struct net_device *ndev)
 	struct iwm_priv *iwm = ndev_to_iwm(ndev);
 	int ret = -ENODEV;
 
-	if (!test_bit(IWM_RADIO_RFKILL_SW, &iwm->radio)
-	    && test_bit(IWM_STATUS_BUS_READY, &iwm->status))
+	if (test_bit(IWM_STATUS_BUS_READY, &iwm->status))
 		ret = iwm_down(iwm);
 
 	return ret;
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 49a8be7..55871da 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -143,17 +143,18 @@ static int iwm_ntf_init_complete(struct iwm_priv *iwm, u8 *buf,
 				 unsigned long buf_size,
 				 struct iwm_wifi_cmd *cmd)
 {
+	struct wiphy *wiphy = iwm_to_wiphy(iwm);
 	struct iwm_umac_notif_init_complete *init_complete =
 			(struct iwm_umac_notif_init_complete *)(buf);
 	u16 status = le16_to_cpu(init_complete->status);
+	bool blocked = (status == UMAC_NTFY_INIT_COMPLETE_STATUS_ERR);
 
-	if (status == UMAC_NTFY_INIT_COMPLETE_STATUS_ERR) {
+	if (blocked)
 		IWM_DBG_NTF(iwm, DBG, "Hardware rf kill is on (radio off)\n");
-		set_bit(IWM_RADIO_RFKILL_HW, &iwm->radio);
-	} else {
+	else
 		IWM_DBG_NTF(iwm, DBG, "Hardware rf kill is off (radio on)\n");
-		clear_bit(IWM_RADIO_RFKILL_HW, &iwm->radio);
-	}
+
+	wiphy_rfkill_set_hw_state(wiphy, blocked);
 
 	return 0;
 }
@@ -875,6 +876,7 @@ static int iwm_ntf_statistics(struct iwm_priv *iwm, u8 *buf,
 		/* UMAC passes rate info multiplies by 2 */
 		iwm->rate = max_rate >> 1;
 	}
+	iwm->txpower = le32_to_cpu(stats->tx_power);
 
 	wstats->status = 0;
 
@@ -1015,6 +1017,7 @@ static int iwm_ntf_wifi_if_wrapper(struct iwm_priv *iwm, u8 *buf,
 static int iwm_ntf_card_state(struct iwm_priv *iwm, u8 *buf,
 			      unsigned long buf_size, struct iwm_wifi_cmd *cmd)
 {
+	struct wiphy *wiphy = iwm_to_wiphy(iwm);
 	struct iwm_lmac_card_state *state = (struct iwm_lmac_card_state *)
 				(buf + sizeof(struct iwm_umac_wifi_in_hdr));
 	u32 flags = le32_to_cpu(state->flags);
@@ -1023,10 +1026,7 @@ static int iwm_ntf_card_state(struct iwm_priv *iwm, u8 *buf,
 		 flags & IWM_CARD_STATE_HW_DISABLED ? "ON" : "OFF",
 		 flags & IWM_CARD_STATE_CTKILL_DISABLED ? "ON" : "OFF");
 
-	if (flags & IWM_CARD_STATE_HW_DISABLED)
-		set_bit(IWM_RADIO_RFKILL_HW, &iwm->radio);
-	else
-		clear_bit(IWM_RADIO_RFKILL_HW, &iwm->radio);
+	wiphy_rfkill_set_hw_state(wiphy, flags & IWM_CARD_STATE_HW_DISABLED);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwmc3200wifi/sdio.c b/drivers/net/wireless/iwmc3200wifi/sdio.c
index 462bbf6..85aa2b1 100644
--- a/drivers/net/wireless/iwmc3200wifi/sdio.c
+++ b/drivers/net/wireless/iwmc3200wifi/sdio.c
@@ -510,11 +510,7 @@ static struct sdio_driver iwm_sdio_driver = {
 
 static int __init iwm_sdio_init_module(void)
 {
-	int ret;
-
-	ret = sdio_register_driver(&iwm_sdio_driver);
-
-	return ret;
+	return sdio_register_driver(&iwm_sdio_driver);
 }
 
 static void __exit iwm_sdio_exit_module(void)
diff --git a/drivers/net/wireless/iwmc3200wifi/wext.c b/drivers/net/wireless/iwmc3200wifi/wext.c
index 3062f37..9734573 100644
--- a/drivers/net/wireless/iwmc3200wifi/wext.c
+++ b/drivers/net/wireless/iwmc3200wifi/wext.c
@@ -452,8 +452,8 @@ static const iw_handler iwm_handlers[] =
 	(iw_handler) cfg80211_wext_giwrts,		/* SIOCGIWRTS */
 	(iw_handler) cfg80211_wext_siwfrag,	        /* SIOCSIWFRAG */
 	(iw_handler) cfg80211_wext_giwfrag,		/* SIOCGIWFRAG */
-	(iw_handler) NULL,				/* SIOCSIWTXPOW */
-	(iw_handler) NULL,				/* SIOCGIWTXPOW */
+	(iw_handler) cfg80211_wext_siwtxpower,		/* SIOCSIWTXPOW */
+	(iw_handler) cfg80211_wext_giwtxpower,		/* SIOCGIWTXPOW */
 	(iw_handler) NULL,				/* SIOCSIWRETRY */
 	(iw_handler) NULL,				/* SIOCGIWRETRY */
 	(iw_handler) cfg80211_wext_siwencode,		/* SIOCSIWENCODE */
-- 
1.6.3.1

