Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22306 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab1L0W2C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 17:28:02 -0500
From: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v3] ath6kl: Support for TCP checksum offload to firmware
Date: Tue, 27 Dec 2011 14:28:00 -0800
Message-ID: <1325024880-22364-1-git-send-email-rpanjwan@qca.qualcomm.com> (sfid-20111227_232818_474669_FEF53BE7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The change enables offloading TCP checksum calculation to firmware.
There are still some issues with the checksum offload so better to
disable it by default until the issues are resolved.

To enable TCP checksum offload for tx and rx paths, use
the ethtool as follows:
ethtool -K <interface> tx on
ethtool -K <interface> rx on

To disable TCP checksum offload, for tx and rx paths, use
the ethtool as follows:
ethtool -K <interface> tx off
ethtool -K <interface> rx off

Signed-off-by: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    2 +
 drivers/net/wireless/ath/ath6kl/main.c |   33 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/txrx.c |   38 ++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath6kl/wmi.h  |    3 ++
 4 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index c97f83c..fa4ae8a 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1649,6 +1649,8 @@ int ath6kl_core_init(struct ath6kl *ar)
 
 	set_bit(FIRST_BOOT, &ar->flag);
 
+	ndev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+
 	ret = ath6kl_init_hw_start(ar);
 	if (ret) {
 		ath6kl_err("Failed to start hardware: %d\n", ret);
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index d9b4ba4..b7fd9db 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1028,11 +1028,44 @@ static struct net_device_stats *ath6kl_get_stats(struct net_device *dev)
 	return &vif->net_stats;
 }
 
+static int ath6kl_set_features(struct net_device *dev, u32 features)
+{
+	struct ath6kl_vif *vif = netdev_priv(dev);
+	struct ath6kl *ar = vif->ar;
+	int err = 0;
+
+	if ((features & NETIF_F_RXCSUM) &&
+		(ar->rx_meta_ver != WMI_META_VERSION_2)) {
+			ar->rx_meta_ver = WMI_META_VERSION_2;
+			err = ath6kl_wmi_set_rx_frame_format_cmd(ar->wmi,
+					vif->fw_vif_idx,
+					ar->rx_meta_ver, 0, 0);
+			if (err) {
+				dev->features = features & ~NETIF_F_RXCSUM;
+				return err;
+			}
+
+	} else if (!(features & NETIF_F_RXCSUM) &&
+		(ar->rx_meta_ver == WMI_META_VERSION_2)) {
+			ar->rx_meta_ver = 0;
+			err = ath6kl_wmi_set_rx_frame_format_cmd(ar->wmi,
+					vif->fw_vif_idx,
+					ar->rx_meta_ver, 0, 0);
+			if (err) {
+				dev->features = features | NETIF_F_RXCSUM;
+				return err;
+			}
+
+	}
+	return err;
+}
+
 static struct net_device_ops ath6kl_netdev_ops = {
 	.ndo_open               = ath6kl_open,
 	.ndo_stop               = ath6kl_close,
 	.ndo_start_xmit         = ath6kl_data_tx,
 	.ndo_get_stats          = ath6kl_get_stats,
+	.ndo_set_features       = ath6kl_set_features,
 };
 
 void init_netdev(struct net_device *dev)
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 506a303..78bd573 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -244,6 +244,10 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 	u8 ac = 99 ; /* initialize to unmapped ac */
 	bool chk_adhoc_ps_mapping = false, more_data = false;
 	int ret;
+	struct wmi_tx_meta_v2 meta_v2;
+	void *meta;
+	u8 csum_start = 0, csum_dest = 0, csum = skb->ip_summed;
+	u8 meta_ver = 0;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_TX,
 		   "%s: skb=0x%p, data=0x%p, len=0x%x\n", __func__,
@@ -265,6 +269,14 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	if (test_bit(WMI_ENABLED, &ar->flag)) {
+		if ((dev->features & NETIF_F_IP_CSUM) &&
+				(csum == CHECKSUM_PARTIAL)) {
+			csum_start = skb->csum_start -
+					(skb_network_header(skb) - skb->head) +
+					sizeof(struct ath6kl_llc_snap_hdr);
+			csum_dest = skb->csum_offset + csum_start;
+		}
+
 		if (skb_headroom(skb) < dev->needed_headroom) {
 			struct sk_buff *tmp_skb = skb;
 
@@ -281,10 +293,28 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 			goto fail_tx;
 		}
 
-		if (ath6kl_wmi_data_hdr_add(ar->wmi, skb, DATA_MSGTYPE,
-					    more_data, 0, 0, NULL,
-					    vif->fw_vif_idx)) {
-			ath6kl_err("wmi_data_hdr_add failed\n");
+		if ((dev->features & NETIF_F_IP_CSUM) &&
+				(csum == CHECKSUM_PARTIAL)) {
+			meta_v2.csum_start = csum_start;
+			meta_v2.csum_dest = csum_dest;
+
+			/* instruct target to calculate checksum */
+			meta_v2.csum_flags = WMI_META_V2_FLAG_CSUM_OFFLOAD;
+			meta_ver = WMI_META_VERSION_2;
+			meta = &meta_v2;
+		} else {
+			meta_ver = 0;
+			meta = NULL;
+		}
+
+		ret = ath6kl_wmi_data_hdr_add(ar->wmi, skb,
+				DATA_MSGTYPE, more_data, 0,
+				meta_ver,
+				meta, vif->fw_vif_idx);
+
+		if (ret) {
+			ath6kl_warn("failed to add wmi data header:%d\n"
+				, ret);
 			goto fail_tx;
 		}
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 4e4f0f7..0180515 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -257,6 +257,9 @@ static inline u8 wmi_data_hdr_get_if_idx(struct wmi_data_hdr *dhdr)
 #define WMI_META_VERSION_1	0x01
 #define WMI_META_VERSION_2	0x02
 
+/* Flag to signal to FW to calculate TCP checksum */
+#define WMI_META_V2_FLAG_CSUM_OFFLOAD 0x01
+
 struct wmi_tx_meta_v1 {
 	/* packet ID to identify the tx request */
 	u8 pkt_id;
-- 
1.7.0.4

