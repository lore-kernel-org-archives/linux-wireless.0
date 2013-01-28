Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:55390 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380Ab3A1Qil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 11:38:41 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/14] wil6210: Detect FW error
Date: Mon, 28 Jan 2013 18:30:56 +0200
Message-ID: <1359390669-9310-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130128_173904_538683_9C021A11)
In-Reply-To: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the firmware, added is ability to report internal errors using IRQ.

Catch this IRQ and notify user space via netlink

User space get notified like (udevadm monitor --kernel --property):

KERNEL[12660.320520] change   /devices/pci0000:00/0000:00:1c.1/0000:02:00.0/0000:03:01.0/0000:05:00.0/net/wlan12 (net)
ACTION=change
DEVPATH=/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/0000:03:01.0/0000:05:00.0/net/wlan12
DEVTYPE=wlan
EVENT=FW_ERROR
IFINDEX=6
INTERFACE=wlan12
SEQNUM=2489
SOURCE=wil6210
SUBSYSTEM=net

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c |   22 +++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/wil6210.h   |    8 ++++----
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 38049da..d2109d5 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -38,7 +38,9 @@
 #define WIL6210_IMC_RX		BIT_DMA_EP_RX_ICR_RX_DONE
 #define WIL6210_IMC_TX		(BIT_DMA_EP_TX_ICR_TX_DONE | \
 				BIT_DMA_EP_TX_ICR_TX_DONE_N(0))
-#define WIL6210_IMC_MISC	(ISR_MISC_FW_READY | ISR_MISC_MBOX_EVT)
+#define WIL6210_IMC_MISC	(ISR_MISC_FW_READY | \
+				 ISR_MISC_MBOX_EVT | \
+				 ISR_MISC_FW_ERROR)
 
 #define WIL6210_IRQ_PSEUDO_MASK (u32)(~(BIT_DMA_PSEUDO_CAUSE_RX | \
 					BIT_DMA_PSEUDO_CAUSE_TX | \
@@ -228,6 +230,17 @@ static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
 	return IRQ_HANDLED;
 }
 
+static void wil_notify_fw_error(struct wil6210_priv *wil)
+{
+	struct device *dev = &wil_to_ndev(wil)->dev;
+	char *envp[3] = {
+		[0] = "SOURCE=wil6210",
+		[1] = "EVENT=FW_ERROR",
+		[2] = NULL,
+	};
+	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
+}
+
 static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
@@ -244,6 +257,13 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 
 	wil6210_mask_irq_misc(wil);
 
+	if (isr & ISR_MISC_FW_ERROR) {
+		wil_dbg_IRQ(wil, "IRQ: Firmware error\n");
+		clear_bit(wil_status_fwready, &wil->status);
+		wil_notify_fw_error(wil);
+		isr &= ~ISR_MISC_FW_ERROR;
+	}
+
 	if (isr & ISR_MISC_FW_READY) {
 		wil_dbg_IRQ(wil, "IRQ: FW ready\n");
 		/**
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 9bcfffa..3bd2447 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -101,8 +101,7 @@ struct RGF_ICR {
 #define RGF_DMA_EP_MISC_ICR		(0x881bec) /* struct RGF_ICR */
 	#define BIT_DMA_EP_MISC_ICR_RX_HTRSH	BIT(0)
 	#define BIT_DMA_EP_MISC_ICR_TX_NO_ACT	BIT(1)
-	#define BIT_DMA_EP_MISC_ICR_FW_INT0	BIT(28)
-	#define BIT_DMA_EP_MISC_ICR_FW_INT1	BIT(29)
+	#define BIT_DMA_EP_MISC_ICR_FW_INT(n)	BIT(28+n) /* n = [0..3] */
 
 /* Interrupt moderation control */
 #define RGF_DMA_ITR_CNT_TRSH		(0x881c5c)
@@ -121,8 +120,9 @@ struct RGF_ICR {
 #define SW_INT_MBOX BIT_USER_USER_ICR_SW_INT_2
 
 /* ISR register bits */
-#define ISR_MISC_FW_READY BIT_DMA_EP_MISC_ICR_FW_INT0
-#define ISR_MISC_MBOX_EVT BIT_DMA_EP_MISC_ICR_FW_INT1
+#define ISR_MISC_FW_READY	BIT_DMA_EP_MISC_ICR_FW_INT(0)
+#define ISR_MISC_MBOX_EVT	BIT_DMA_EP_MISC_ICR_FW_INT(1)
+#define ISR_MISC_FW_ERROR	BIT_DMA_EP_MISC_ICR_FW_INT(3)
 
 /* Hardware definitions end */
 
-- 
1.7.10.4

