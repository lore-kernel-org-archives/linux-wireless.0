Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35195 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbbIOFG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:06:59 -0400
Received: by pacfv12 with SMTP id fv12so168222934pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 22:06:59 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 03/18] staging: wilc1000: rename WILC_WFI_priv
Date: Tue, 15 Sep 2015 14:06:13 +0900
Message-Id: <1442293588-15323-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20150915_070802_854645_E8ED754C)
In-Reply-To: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_priv with wilc_priv to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_mon.c              |  2 +-
 drivers/staging/wilc1000/linux_wlan.c             | 12 +--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 90 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 +-
 4 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index d873877..6bee710 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -63,7 +63,7 @@ void WILC_WFI_monitor_rx(uint8_t *buff, uint32_t size)
 
 	PRINT_INFO(HOSTAPD_DBG, "In monitor interface receive function\n");
 
-	/*   struct WILC_WFI_priv *priv = netdev_priv(dev); */
+	/*   struct wilc_priv *priv = netdev_priv(dev); */
 
 	/*   priv = wiphy_priv(priv->dev->ieee80211_ptr->wiphy); */
 
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2f609f0..e95db24 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -200,7 +200,7 @@ static int DebuggingThreadTask(void *vp)
 static int dev_state_ev_handler(struct notifier_block *this, unsigned long event, void *ptr)
 {
 	struct in_ifaddr *dev_iface = (struct in_ifaddr *)ptr;
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	struct net_device *dev;
 	u8 *pIP_Add_buff;
@@ -831,7 +831,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	unsigned char mac_add[] = {0x00, 0x80, 0xC2, 0x5E, 0xa2, 0xff};
 
 	/*BugID_5077*/
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 
 	PRINT_D(TX_DBG, "Start configuring Firmware\n");
@@ -1629,7 +1629,7 @@ int mac_open(struct net_device *ndev)
 	unsigned char mac_add[ETH_ALEN] = {0};
 	int ret = 0;
 	int i = 0;
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 
 	nic = netdev_priv(ndev);
 	priv = wiphy_priv(nic->wilc_netdev->ieee80211_ptr->wiphy);
@@ -1701,7 +1701,7 @@ static void wilc_set_multicast_list(struct net_device *dev)
 {
 
 	struct netdev_hw_addr *ha;
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	int i = 0;
 
@@ -1834,7 +1834,7 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 int mac_close(struct net_device *ndev)
 {
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 
@@ -1902,7 +1902,7 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 	s8 rssi;
 	u32 size = 0, length = 0;
 	perInterface_wlan_t *nic;
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	s32 s32Error = WILC_SUCCESS;
 
 	/* struct iwreq *wrq = (struct iwreq *) req;	// tony moved to case SIOCSIWPRIV */
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 5941696..237be2b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -177,13 +177,13 @@ uint32_t get_rssi_avg(tstrNetworkInfo *pstrNetworkInfo)
 
 void refresh_scan(void *pUserVoid, uint8_t all, bool bDirectScan)
 {
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	struct wiphy *wiphy;
 	struct cfg80211_bss *bss = NULL;
 	int i;
 	int rssi = 0;
 
-	priv = (struct WILC_WFI_priv *)pUserVoid;
+	priv = (struct wilc_priv *)pUserVoid;
 	wiphy = priv->dev->ieee80211_ptr->wiphy;
 
 	for (i = 0; i < u32LastScannedNtwrksCountShadow; i++) {
@@ -371,14 +371,14 @@ void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, vo
  */
 static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, void *pJoinParams)
 {
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	struct wiphy *wiphy;
 	s32 s32Freq;
 	struct ieee80211_channel *channel;
 	s32 s32Error = WILC_SUCCESS;
 	struct cfg80211_bss *bss = NULL;
 
-	priv = (struct WILC_WFI_priv *)pUserVoid;
+	priv = (struct wilc_priv *)pUserVoid;
 	if (priv->bCfgScanning == true) {
 		if (enuScanEvent == SCAN_EVENT_NETWORK_FOUND) {
 			wiphy = priv->dev->ieee80211_ptr->wiphy;
@@ -499,7 +499,7 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-int WILC_WFI_Set_PMKSA(u8 *bssid, struct WILC_WFI_priv *priv)
+int WILC_WFI_Set_PMKSA(u8 *bssid, struct wilc_priv *priv)
 {
 	u32 i;
 	s32 s32Error = WILC_SUCCESS;
@@ -550,7 +550,7 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 			     tstrDisconnectNotifInfo *pstrDisconnectNotifInfo,
 			     void *pUserVoid)
 {
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	struct net_device *dev;
 	#ifdef WILC_P2P
 	tstrWILC_WFIDrv *pstrWFIDrv;
@@ -559,7 +559,7 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 
 	connecting = 0;
 
-	priv = (struct WILC_WFI_priv *)pUserVoid;
+	priv = (struct wilc_priv *)pUserVoid;
 	dev = priv->dev;
 	#ifdef WILC_P2P
 	pstrWFIDrv = (tstrWILC_WFIDrv *)priv->hWILCWFIDrv;
@@ -694,7 +694,7 @@ static int set_channel(struct wiphy *wiphy,
 {
 
 	u32 channelnum = 0;
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	s32 s32Error = WILC_SUCCESS;
 
 	priv = wiphy_priv(wiphy);
@@ -730,7 +730,7 @@ static int set_channel(struct wiphy *wiphy,
  */
 static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	u32 i;
 	s32 s32Error = WILC_SUCCESS;
 	u8 au8ScanChanList[MAX_NUM_SCANNED_NETWORKS];
@@ -828,7 +828,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	char *pccipher_group = NULL;
 	char *pcwpa_version = NULL;
 
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	tstrNetworkInfo *pstrNetworkInfo = NULL;
 
@@ -1075,7 +1075,7 @@ done:
 static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_code)
 {
 	s32 s32Error = WILC_SUCCESS;
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	#ifdef WILC_P2P
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	#endif
@@ -1128,7 +1128,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 {
 	s32 s32Error = WILC_SUCCESS, KeyLen = params->key_len;
 	u32 i;
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	const u8 *pu8RxMic = NULL;
 	const u8 *pu8TxMic = NULL;
 	u8 u8mode = NO_ENCRYPT;
@@ -1417,7 +1417,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		   bool pairwise,
 		   const u8 *mac_addr)
 {
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	s32 s32Error = WILC_SUCCESS;
 
 	priv = wiphy_priv(wiphy);
@@ -1530,7 +1530,7 @@ static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 	s32 s32Error = WILC_SUCCESS;
 
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	struct  key_params key_params;
 	u32 i;
 
@@ -1578,7 +1578,7 @@ static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 ke
 			   bool unicast, bool multicast)
 {
 	s32 s32Error = WILC_SUCCESS;
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 
 
 	priv = wiphy_priv(wiphy);
@@ -1632,7 +1632,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *mac, struct station_info *sinfo)
 {
 	s32 s32Error = WILC_SUCCESS;
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
 	#ifdef WILC_AP_EXTERNAL_MLME
 	u32 i = 0;
@@ -1815,7 +1815,7 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrCfgParamVal pstrCfgParamVal;
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 
 	priv = wiphy_priv(wiphy);
 
@@ -1897,7 +1897,7 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 	s32 s32Error = WILC_SUCCESS;
 	u8 flag = 0;
 
-	struct WILC_WFI_priv *priv = wiphy_priv(wiphy);
+	struct wilc_priv *priv = wiphy_priv(wiphy);
 
 	PRINT_D(CFG80211_DBG, "Setting PMKSA\n");
 
@@ -1948,7 +1948,7 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 	u8 flag = 0;
 	s32 s32Error = WILC_SUCCESS;
 
-	struct WILC_WFI_priv *priv = wiphy_priv(wiphy);
+	struct wilc_priv *priv = wiphy_priv(wiphy);
 
 	PRINT_D(CFG80211_DBG, "Deleting PMKSA keys\n");
 
@@ -1991,7 +1991,7 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
  */
 static int flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 {
-	struct WILC_WFI_priv *priv = wiphy_priv(wiphy);
+	struct wilc_priv *priv = wiphy_priv(wiphy);
 
 	PRINT_D(CFG80211_DBG,  "Flushing  PMKID key values\n");
 
@@ -2201,7 +2201,7 @@ void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftype)
 void WILC_WFI_p2p_rx (struct net_device *dev, uint8_t *buff, uint32_t size)
 {
 
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	u32 header, pkt_offset;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	u32 i = 0;
@@ -2341,9 +2341,9 @@ static void WILC_WFI_mgmt_tx_complete(void *priv, int status)
 
 static void WILC_WFI_RemainOnChannelReady(void *pUserVoid)
 {
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 
-	priv = (struct WILC_WFI_priv *)pUserVoid;
+	priv = (struct wilc_priv *)pUserVoid;
 
 	PRINT_D(HOSTINF_DBG, "Remain on channel ready\n");
 
@@ -2368,9 +2368,9 @@ static void WILC_WFI_RemainOnChannelReady(void *pUserVoid)
 
 static void WILC_WFI_RemainOnChannelExpired(void *pUserVoid, u32 u32SessionID)
 {
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 
-	priv = (struct WILC_WFI_priv *)pUserVoid;
+	priv = (struct wilc_priv *)pUserVoid;
 
 	/*BugID_5477*/
 	if (u32SessionID == priv->strRemainOnChanParams.u32ListenSessionID) {
@@ -2409,7 +2409,7 @@ static int remain_on_channel(struct wiphy *wiphy,
 			     unsigned int duration, u64 *cookie)
 {
 	s32 s32Error = WILC_SUCCESS;
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 
 	priv = wiphy_priv(wiphy);
 
@@ -2461,7 +2461,7 @@ static int cancel_remain_on_channel(struct wiphy *wiphy,
 				    u64 cookie)
 {
 	s32 s32Error = WILC_SUCCESS;
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 
 	priv = wiphy_priv(wiphy);
 
@@ -2507,7 +2507,7 @@ int mgmt_tx(struct wiphy *wiphy,
 	size_t len = params->len;
 	const struct ieee80211_mgmt *mgmt;
 	struct p2p_mgmt_data *mgmt_tx;
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	u32 i;
@@ -2656,7 +2656,7 @@ int mgmt_tx_cancel_wait(struct wiphy *wiphy,
 			struct wireless_dev *wdev,
 			u64 cookie)
 {
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 
 	priv = wiphy_priv(wiphy);
@@ -2694,7 +2694,7 @@ void    WILC_WFI_frame_register(struct wiphy *wiphy,
 				u16 frame_type, bool reg)
 {
 
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
 
 
@@ -2775,7 +2775,7 @@ static int    WILC_WFI_set_cqm_rssi_config(struct wiphy *wiphy,
 static int dump_station(struct wiphy *wiphy, struct net_device *dev,
 			int idx, u8 *mac, struct station_info *sinfo)
 {
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 
 	PRINT_D(CFG80211_DBG, "Dumping station information\n");
 
@@ -2805,7 +2805,7 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
 int WILC_WFI_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 			    bool enabled, int timeout)
 {
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 
 	PRINT_D(CFG80211_DBG, " Power save Enabled= %d , TimeOut = %d\n", enabled, timeout);
 
@@ -2843,7 +2843,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			       enum nl80211_iftype type, u32 *flags, struct vif_params *params)
 {
 	s32 s32Error = WILC_SUCCESS;
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
 	u8 interface_type;
 	u16 TID = 0;
@@ -3221,7 +3221,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 		    struct cfg80211_ap_settings *settings)
 {
 	struct cfg80211_beacon_data *beacon = &(settings->beacon);
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	s32 s32Error = WILC_SUCCESS;
 
 	priv = wiphy_priv(wiphy);
@@ -3261,7 +3261,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
 			 struct cfg80211_beacon_data *beacon)
 {
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	s32 s32Error = WILC_SUCCESS;
 
 	priv = wiphy_priv(wiphy);
@@ -3289,7 +3289,7 @@ static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
 static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
 	s32 s32Error = WILC_SUCCESS;
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	u8 NullBssid[ETH_ALEN] = {0};
 
 
@@ -3325,7 +3325,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *mac, struct station_parameters *params)
 {
 	s32 s32Error = WILC_SUCCESS;
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	tstrWILC_AddStaParam strStaParams = { {0} };
 	perInterface_wlan_t *nic;
 
@@ -3397,7 +3397,7 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 {
 	const u8 *mac = params->mac;
 	s32 s32Error = WILC_SUCCESS;
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
 
 	WILC_NULLCHECK(s32Error, wiphy);
@@ -3439,7 +3439,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			  const u8 *mac, struct station_parameters *params)
 {
 	s32 s32Error = WILC_SUCCESS;
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	tstrWILC_AddStaParam strStaParams = { {0} };
 	perInterface_wlan_t *nic;
 
@@ -3512,7 +3512,7 @@ struct wireless_dev *add_virtual_intf(struct wiphy *wiphy, const char *name,
 				      struct vif_params *params)
 {
 	perInterface_wlan_t *nic;
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	struct net_device *new_ifc = NULL;
 
 	priv = wiphy_priv(wiphy);
@@ -3614,7 +3614,7 @@ static struct cfg80211_ops wilc_cfg80211_ops = {
 int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed)
 {
 
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 
 	priv = wiphy_priv(wiphy);
 #if 1
@@ -3669,7 +3669,7 @@ struct wireless_dev *WILC_WFI_CfgAlloc(void)
 	}
 
 	/*Creating a new wiphy, linking wireless structure with the wiphy structure*/
-	wdev->wiphy = wiphy_new(&wilc_cfg80211_ops, sizeof(struct WILC_WFI_priv));
+	wdev->wiphy = wiphy_new(&wilc_cfg80211_ops, sizeof(struct wilc_priv));
 	if (!wdev->wiphy) {
 		PRINT_ER("Cannot allocate wiphy\n");
 		goto _fail_mem_;
@@ -3707,7 +3707,7 @@ _fail_:
  */
 struct wireless_dev *WILC_WFI_WiphyRegister(struct net_device *net)
 {
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 	struct wireless_dev *wdev;
 	s32 s32Error = WILC_SUCCESS;
 
@@ -3793,7 +3793,7 @@ int WILC_WFI_InitHostInt(struct net_device *net)
 
 	s32 s32Error = WILC_SUCCESS;
 
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 
 	PRINT_D(INIT_DBG, "Host[%p][%p]\n", net, net->ieee80211_ptr);
 	priv = wdev_priv(net->ieee80211_ptr);
@@ -3834,7 +3834,7 @@ int WILC_WFI_DeInitHostInt(struct net_device *net)
 {
 	s32 s32Error = WILC_SUCCESS;
 
-	struct WILC_WFI_priv *priv;
+	struct wilc_priv *priv;
 
 	priv = wdev_priv(net->ieee80211_ptr);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index e1caea9..30ca3e0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -116,7 +116,7 @@ struct wilc_wfi_p2pListenParams {
 
 #endif  /*WILC_P2P*/
 
-struct WILC_WFI_priv {
+struct wilc_priv {
 	struct wireless_dev *wdev;
 	struct cfg80211_scan_request *pstrScanReq;
 
-- 
2.5.1

