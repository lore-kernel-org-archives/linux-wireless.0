Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:27819 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbeG2HgZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Jul 2018 03:36:25 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 2/8] staging: wilc1000: remove unnecessary comments and comments description
Date: Sun, 29 Jul 2018 11:36:51 +0530
Message-ID: <1532844417-3192-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180729_080713_421859_4B092BC0)
In-Reply-To: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
References: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the unnecessary comments and commented code.
Also updated description for few of comments.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c     |  4 ++--
 drivers/staging/wilc1000/linux_mon.c          | 15 ++++++++-------
 drivers/staging/wilc1000/wilc_debugfs.c       | 11 -----------
 drivers/staging/wilc1000/wilc_sdio.c          | 10 +---------
 drivers/staging/wilc1000/wilc_spi.c           |  1 -
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  5 -----
 drivers/staging/wilc1000/wilc_wlan.h          |  6 ------
 drivers/staging/wilc1000/wilc_wlan_cfg.c      |  5 -----
 8 files changed, 11 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c78b51a..d960147 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -230,7 +230,7 @@ static int wilc_enqueue_work(struct host_if_msg *msg)
 	return 0;
 }
 
-/* The u8IfIdx starts from 0 to NUM_CONCURRENT_IFC -1, but 0 index used as
+/* The idx starts from 0 to (NUM_CONCURRENT_IFC - 1), but 0 index used as
  * special purpose in wilc device, so we add 1 to the index to starts from 1.
  * As a result, the returned index will be 1 to NUM_CONCURRENT_IFC.
  */
@@ -242,7 +242,7 @@ int wilc_get_vif_idx(struct wilc_vif *vif)
 /* We need to minus 1 from idx which is from wilc device to get real index
  * of wilc->vif[], because we add 1 when pass to wilc device in the function
  * wilc_get_vif_idx.
- * As a result, the index should be between 0 and NUM_CONCURRENT_IFC -1.
+ * As a result, the index should be between 0 and (NUM_CONCURRENT_IFC - 1).
  */
 static struct wilc_vif *wilc_get_vif_from_idx(struct wilc *wilc, int idx)
 {
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 14405bf..fa49588 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -63,7 +63,7 @@ void wilc_wfi_monitor_rx(u8 *buff, u32 size)
 
 		cb_hdr->hdr.it_present = cpu_to_le32(TX_RADIOTAP_PRESENT);
 
-		cb_hdr->rate = 5; /* txrate->bitrate / 5; */
+		cb_hdr->rate = 5;
 
 		if (pkt_offset & IS_MGMT_STATUS_SUCCES)	{
 			/* success */
@@ -84,8 +84,8 @@ void wilc_wfi_monitor_rx(u8 *buff, u32 size)
 		hdr->hdr.it_version = 0; /* PKTHDR_RADIOTAP_VERSION; */
 		hdr->hdr.it_len = cpu_to_le16(sizeof(*hdr));
 		hdr->hdr.it_present = cpu_to_le32
-				(1 << IEEE80211_RADIOTAP_RATE); /* | */
-		hdr->rate = 5; /* txrate->bitrate / 5; */
+				(1 << IEEE80211_RADIOTAP_RATE);
+		hdr->rate = 5;
 	}
 
 	skb->dev = wilc_wfi_mon;
@@ -178,7 +178,7 @@ static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *skb,
 
 		cb_hdr->hdr.it_present = cpu_to_le32(TX_RADIOTAP_PRESENT);
 
-		cb_hdr->rate = 5; /* txrate->bitrate / 5; */
+		cb_hdr->rate = 5;
 		cb_hdr->tx_flags = 0x0004;
 
 		skb2->dev = wilc_wfi_mon;
@@ -194,11 +194,12 @@ static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *skb,
 	}
 	skb->dev = mon_priv->real_ndev;
 
