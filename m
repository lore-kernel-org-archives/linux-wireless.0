Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49637
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbXJQSEQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 14:04:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH #3] b43: Fix sparse warnings.
Date: Wed, 17 Oct 2007 18:34:03 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710171834.03495.mb@bu3sch.de> (sfid-20071017_190420_094209_51B04DE9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The remaining warning in phy.c will be fixed later.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is the third time I submit this.
Is something wrong with this patch or did you simply forget to apply it?

Index: wireless-2.6/drivers/net/wireless/b43/pio.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/pio.c	2007-10-17 18:16:25.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/pio.c	2007-10-17 18:19:45.000000000 +0200
@@ -60,7 +60,7 @@ static u16 tx_get_next_word(const u8 * t
 		source = packet;
 		i -= txhdr_size;
 	}
-	ret = le16_to_cpu(*((u16 *) (source + i)));
+	ret = le16_to_cpu(*((__le16 *)(source + i)));
 	*pos += 2;
 
 	return ret;
@@ -104,7 +104,7 @@ static u16 generate_cookie(struct b43_pi
 			   struct b43_pio_txpacket *packet)
 {
 	u16 cookie = 0x0000;
-	int packetindex;
+	u16 packetindex;
 
 	/* We use the upper 4 bits for the PIO
 	 * controller ID and the lower 12 bits
@@ -125,7 +125,7 @@ static u16 generate_cookie(struct b43_pi
 	default:
 		B43_WARN_ON(1);
 	}
-	packetindex = pio_txpacket_getindex(packet);
+	packetindex = packet->index;
 	B43_WARN_ON(packetindex & ~0x0FFF);
 	cookie |= (u16) packetindex;
 
@@ -286,6 +286,7 @@ static void setup_txqueues(struct b43_pi
 
 		packet->queue = queue;
 		INIT_LIST_HEAD(&packet->list);
+		packet->index = i;
 
 		list_add(&packet->list, &queue->txfree);
 	}
@@ -518,9 +519,10 @@ static void pio_rx_error(struct b43_pioq
 
 void b43_pio_rx(struct b43_pioqueue *queue)
 {
-	u16 preamble[21] = { 0 };
+	__le16 preamble[21] = { 0 };
 	struct b43_rxhdr_fw4 *rxhdr;
-	u16 tmp, len, macstat;
+	u16 tmp, len;
+	u32 macstat;
 	int i, preamble_readwords;
 	struct sk_buff *skb;
 
@@ -537,7 +539,7 @@ void b43_pio_rx(struct b43_pioqueue *que
 	}
 	b43dbg(queue->dev->wl, "PIO RX timed out\n");
 	return;
-      data_ready:
+data_ready:
 
 	len = b43_pio_read(queue, B43_PIO_RXDATA);
 	if (unlikely(len > 0x700)) {
@@ -558,7 +560,7 @@ void b43_pio_rx(struct b43_pioqueue *que
 		preamble[i + 1] = cpu_to_le16(tmp);
 	}
 	rxhdr = (struct b43_rxhdr_fw4 *)preamble;
-	macstat = le16_to_cpu(rxhdr->mac_status);
+	macstat = le32_to_cpu(rxhdr->mac_status);
 	if (macstat & B43_RX_MAC_FCSERR) {
 		pio_rx_error(queue,
 			     (queue->mmio_base == B43_MMIO_PIO1_BASE),
@@ -583,7 +585,7 @@ void b43_pio_rx(struct b43_pioqueue *que
 	skb_put(skb, len);
 	for (i = 0; i < len - 1; i += 2) {
 		tmp = b43_pio_read(queue, B43_PIO_RXDATA);
-		*((u16 *) (skb->data + i)) = cpu_to_le16(tmp);
+		*((__le16 *)(skb->data + i)) = cpu_to_le16(tmp);
 	}
 	if (len % 2) {
 		tmp = b43_pio_read(queue, B43_PIO_RXDATA);
Index: wireless-2.6/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/xmit.c	2007-10-17 18:16:25.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/xmit.c	2007-10-17 18:19:45.000000000 +0200
@@ -121,10 +121,12 @@ void b43_generate_plcp_hdr(struct b43_pl
 	__u8 *raw = plcp->raw;
 
 	if (b43_is_ofdm_rate(bitrate)) {
-		*data = b43_plcp_get_ratecode_ofdm(bitrate);
+		u32 d;
+
+		d = b43_plcp_get_ratecode_ofdm(bitrate);
 		B43_WARN_ON(octets & 0xF000);
-		*data |= (octets << 5);
-		*data = cpu_to_le32(*data);
+		d |= (octets << 5);
+		*data = cpu_to_le32(d);
 	} else {
 		u32 plen;
 
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-10-17 18:16:25.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-10-17 18:19:45.000000000 +0200
@@ -1045,7 +1045,7 @@ static void handle_irq_noise(struct b43_
 	B43_WARN_ON(!dev->noisecalc.calculation_running);
 	if (dev->noisecalc.channel_at_start != phy->channel)
 		goto drop_calculation;
-	*((u32 *) noise) = cpu_to_le32(b43_jssi_read(dev));
+	*((__le32 *)noise) = cpu_to_le32(b43_jssi_read(dev));
 	if (noise[0] == 0x7F || noise[1] == 0x7F ||
 	    noise[2] == 0x7F || noise[3] == 0x7F)
 		goto generate_new;
@@ -1575,8 +1575,7 @@ static int do_request_fw(struct b43_wlde
 			 const char *name,
 			 const struct firmware **fw)
 {
-	const size_t plen = sizeof(modparam_fwpostfix) + 32;
-	char path[plen];
+	char path[sizeof(modparam_fwpostfix) + 32];
 	struct b43_fw_header *hdr;
 	u32 size;
 	int err;
Index: wireless-2.6/drivers/net/wireless/b43/pcmcia.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/pcmcia.c	2007-10-17 18:16:25.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/pcmcia.c	2007-10-17 18:19:45.000000000 +0200
@@ -21,6 +21,8 @@
 
 */
 
+#include "pcmcia.h"
+
 #include <linux/ssb/ssb.h>
 
 #include <pcmcia/cs_types.h>
@@ -30,6 +32,7 @@
 #include <pcmcia/ds.h>
 #include <pcmcia/cisreg.h>
 
+
 static /*const */ struct pcmcia_device_id b43_pcmcia_tbl[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x2D0, 0x448),
 	PCMCIA_DEVICE_NULL,
Index: wireless-2.6/drivers/net/wireless/b43/pio.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/pio.h	2007-10-17 18:16:25.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/pio.h	2007-10-17 18:19:45.000000000 +0200
@@ -39,10 +39,9 @@ struct b43_pio_txpacket {
 	struct sk_buff *skb;
 	struct ieee80211_tx_status txstat;
 	struct list_head list;
+	u16 index; /* Index in the tx_packets_cache */
 };
 
-#define pio_txpacket_getindex(packet) ((int)((packet) - (packet)->queue->tx_packets_cache))
-
 struct b43_pioqueue {
 	struct b43_wldev *dev;
 	u16 mmio_base;
Index: wireless-2.6/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/debugfs.c	2007-10-17 18:16:25.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/debugfs.c	2007-10-17 18:19:45.000000000 +0200
@@ -39,7 +39,7 @@
 
 
 /* The root directory. */
-struct dentry *rootdir;
+static struct dentry *rootdir;
 
 struct b43_debugfs_fops {
 	ssize_t (*read)(struct b43_wldev *dev, char *buf, size_t bufsize);
@@ -76,7 +76,8 @@ struct b43_dfs_file * fops_to_dfs_file(s
 
 
 /* wl->irq_lock is locked */
-ssize_t tsf_read_file(struct b43_wldev *dev, char *buf, size_t bufsize)
+static ssize_t tsf_read_file(struct b43_wldev *dev,
+			     char *buf, size_t bufsize)
 {
 	ssize_t count = 0;
 	u64 tsf;
@@ -90,7 +91,8 @@ ssize_t tsf_read_file(struct b43_wldev *
 }
 
 /* wl->irq_lock is locked */
-int tsf_write_file(struct b43_wldev *dev, const char *buf, size_t count)
+static int tsf_write_file(struct b43_wldev *dev,
+			  const char *buf, size_t count)
 {
 	u64 tsf;
 
@@ -102,7 +104,8 @@ int tsf_write_file(struct b43_wldev *dev
 }
 
 /* wl->irq_lock is locked */
-ssize_t ucode_regs_read_file(struct b43_wldev *dev, char *buf, size_t bufsize)
+static ssize_t ucode_regs_read_file(struct b43_wldev *dev,
+				    char *buf, size_t bufsize)
 {
 	ssize_t count = 0;
 	int i;
@@ -116,7 +119,8 @@ ssize_t ucode_regs_read_file(struct b43_
 }
 
 /* wl->irq_lock is locked */
-ssize_t shm_read_file(struct b43_wldev *dev, char *buf, size_t bufsize)
+static ssize_t shm_read_file(struct b43_wldev *dev,
+			     char *buf, size_t bufsize)
 {
 	ssize_t count = 0;
 	int i;
@@ -135,7 +139,8 @@ ssize_t shm_read_file(struct b43_wldev *
 	return count;
 }
 
-ssize_t txstat_read_file(struct b43_wldev *dev, char *buf, size_t bufsize)
+static ssize_t txstat_read_file(struct b43_wldev *dev,
+				char *buf, size_t bufsize)
 {
 	struct b43_txstatus_log *log = &dev->dfsentry->txstatlog;
 	ssize_t count = 0;
@@ -182,7 +187,8 @@ out_unlock:
 	return count;
 }
 
-ssize_t txpower_g_read_file(struct b43_wldev *dev, char *buf, size_t bufsize)
+static ssize_t txpower_g_read_file(struct b43_wldev *dev,
+				   char *buf, size_t bufsize)
 {
 	ssize_t count = 0;
 
@@ -214,7 +220,8 @@ out:
 	return count;
 }
 
-int txpower_g_write_file(struct b43_wldev *dev, const char *buf, size_t count)
+static int txpower_g_write_file(struct b43_wldev *dev,
+				const char *buf, size_t count)
 {
 	unsigned long phy_flags;
 
@@ -253,7 +260,8 @@ int txpower_g_write_file(struct b43_wlde
 }
 
 /* wl->irq_lock is locked */
-int restart_write_file(struct b43_wldev *dev, const char *buf, size_t count)
+static int restart_write_file(struct b43_wldev *dev,
+			      const char *buf, size_t count)
 {
 	int err = 0;
 
@@ -285,7 +293,8 @@ static ssize_t append_lo_table(ssize_t c
 	return count;
 }
 
-ssize_t loctls_read_file(struct b43_wldev *dev, char *buf, size_t bufsize)
+static ssize_t loctls_read_file(struct b43_wldev *dev,
+				char *buf, size_t bufsize)
 {
 	ssize_t count = 0;
 	struct b43_txpower_lo_control *lo;
@@ -374,6 +383,8 @@ static ssize_t b43_debugfs_read(struct f
 			err = -ENOMEM;
 			goto out_unlock;
 		}
+		/* Sparse warns about the following memset, because it has a big
+		 * size value. That warning is bogus, so I will ignore it. --mb */
 		memset(buf, 0, bufsize);
 		if (dfops->take_irqlock) {
 			spin_lock_irq(&dev->wl->irq_lock);
