Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:36084 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbeGSGrI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:47:08 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 23/23] staging: wilc1000: move variable assignment along with its declaration
Date: Thu, 19 Jul 2018 04:15:19 +0530
Message-ID: <1531953919-20804-24-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080545_498997_E8C8A64D)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to club the variable assignment along with the variable
declaration especially for private data.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         |   7 +-
 drivers/staging/wilc1000/linux_wlan.c             | 113 +++--------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 229 +++++++---------------
 drivers/staging/wilc1000/wilc_wlan.c              |  53 ++---
 4 files changed, 118 insertions(+), 284 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index fb063e5..c78b51a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3429,13 +3429,10 @@ static void get_periodic_rssi(struct timer_list *unused)
 int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 {
 	struct host_if_drv *hif_drv;
-	struct wilc_vif *vif;
-	struct wilc *wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wilc = vif->wilc;
 	int i;
 
-	vif = netdev_priv(dev);
-	wilc = vif->wilc;
-
 	hif_drv  = kzalloc(sizeof(*hif_drv), GFP_KERNEL);
 	if (!hif_drv)
 		return -ENOMEM;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 5667a54..2f4bf8e 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -94,12 +94,9 @@ static int dev_state_ev_handler(struct notifier_block *this,
 
 static irqreturn_t isr_uh_routine(int irq, void *user_data)
 {
-	struct wilc_vif *vif;
-	struct wilc *wilc;
 	struct net_device *dev = user_data;
-
-	vif = netdev_priv(dev);
-	wilc = vif->wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wilc = vif->wilc;
 
 	if (wilc->close) {
 		netdev_err(dev, "Can't handle UH interrupt\n");
@@ -110,12 +107,9 @@ static irqreturn_t isr_uh_routine(int irq, void *user_data)
 
 static irqreturn_t isr_bh_routine(int irq, void *userdata)
 {
-	struct wilc_vif *vif;
-	struct wilc *wilc;
 	struct net_device *dev = userdata;
-
-	vif = netdev_priv(userdata);
-	wilc = vif->wilc;
+	struct wilc_vif *vif = netdev_priv(userdata);
+	struct wilc *wilc = vif->wilc;
 
 	if (wilc->close) {
 		netdev_err(dev, "Can't handle BH interrupt\n");
@@ -130,11 +124,8 @@ static irqreturn_t isr_bh_routine(int irq, void *userdata)
 static int init_irq(struct net_device *dev)
 {
 	int ret = 0;
-	struct wilc_vif *vif;
-	struct wilc *wl;
-
-	vif = netdev_priv(dev);
-	wl = vif->wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wl = vif->wilc;
 
 	if ((gpio_request(wl->gpio, "WILC_INTR") == 0) &&
 	    (gpio_direction_input(wl->gpio) == 0)) {
@@ -163,11 +154,8 @@ static int init_irq(struct net_device *dev)
 
 static void deinit_irq(struct net_device *dev)
 {
-	struct wilc_vif *vif;
-	struct wilc *wilc;
-
-	vif = netdev_priv(dev);
-	wilc = vif->wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wilc = vif->wilc;
 
 	/* Deinitialize IRQ */
 	if (wilc->dev_irq_num) {
@@ -238,12 +226,9 @@ static int linux_wlan_txq_task(void *vp)
 {
 	int ret;
 	u32 txq_count;
-	struct wilc_vif *vif;
-	struct wilc *wl;
 	struct net_device *dev = vp;
-
-	vif = netdev_priv(dev);
-	wl = vif->wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wl = vif->wilc;
 
 	complete(&wl->txq_thread_started);
 	while (1) {
@@ -271,15 +256,12 @@ static int linux_wlan_txq_task(void *vp)
 
 static int wilc_wlan_get_firmware(struct net_device *dev)
 {
-	struct wilc_vif *vif;
-	struct wilc *wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wilc = vif->wilc;
 	int chip_id, ret = 0;
 	const struct firmware *wilc_firmware;
 	char *firmware;
 
-	vif = netdev_priv(dev);
-	wilc = vif->wilc;
-
 	chip_id = wilc_get_chipid(wilc, false);
 
 	if (chip_id < 0x1003a0)
@@ -306,13 +288,10 @@ static int wilc_wlan_get_firmware(struct net_device *dev)
 
 static int linux_wlan_start_firmware(struct net_device *dev)
 {
-	struct wilc_vif *vif;
-	struct wilc *wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wilc = vif->wilc;
 	int ret = 0;
 
-	vif = netdev_priv(dev);
-	wilc = vif->wilc;
-
 	ret = wilc_wlan_start(wilc);
 	if (ret < 0)
 		return ret;
@@ -326,13 +305,10 @@ static int linux_wlan_start_firmware(struct net_device *dev)
 
 static int wilc1000_firmware_download(struct net_device *dev)
 {
-	struct wilc_vif *vif;
-	struct wilc *wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wilc = vif->wilc;
 	int ret = 0;
 
-	vif = netdev_priv(dev);
-	wilc = vif->wilc;
-
 	if (!wilc->firmware) {
 		netdev_err(dev, "Firmware buffer is NULL\n");
 		return -ENOBUFS;
@@ -560,11 +536,8 @@ static int linux_wlan_init_test_config(struct net_device *dev,
 
 static int wlan_deinit_locks(struct net_device *dev)
 {
-	struct wilc_vif *vif;
-	struct wilc *wilc;
-
-	vif = netdev_priv(dev);
-	wilc = vif->wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wilc = vif->wilc;
 
 	mutex_destroy(&wilc->hif_cs);
 	mutex_destroy(&wilc->rxq_cs);
@@ -575,11 +548,8 @@ static int wlan_deinit_locks(struct net_device *dev)
 
 static void wlan_deinitialize_threads(struct net_device *dev)
 {
-	struct wilc_vif *vif;
-	struct wilc *wl;
-
-	vif = netdev_priv(dev);
-	wl = vif->wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wl = vif->wilc;
 
 	wl->close = 1;
 
@@ -593,11 +563,8 @@ static void wlan_deinitialize_threads(struct net_device *dev)
 
 static void wilc_wlan_deinitialize(struct net_device *dev)
 {
-	struct wilc_vif *vif;
-	struct wilc *wl;
-
-	vif = netdev_priv(dev);
-	wl = vif->wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wl = vif->wilc;
 
 	if (!wl) {
 		netdev_err(dev, "wl is NULL\n");
@@ -632,11 +599,8 @@ static void wilc_wlan_deinitialize(struct net_device *dev)
 
 static int wlan_init_locks(struct net_device *dev)
 {
-	struct wilc_vif *vif;
-	struct wilc *wl;
-
-	vif = netdev_priv(dev);
-	wl = vif->wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wl = vif->wilc;
 
 	mutex_init(&wl->hif_cs);
 	mutex_init(&wl->rxq_cs);
@@ -655,11 +619,8 @@ static int wlan_init_locks(struct net_device *dev)
 
 static int wlan_initialize_threads(struct net_device *dev)
 {
-	struct wilc_vif *vif;
-	struct wilc *wilc;
-
-	vif = netdev_priv(dev);
-	wilc = vif->wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wilc = vif->wilc;
 
 	wilc->txq_thread = kthread_run(linux_wlan_txq_task, (void *)dev,
 				       "K_TXQ_TASK");
@@ -779,14 +740,11 @@ static int mac_init_fn(struct net_device *ndev)
 
 static int wilc_mac_open(struct net_device *ndev)
 {
-	struct wilc_vif *vif;
+	struct wilc_vif *vif = netdev_priv(ndev);
+	struct wilc *wl = vif->wilc;
 	unsigned char mac_add[ETH_ALEN] = {0};
 	int ret = 0;
 	int i = 0;
-	struct wilc *wl;
-
-	vif = netdev_priv(ndev);
-	wl = vif->wilc;
 
 	if (!wl || !wl->dev) {
 		netdev_err(ndev, "device not ready\n");
@@ -850,11 +808,9 @@ static struct net_device_stats *mac_stats(struct net_device *dev)
 static void wilc_set_multicast_list(struct net_device *dev)
 {
 	struct netdev_hw_addr *ha;
-	struct wilc_vif *vif;
+	struct wilc_vif *vif = netdev_priv(dev);
 	int i = 0;
 
-	vif = netdev_priv(dev);
-
 	if (dev->flags & IFF_PROMISC)
 		return;
 
@@ -894,16 +850,13 @@ static void linux_wlan_tx_complete(void *priv, int status)
 
 netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
-	struct wilc_vif *vif;
+	struct wilc_vif *vif = netdev_priv(ndev);
+	struct wilc *wilc = vif->wilc;
 	struct tx_complete_data *tx_data = NULL;
 	int queue_count;
 	char *udp_buf;
 	struct iphdr *ih;
 	struct ethhdr *eth_h;
-	struct wilc *wilc;
-
-	vif = netdev_priv(ndev);
-	wilc = vif->wilc;
 
 	if (skb->dev != ndev) {
 		netdev_err(ndev, "Packet not destined to this device\n");
@@ -951,12 +904,10 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 static int wilc_mac_close(struct net_device *ndev)
 {
 	struct wilc_priv *priv;
-	struct wilc_vif *vif;
+	struct wilc_vif *vif = netdev_priv(ndev);
 	struct host_if_drv *hif_drv;
 	struct wilc *wl;
 
-	vif = netdev_priv(ndev);
-
 	if (!vif || !vif->ndev || !vif->ndev->ieee80211_ptr ||
 	    !vif->ndev->ieee80211_ptr->wiphy)
 		return 0;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 2d44333..42c0128 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -463,21 +463,15 @@ static void cfg_connect_result(enum conn_event conn_disconn_evt,
 			       struct disconnect_info *disconn_info,
 			       void *priv_data)
 {
-	struct wilc_priv *priv;
-	struct net_device *dev;
-	struct host_if_drv *wfi_drv;
+	struct wilc_priv *priv = priv_data;
+	struct net_device *dev = priv->dev;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wl = vif->wilc;
+	struct host_if_drv *wfi_drv = priv->hif_drv;
 	u8 null_bssid[ETH_ALEN] = {0};
-	struct wilc *wl;
-	struct wilc_vif *vif;
 
 	wilc_connecting = 0;
 
-	priv = priv_data;
-	dev = priv->dev;
-	vif = netdev_priv(dev);
-	wl = vif->wilc;
-	wfi_drv = (struct host_if_drv *)priv->hif_drv;
-
 	if (conn_disconn_evt == CONN_DISCONN_EVENT_CONN_RESP) {
 		u16 connect_status;
 
@@ -550,12 +544,9 @@ static int set_channel(struct wiphy *wiphy,
 		       struct cfg80211_chan_def *chandef)
 {
 	u32 channelnum = 0;
-	struct wilc_priv *priv;
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
 	int result = 0;
-	struct wilc_vif *vif;
-
-	priv = wiphy_priv(wiphy);
-	vif = netdev_priv(priv->dev);
 
 	channelnum = ieee80211_frequency_to_channel(chandef->chan->center_freq);
 
@@ -613,15 +604,12 @@ wilc_wfi_cfg_alloc_fill_ssid(struct cfg80211_scan_request *request,
 
 static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
-	struct wilc_priv *priv;
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
 	u32 i;
 	int ret = 0;
 	u8 scan_ch_list[MAX_NUM_SCANNED_NETWORKS];
 	struct hidden_network hidden_ntwk;
-	struct wilc_vif *vif;
-
-	priv = wiphy_priv(wiphy);
-	vif = netdev_priv(priv->dev);
 
 	priv->scan_req = request;
 
@@ -669,21 +657,18 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 static int connect(struct wiphy *wiphy, struct net_device *dev,
 		   struct cfg80211_connect_params *sme)
 {
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
+	struct host_if_drv *wfi_drv = priv->hif_drv;
+	struct network_info *nw_info;
 	int ret;
 	u32 i;
 	u32 sel_bssi_idx = UINT_MAX;
 	u8 security = NO_ENCRYPT;
 	enum authtype auth_type = ANY;
 	u32 cipher_group;
-	struct wilc_priv *priv;
-	struct host_if_drv *wfi_drv;
-	struct network_info *nw_info;
-	struct wilc_vif *vif;
 
 	wilc_connecting = 1;
-	priv = wiphy_priv(wiphy);
-	vif = netdev_priv(priv->dev);
-	wfi_drv = (struct host_if_drv *)priv->hif_drv;
 
 	if (!(strncmp(sme->ssid, "DIRECT-", 7)))
 		wfi_drv->p2p_connect = 1;
@@ -818,17 +803,14 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 static int disconnect(struct wiphy *wiphy, struct net_device *dev,
 		      u16 reason_code)
 {
-	int ret;
-	struct wilc_priv *priv;
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
+	struct wilc *wilc = vif->wilc;
 	struct host_if_drv *wfi_drv;
-	struct wilc_vif *vif;
-	struct wilc *wilc;
+	int ret;
 	u8 null_bssid[ETH_ALEN] = {0};
 
 	wilc_connecting = 0;
-	priv = wiphy_priv(wiphy);
-	vif = netdev_priv(priv->dev);
-	wilc = vif->wilc;
 
 	if (!wilc)
 		return -EIO;
@@ -915,15 +897,12 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 {
 	int ret = 0, keylen = params->key_len;
-	struct wilc_priv *priv;
+	struct wilc_priv *priv = wiphy_priv(wiphy);
 	const u8 *rx_mic = NULL;
 	const u8 *tx_mic = NULL;
 	u8 mode = NO_ENCRYPT;
 	u8 op_mode;
-	struct wilc_vif *vif;
-
-	priv = wiphy_priv(wiphy);
-	vif = netdev_priv(netdev);
+	struct wilc_vif *vif = netdev_priv(netdev);
 
 	switch (params->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
@@ -1028,13 +1007,9 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		   bool pairwise,
 		   const u8 *mac_addr)
 {
-	struct wilc_priv *priv;
-	struct wilc *wl;
-	struct wilc_vif *vif;
-
-	priv = wiphy_priv(wiphy);
-	vif = netdev_priv(netdev);
-	wl = vif->wilc;
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(netdev);
+	struct wilc *wl = vif->wilc;
 
 	if (netdev == wl->vif[0]->ndev) {
 		if (priv->wilc_gtk[key_index]) {
@@ -1071,11 +1046,9 @@ static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		   bool pairwise, const u8 *mac_addr, void *cookie,
 		   void (*callback)(void *cookie, struct key_params *))
 {
-	struct wilc_priv *priv;
+	struct wilc_priv *priv = wiphy_priv(wiphy);
 	struct  key_params key_params;
 
-	priv = wiphy_priv(wiphy);
-
 	if (!pairwise) {
 		key_params.key = priv->wilc_gtk[key_index]->key;
 		key_params.cipher = priv->wilc_gtk[key_index]->cipher;
@@ -1098,11 +1071,8 @@ static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 static int set_default_key(struct wiphy *wiphy, struct net_device *netdev,
 			   u8 key_index, bool unicast, bool multicast)
 {
-	struct wilc_priv *priv;
-	struct wilc_vif *vif;
-
-	priv = wiphy_priv(wiphy);
-	vif = netdev_priv(priv->dev);
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
 
 	wilc_set_wep_default_keyid(vif, key_index);
 
@@ -1112,15 +1082,12 @@ static int set_default_key(struct wiphy *wiphy, struct net_device *netdev,
 static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *mac, struct station_info *sinfo)
 {
-	struct wilc_priv *priv;
-	struct wilc_vif *vif;
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(dev);
 	u32 i = 0;
 	u32 associatedsta = ~0;
 	u32 inactive_time = 0;
 
-	priv = wiphy_priv(wiphy);
-	vif = netdev_priv(dev);
-
 	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
 		for (i = 0; i < NUM_STA_ASSOCIATED; i++) {
 			if (!(memcmp(mac,
@@ -1176,11 +1143,8 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
 	int ret;
 	struct cfg_param_attr cfg_param_val;
-	struct wilc_priv *priv;
-	struct wilc_vif *vif;
-
-	priv = wiphy_priv(wiphy);
-	vif = netdev_priv(priv->dev);
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
 
 	cfg_param_val.flag = 0;
 
@@ -1212,13 +1176,11 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 		     struct cfg80211_pmksa *pmksa)
 {
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
 	u32 i;
 	int ret = 0;
 	u8 flag = 0;
-	struct wilc_vif *vif;
-	struct wilc_priv *priv = wiphy_priv(wiphy);
-
-	vif = netdev_priv(priv->dev);
 
 	for (i = 0; i < priv->pmkid_list.numpmkid; i++)	{
 		if (!memcmp(pmksa->bssid, priv->pmkid_list.pmkidlist[i].bssid,
@@ -1397,14 +1359,11 @@ static void wilc_wfi_cfg_parse_rx_vendor_spec(struct wilc_priv *priv, u8 *buff,
 
 void wilc_wfi_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 {
-	struct wilc_priv *priv;
+	struct wilc_priv *priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
+	struct host_if_drv *wfi_drv = priv->hif_drv;
 	u32 header, pkt_offset;
-	struct host_if_drv *wfi_drv;
 	s32 freq;
 
-	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
-	wfi_drv = (struct host_if_drv *)priv->hif_drv;
-
 	memcpy(&header, (buff - HOST_HDR_OFFSET), HOST_HDR_OFFSET);
 
 	pkt_offset = GET_PKT_OFFSET(header);
@@ -1506,11 +1465,8 @@ static int remain_on_channel(struct wiphy *wiphy,
 			     unsigned int duration, u64 *cookie)
 {
 	int ret = 0;
-	struct wilc_priv *priv;
-	struct wilc_vif *vif;
-
-	priv = wiphy_priv(wiphy);
-	vif = netdev_priv(priv->dev);
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
 
 	if (wdev->iftype == NL80211_IFTYPE_AP) {
 		netdev_dbg(vif->ndev, "Required while in AP mode\n");
@@ -1535,11 +1491,8 @@ static int cancel_remain_on_channel(struct wiphy *wiphy,
 				    struct wireless_dev *wdev,
 				    u64 cookie)
 {
-	struct wilc_priv *priv;
-	struct wilc_vif *vif;
-
-	priv = wiphy_priv(wiphy);
-	vif = netdev_priv(priv->dev);
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
 
 	return wilc_listen_state_expired(vif,
 			priv->remain_on_ch_params.listen_session_id);
@@ -1605,16 +1558,12 @@ static int mgmt_tx(struct wiphy *wiphy,
 	size_t len = params->len;
 	const struct ieee80211_mgmt *mgmt;
 	struct p2p_mgmt_data *mgmt_tx;
-	struct wilc_priv *priv;
-	struct host_if_drv *wfi_drv;
-	struct wilc_vif *vif;
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct host_if_drv *wfi_drv = priv->hif_drv;
+	struct wilc_vif *vif = netdev_priv(wdev->netdev);
 	u32 buf_len = len + sizeof(p2p_vendor_spec) + sizeof(p2p_local_random);
 	int ret = 0;
 
-	vif = netdev_priv(wdev->netdev);
-	priv = wiphy_priv(wiphy);
-	wfi_drv = (struct host_if_drv *)priv->hif_drv;
-
 	*cookie = (unsigned long)buf;
 	priv->tx_cookie = *cookie;
 	mgmt = (const struct ieee80211_mgmt *)buf;
@@ -1694,11 +1643,9 @@ static int mgmt_tx_cancel_wait(struct wiphy *wiphy,
 			       struct wireless_dev *wdev,
 			       u64 cookie)
 {
-	struct wilc_priv *priv;
-	struct host_if_drv *wfi_drv;
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct host_if_drv *wfi_drv = priv->hif_drv;
 
-	priv = wiphy_priv(wiphy);
-	wfi_drv = (struct host_if_drv *)priv->hif_drv;
 	wfi_drv->p2p_timeout = jiffies;
 
 	if (!priv->p2p_listen_state) {
@@ -1718,13 +1665,9 @@ static int mgmt_tx_cancel_wait(struct wiphy *wiphy,
 void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 			      u16 frame_type, bool reg)
 {
-	struct wilc_priv *priv;
-	struct wilc_vif *vif;
-	struct wilc *wl;
-
-	priv = wiphy_priv(wiphy);
-	vif = netdev_priv(priv->wdev->netdev);
-	wl = vif->wilc;
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->wdev->netdev);
+	struct wilc *wl = vif->wilc;
 
 	if (!frame_type)
 		return;
@@ -1758,15 +1701,12 @@ static int set_cqm_rssi_config(struct wiphy *wiphy, struct net_device *dev,
 static int dump_station(struct wiphy *wiphy, struct net_device *dev,
 			int idx, u8 *mac, struct station_info *sinfo)
 {
-	struct wilc_priv *priv;
-	struct wilc_vif *vif;
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
 
 	if (idx != 0)
 		return -ENOENT;
 
-	priv = wiphy_priv(wiphy);
-	vif = netdev_priv(priv->dev);
-
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL);
 
 	wilc_get_rssi(vif, &sinfo->signal);
@@ -1778,11 +1718,9 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
 static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 			  bool enabled, int timeout)
 {
-	struct wilc_priv *priv;
-	struct wilc_vif *vif;
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
 
-	priv = wiphy_priv(wiphy);
-	vif = netdev_priv(priv->dev);
 	if (!priv->hif_drv)
 		return -EIO;
 
@@ -1796,13 +1734,10 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			       enum nl80211_iftype type,
 			       struct vif_params *params)
 {
-	struct wilc_priv *priv;
-	struct wilc_vif *vif;
-	struct wilc *wl;
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wl = vif->wilc;
 
-	vif = netdev_priv(dev);
-	priv = wiphy_priv(wiphy);
-	wl = vif->wilc;
 	p2p_local_random = 0x01;
 	p2p_recv_random = 0x00;
 	wilc_ie = false;
@@ -1875,13 +1810,10 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 		    struct cfg80211_ap_settings *settings)
 {
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wl = vif->wilc;
 	struct cfg80211_beacon_data *beacon = &settings->beacon;
 	int ret;
-	struct wilc *wl;
-	struct wilc_vif *vif;
-
-	vif = netdev_priv(dev);
-	wl = vif->wilc;
 
 	ret = set_channel(wiphy, &settings->chandef);
 
@@ -1900,11 +1832,8 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
 			 struct cfg80211_beacon_data *beacon)
 {
-	struct wilc_priv *priv;
-	struct wilc_vif *vif;
-
-	priv = wiphy_priv(wiphy);
-	vif = netdev_priv(priv->dev);
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
 
 	return wilc_add_beacon(vif, 0, 0, beacon->head_len,
 				   (u8 *)beacon->head, beacon->tail_len,
@@ -1914,13 +1843,10 @@ static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
 static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
 	int ret;
-	struct wilc_priv *priv;
-	struct wilc_vif *vif;
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
 	u8 null_bssid[ETH_ALEN] = {0};
 
-	priv = wiphy_priv(wiphy);
-	vif = netdev_priv(priv->dev);
-
 	wilc_wlan_set_bssid(dev, null_bssid, AP_MODE);
 
 	ret = wilc_del_beacon(vif);
@@ -1935,12 +1861,9 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *mac, struct station_parameters *params)
 {
 	int ret = 0;
-	struct wilc_priv *priv;
+	struct wilc_priv *priv = wiphy_priv(wiphy);
 	struct add_sta_param sta_params = { {0} };
-	struct wilc_vif *vif;
-
-	priv = wiphy_priv(wiphy);
-	vif = netdev_priv(dev);
+	struct wilc_vif *vif = netdev_priv(dev);
 
 	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
 		memcpy(sta_params.bssid, mac, ETH_ALEN);
@@ -1973,13 +1896,10 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 {
 	const u8 *mac = params->mac;
 	int ret = 0;
-	struct wilc_priv *priv;
-	struct wilc_vif *vif;
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(dev);
 	struct sta_info *info;
 
-	priv = wiphy_priv(wiphy);
-	vif = netdev_priv(dev);
-
 	if (!(vif->iftype == AP_MODE || vif->iftype == GO_MODE))
 		return ret;
 
@@ -1999,9 +1919,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 {
 	int ret = 0;
 	struct add_sta_param sta_params = { {0} };
-	struct wilc_vif *vif;
-
-	vif = netdev_priv(dev);
+	struct wilc_vif *vif = netdev_priv(dev);
 
 	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
 		memcpy(sta_params.bssid, mac, ETH_ALEN);
@@ -2032,13 +1950,10 @@ static struct wireless_dev *add_virtual_intf(struct wiphy *wiphy,
 					     enum nl80211_iftype type,
 					     struct vif_params *params)
 {
-	struct wilc_vif *vif;
-	struct wilc_priv *priv;
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->wdev->netdev);
 	struct net_device *new_ifc;
 
-	priv = wiphy_priv(wiphy);
-	vif = netdev_priv(priv->wdev->netdev);
-
 	if (type == NL80211_IFTYPE_MONITOR) {
 		new_ifc = wilc_wfi_init_mon_interface(name, vif->ndev);
 		if (new_ifc) {
@@ -2109,9 +2024,7 @@ static int get_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 	int ret;
 	struct wilc_priv *priv = wiphy_priv(wiphy);
 	struct wilc_vif *vif = netdev_priv(priv->dev);
-	struct wilc *wl;
-
-	wl = vif->wilc;
+	struct wilc *wl = vif->wilc;
 
 	/* If firmware is not started, return. */
 	if (!wl->initialized)
@@ -2243,9 +2156,8 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net,
 int wilc_init_host_int(struct net_device *net)
 {
 	int ret;
-	struct wilc_priv *priv;
+	struct wilc_priv *priv = wdev_priv(net->ieee80211_ptr);
 
-	priv = wdev_priv(net->ieee80211_ptr);
 	if (op_ifcs == 0) {
 		timer_setup(&aging_timer, remove_network_from_shadow, 0);
 		timer_setup(&wilc_during_ip_timer, clear_during_ip, 0);
@@ -2265,11 +2177,8 @@ int wilc_init_host_int(struct net_device *net)
 int wilc_deinit_host_int(struct net_device *net)
 {
 	int ret;
-	struct wilc_vif *vif;
-	struct wilc_priv *priv;
-
-	priv = wdev_priv(net->ieee80211_ptr);
-	vif = netdev_priv(priv->dev);
+	struct wilc_priv *priv = wdev_priv(net->ieee80211_ptr);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
 
 	priv->p2p_listen_state = false;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index cb8bfd2..ea2e77f 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -31,11 +31,8 @@ wilc_wlan_txq_remove_from_head(struct net_device *dev)
 {
 	struct txq_entry_t *tqe = NULL;
 	unsigned long flags;
-	struct wilc_vif *vif;
-	struct wilc *wilc;
-
-	vif = netdev_priv(dev);
-	wilc = vif->wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wilc = vif->wilc;
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
@@ -53,11 +50,8 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev,
 				      struct txq_entry_t *tqe)
 {
 	unsigned long flags;
-	struct wilc_vif *vif;
-	struct wilc *wilc;
-
-	vif = netdev_priv(dev);
-	wilc = vif->wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wilc = vif->wilc;
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
@@ -156,11 +150,8 @@ static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 	const struct ethhdr *eth_hdr_ptr = buffer;
 	int i;
 	unsigned long flags;
-	struct wilc_vif *vif;
-	struct wilc *wilc;
-
-	vif = netdev_priv(dev);
-	wilc = vif->wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wilc = vif->wilc;
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
@@ -202,15 +193,12 @@ static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 
 static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 {
-	struct wilc_vif *vif;
-	struct wilc *wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wilc = vif->wilc;
 	u32 i = 0;
 	u32 dropped = 0;
 	unsigned long flags;
 
-	vif = netdev_priv(dev);
-	wilc = vif->wilc;
-
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 	for (i = pending_base; i < (pending_base + pending_acks); i++) {
 		u32 session_index;
@@ -511,7 +499,6 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 	int i, entries = 0;
 	u32 sum;
 	u32 reg;
-	u8 *txb;
 	u32 offset = 0;
 	int vmm_sz = 0;
 	struct txq_entry_t *tqe;
@@ -519,14 +506,10 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 	int counter;
 	int timeout;
 	u32 vmm_table[WILC_VMM_TBL_SIZE];
-	struct wilc_vif *vif;
-	struct wilc *wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wilc = vif->wilc;
 	const struct wilc_hif_func *func;
-
-	vif = netdev_priv(dev);
-	wilc = vif->wilc;
-
-	txb = wilc->tx_buffer;
+	u8 *txb = wilc->tx_buffer;
 
 	if (wilc->quit)
 		goto out;
@@ -1081,11 +1064,8 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	struct rxq_entry_t *rqe;
 	u32 reg = 0;
 	int ret;
-	struct wilc_vif *vif;
-	struct wilc *wilc;
-
-	vif = netdev_priv(dev);
-	wilc = vif->wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wilc = vif->wilc;
 
 	wilc->quit = 1;
 	do {
@@ -1281,11 +1261,8 @@ static u32 init_chip(struct net_device *dev)
 {
 	u32 chipid;
 	u32 reg, ret = 0;
-	struct wilc_vif *vif;
-	struct wilc *wilc;
-
-	vif = netdev_priv(dev);
-	wilc = vif->wilc;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct wilc *wilc = vif->wilc;
 
 	acquire_bus(wilc, ACQUIRE_ONLY);
 
-- 
2.7.4
