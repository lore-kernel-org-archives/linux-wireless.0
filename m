Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47688 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751053AbZFHTFI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 15:05:08 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH, RFC] b43: Add fw capabilities
Date: Mon, 8 Jun 2009 21:04:57 +0200
Cc: bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>
References: <200904080211.16298.mb@bu3sch.de>
In-Reply-To: <200904080211.16298.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200906082105.00868.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

It seems that the following patch [1] implementing automatic capability 
detection for OpenFWWF (basically only disables QoS right now, hwcrypto 
isn't available due to a missing pcm5.fw in the first place) in b43 has 
gone missing. While it's almost too late to squeeze it into 2.6.31, it 
would be great if it could be merged into wireless-testing and 
subsequently 2.6.32.

Successfully tested over several weeks on the following devices against
2.6.29.x and 2.6.31-rc8-git5, using OpenFWWF 5.1 and the proprietary 
Broadcom firmware (410.2160 (2007-05-26 15:32:10)):

b43-phy0: Broadcom 4306 WLAN found (core revision 5)                                 
b43 ssb0:0: firmware: requesting b43/ucode5.fw                                       
b43 ssb0:0: firmware: requesting b43-open/ucode5.fw
b43 ssb0:0: firmware: requesting b43-open/pcm5.fw
b43 ssb0:0: firmware: requesting b43-open/b0g0initvals5.fw
b43 ssb0:0: firmware: requesting b43-open/b0g0bsinitvals5.fw
b43-phy0: Loading OpenSource firmware version 410.31754
b43-phy0: Hardware crypto acceleration not supported by firmware
b43-phy0: QoS not supported by firmware

b43-phy0: Broadcom 4318 WLAN found (core revision 9)
b43 ssb0:0: firmware: requesting b43/ucode5.fw
b43 ssb0:0: firmware: requesting b43-open/ucode5.fw
b43 ssb0:0: firmware: requesting b43-open/pcm5.fw
b43 ssb0:0: firmware: requesting b43-open/b0g0initvals5.fw
b43 ssb0:0: firmware: requesting b43-open/b0g0bsinitvals5.fw
b43-phy0: Loading OpenSource firmware version 410.31754
b43-phy0: Hardware crypto acceleration not supported by firmware
b43-phy0: QoS not supported by firmware

Without this patch or an explicit manual modprobe override setting qos=0, 
the current OpenFWWF will fail to work with b43 with the following 
(repeating) error message:

b43-phy0 ERROR: MAC suspend failed


While this patch has been acked by OpenFWWF upstream [2], [3] and was 
intended to go into wireless-testing [4], it is still lacking a formal 
Signed-off-by from Michael (I'm 're-'sending this patch on his behalf, as 
suggested via IRC).

The attached version of Michael's patch is (trivially) rediffed against 
current wireless-testing and applies with minor fuzz against 2.6.30 as 
well. Even though my own efforts too trivial to claim any kind of copyright
on this patch, I'm proactively adding my Signed-off-by for this rediff, 
hoping that Michael as the author will formally sign it off as well and on 
top.

Regards
	Stefan Lippers-Hollmann

[1]	From: Michael Buesch <mb@bu3sch.de>
	Subject: [PATCH, RFC] b44: Add fw capabilities
	Date: Wed, 8 Apr 2009 02:11:16 +0200
	Message-Id: <200904080211.16298.mb@bu3sch.de>
	https://lists.berlios.de/pipermail/bcm43xx-dev/2009-April/008850.html
[2]	https://lists.berlios.de/pipermail/bcm43xx-dev/2009-April/008864.html
[3]	https://lists.berlios.de/pipermail/bcm43xx-dev/2009-April/008865.html
[4]	https://lists.berlios.de/pipermail/bcm43xx-dev/2009-April/008863.html

--- cut ---
From: Michael Buesch <mb@bu3sch.de>
Subject: [PATCH, RFC] b44: Add fw capabilities

 Completely untested patch to implement firmware capabilities
 and automagic QoS-disabling.

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
---
 drivers/net/wireless/b43/b43.h  |   14 +++++++++
 drivers/net/wireless/b43/dma.c  |    2 +-
 drivers/net/wireless/b43/main.c |   56 +++++++++++++++++++++++++++++++-------
 drivers/net/wireless/b43/main.h |    1 -
 drivers/net/wireless/b43/pio.c  |    2 +-
 5 files changed, 61 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 4e8ad84..61d2ec8 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -163,6 +163,7 @@ enum {
 #define B43_SHM_SH_WLCOREREV		0x0016	/* 802.11 core revision */
 #define B43_SHM_SH_PCTLWDPOS		0x0008
 #define B43_SHM_SH_RXPADOFF		0x0034	/* RX Padding data offset (PIO only) */
+#define B43_SHM_SH_FWCAPA		0x0042	/* Firmware capabilities (Opensource firmware only) */
 #define B43_SHM_SH_PHYVER		0x0050	/* PHY version */
 #define B43_SHM_SH_PHYTYPE		0x0052	/* PHY type */
 #define B43_SHM_SH_ANTSWAP		0x005C	/* Antenna swap threshold */
@@ -297,6 +298,10 @@ enum {
 #define B43_HF_MLADVW		0x001000000000ULL /* N PHY ML ADV workaround (rev >= 13 only) */
 #define B43_HF_PR45960W		0x080000000000ULL /* PR 45960 workaround (rev >= 13 only) */
 
+/* Firmware capabilities field in SHM (Opensource firmware only) */
+#define B43_FWCAPA_HWCRYPTO	0x0001
+#define B43_FWCAPA_QOS		0x0002
+
 /* MacFilter offsets. */
 #define B43_MACFILTER_SELF		0x0000
 #define B43_MACFILTER_BSSID		0x0003
@@ -596,6 +601,13 @@ struct b43_wl {
 	/* Pointer to the ieee80211 hardware data structure */
 	struct ieee80211_hw *hw;
 
+	/* The number of queues that were registered with the mac80211 subsystem
+	 * initially. This is a backup copy of hw->queues in case hw->queues has
+	 * to be dynamically lowered at runtime (Firmware does not support QoS).
+	 * hw->queues has to be restored to the original value before unregistering
+	 * from the mac80211 subsystem. */
+	u16 mac80211_initially_registered_queues;
+
 	struct mutex mutex;
 	spinlock_t irq_lock;
 	/* R/W lock for data transmission.
@@ -752,6 +764,8 @@ struct b43_wldev {
 	bool dfq_valid;		/* Directed frame queue valid (IBSS PS mode, ATIM) */
 	bool radio_hw_enable;	/* saved state of radio hardware enabled state */
 	bool suspend_in_progress;	/* TRUE, if we are in a suspend/resume cycle */
+	bool qos_enabled;		/* TRUE, if QoS is used. */
+	bool hwcrypto_enabled;		/* TRUE, if HW crypto acceleration is enabled. */
 
 	/* PHY/Radio device. */
 	struct b43_phy phy;
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index eae680b..7964cc3 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1285,7 +1285,7 @@ static struct b43_dmaring *select_ring_by_priority(struct b43_wldev *dev,
 {
 	struct b43_dmaring *ring;
 
-	if (b43_modparam_qos) {
+	if (dev->qos_enabled) {
 		/* 0 = highest priority */
 		switch (queue_prio) {
 		default:
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 1d3e400..a7cadc6 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -80,8 +80,8 @@ static int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
-int b43_modparam_qos = 1;
-module_param_named(qos, b43_modparam_qos, int, 0444);
+static int modparam_qos = 1;
+module_param_named(qos, modparam_qos, int, 0444);
 MODULE_PARM_DESC(qos, "Enable QOS support (default on)");
 
 static int modparam_btcoex = 1;
@@ -538,6 +538,13 @@ void b43_hf_write(struct b43_wldev *dev, u64 value)
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTFHI, hi);
 }
 
+/* Read the firmware capabilities bitmask (Opensource firmware only) */
+static u16 b43_fwcapa_read(struct b43_wldev *dev)
+{
+	B43_WARN_ON(!dev->fw.opensource);
+	return b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_FWCAPA);
+}
+
 void b43_tsf_read(struct b43_wldev *dev, u64 *tsf)
 {
 	u32 low, high;
@@ -2307,12 +2314,34 @@ static int b43_upload_microcode(struct b43_wldev *dev)
 	dev->fw.patch = fwpatch;
 	dev->fw.opensource = (fwdate == 0xFFFF);
 
+	/* Default to use-all-queues. */
+	dev->wl->hw->queues = dev->wl->mac80211_initially_registered_queues;
+	dev->qos_enabled = !!modparam_qos;
+	/* Default to firmware/hardware crypto acceleration. */
+	dev->hwcrypto_enabled = 1;
+
 	if (dev->fw.opensource) {
+		u16 fwcapa;
+
 		/* Patchlevel info is encoded in the "time" field. */
 		dev->fw.patch = fwtime;
-		b43info(dev->wl, "Loading OpenSource firmware version %u.%u%s\n",
-			dev->fw.rev, dev->fw.patch,
-			dev->fw.pcm_request_failed ? " (Hardware crypto not supported)" : "");
+		b43info(dev->wl, "Loading OpenSource firmware version %u.%u\n",
+			dev->fw.rev, dev->fw.patch);
+
+		fwcapa = b43_fwcapa_read(dev);
+		if (!(fwcapa & B43_FWCAPA_HWCRYPTO) || dev->fw.pcm_request_failed) {
+			b43info(dev->wl, "Hardware crypto acceleration not supported by firmware\n");
+			/* Disable hardware crypto and fall back to software crypto. */
+			dev->hwcrypto_enabled = 0;
+		}
+		if (!(fwcapa & B43_FWCAPA_QOS)) {
+			b43info(dev->wl, "QoS not supported by firmware\n");
+			/* Disable QoS. Tweak hw->queues to 1. It will be restored before
+			 * ieee80211_unregister to make sure the networking core can
+			 * properly free possible resources. */
+			dev->wl->hw->queues = 1;
+			dev->qos_enabled = 0;
+		}
 	} else {
 		b43info(dev->wl, "Loading firmware version %u.%u "
 			"(20%.2i-%.2i-%.2i %.2i:%.2i:%.2i)\n",
@@ -3627,7 +3656,7 @@ static int b43_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if (!dev || b43_status(dev) < B43_STAT_INITIALIZED)
 		goto out_unlock;
 
-	if (dev->fw.pcm_request_failed) {
+	if (dev->fw.pcm_request_failed || !dev->hwcrypto_enabled) {
 		/* We don't have firmware for the crypto engine.
 		 * Must use software-crypto. */
 		err = -EOPNOTSUPP;
@@ -4735,6 +4764,7 @@ static int b43_wireless_init(struct ssb_device *dev)
 		b43err(NULL, "Could not allocate ieee80211 device\n");
 		goto out;
 	}
+	wl = hw_to_b43_wl(hw);
 
 	/* fill hw info */
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
@@ -4748,7 +4778,8 @@ static int b43_wireless_init(struct ssb_device *dev)
 		BIT(NL80211_IFTYPE_WDS) |
 		BIT(NL80211_IFTYPE_ADHOC);
 
-	hw->queues = b43_modparam_qos ? 4 : 1;
+	hw->queues = modparam_qos ? 4 : 1;
+	wl->mac80211_initially_registered_queues = hw->queues;
 	hw->max_rates = 2;
 	SET_IEEE80211_DEV(hw, dev->dev);
 	if (is_valid_ether_addr(sprom->et1mac))
@@ -4756,9 +4787,7 @@ static int b43_wireless_init(struct ssb_device *dev)
 	else
 		SET_IEEE80211_PERM_ADDR(hw, sprom->il0mac);
 
-	/* Get and initialize struct b43_wl */
-	wl = hw_to_b43_wl(hw);
-	memset(wl, 0, sizeof(*wl));
+	/* Initialize struct b43_wl */
 	wl->hw = hw;
 	spin_lock_init(&wl->irq_lock);
 	rwlock_init(&wl->tx_lock);
@@ -4824,8 +4853,13 @@ static void b43_remove(struct ssb_device *dev)
 	cancel_work_sync(&wldev->restart_work);
 
 	B43_WARN_ON(!wl);
-	if (wl->current_dev == wldev)
+	if (wl->current_dev == wldev) {
+		/* Restore the queues count before unregistering, because firmware detect
+		 * might have modified it. Restoring is important, so the networking
+		 * stack can properly free resources. */
+		wl->hw->queues = wl->mac80211_initially_registered_queues;
 		ieee80211_unregister_hw(wl->hw);
+	}
 
 	b43_one_core_detach(dev);
 
diff --git a/drivers/net/wireless/b43/main.h b/drivers/net/wireless/b43/main.h
index 40abcf5..950fb1b 100644
--- a/drivers/net/wireless/b43/main.h
+++ b/drivers/net/wireless/b43/main.h
@@ -39,7 +39,6 @@
 #define PAD_BYTES(nr_bytes)		P4D_BYTES( __LINE__ , (nr_bytes))
 
 
-extern int b43_modparam_qos;
 extern int b43_modparam_verbose;
 
 /* Logmessage verbosity levels. Update the b43_modparam_verbose helptext, if
diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index 8cd9776..69138e8 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -313,7 +313,7 @@ static struct b43_pio_txqueue *select_queue_by_priority(struct b43_wldev *dev,
 {
 	struct b43_pio_txqueue *q;
 
-	if (b43_modparam_qos) {
+	if (dev->qos_enabled) {
 		/* 0 = highest priority */
 		switch (queue_prio) {
 		default:
-- 
1.6.3.1