-	/* Identify if Ethernet or MAC header (data or mgmt) */
 	memcpy(srcadd, &skb->data[10], 6);
 	memcpy(bssid, &skb->data[16], 6);
-	/* if source address and bssid fields are equal>>Mac header */
-	/*send it to mgmt frames handler */
+	/*
+	 * Identify if data or mgmt packet, if source address and bssid
+	 * fields are equal send it to mgmt frames handler
+	 */
 	if (!(memcmp(srcadd, bssid, 6))) {
 		ret = mon_mgmt_tx(mon_priv->real_ndev, skb->data, skb->len);
 		if (ret)
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index ecbf3db..ac26e94 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -18,9 +18,6 @@
 
 static struct dentry *wilc_dir;
 
-/*
- * ----------------------------------------------------------------------------
- */
 #define DEBUG           BIT(0)
 #define INFO            BIT(1)
 #define WRN             BIT(2)
@@ -29,10 +26,6 @@ static struct dentry *wilc_dir;
 #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
 static atomic_t WILC_DEBUG_LEVEL = ATOMIC_INIT(ERR);
 
-/*
- * ----------------------------------------------------------------------------
- */
-
 static ssize_t wilc_debug_level_read(struct file *file, char __user *userbuf,
 				     size_t count, loff_t *ppos)
 {
@@ -76,10 +69,6 @@ static ssize_t wilc_debug_level_write(struct file *filp,
 	return count;
 }
 
-/*
- * ----------------------------------------------------------------------------
- */
-
 #define FOPS(_open, _read, _write, _poll) { \
 		.owner	= THIS_MODULE, \
 		.open	= (_open), \
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 8a47147..0628237 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -809,9 +809,6 @@ static int sdio_read_size(struct wilc *wilc, u32 *size)
 	wilc_sdio_cmd52(wilc, &cmd);
 	tmp = cmd.data;
 
-	/* cmd.read_write = 0; */
-	/* cmd.function = 0; */
-	/* cmd.raw = 0; */
 	cmd.address = 0xf3;
 	cmd.data = 0;
 	wilc_sdio_cmd52(wilc, &cmd);
@@ -1096,12 +1093,7 @@ static int sdio_sync_ext(struct wilc *wilc, int nint)
 	return 1;
 }
 
-/********************************************
- *
- *      Global sdio HIF function table
- *
- ********************************************/
-
+/* Global sdio HIF function table */
 static const struct wilc_hif_func wilc_hif_sdio = {
 	.hif_init = sdio_init,
 	.hif_deinit = sdio_deinit,
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index fa9371b..5aa1f7b 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -767,7 +767,6 @@ static int wilc_spi_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 	u8 clockless = 0;
 
 	if (addr < 0x30) {
-		/* dev_err(&spi->dev, "***** read addr %d\n\n", addr); */
 		/* Clockless register */
 		cmd = CMD_INTERNAL_READ;
 		clockless = 1;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 331a971..371a87f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -37,11 +37,6 @@ struct wilc_wfi_stats {
 
 };
 
-/*
- * This structure is private to each device. It is used to pass
- * packets in and out, so there is place for a packet
- */
-
 struct wilc_wfi_key {
 	u8 *key;
 	u8 *seq;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index f29d1ea..696cf1f 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -246,12 +246,6 @@ struct wilc_hif_func {
 	void (*disable_interrupt)(struct wilc *nic);
 };
 
-/********************************************
- *
- *      Configuration Structure
- *
- ********************************************/
-
 #define MAX_CFG_FRAME_SIZE	1468
 
 struct wilc_cfg_frame {
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index c0b9b70..331be7b 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -13,11 +13,6 @@
 #include "wilc_wlan_cfg.h"
 #include "coreconfigurator.h"
 
-/********************************************
- *
- *      Global Data
- *
- ********************************************/
 enum cfg_cmd_type {
 	CFG_BYTE_CMD	= 0,
 	CFG_HWORD_CMD	= 1,
-- 
2.7.4
