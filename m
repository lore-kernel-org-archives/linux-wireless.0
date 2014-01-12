Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:45960 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaALIlT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jan 2014 03:41:19 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH v2 1/3] wil6210: interrupt moderation
Date: Sun, 12 Jan 2014 10:41:02 +0200
Message-ID: <1389516065-19515-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140112_094130_587465_1E907C46)
In-Reply-To: <1389516065-19515-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1389516065-19515-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use hardware capabilities to limit IRQ generation to about 15 per msec
It corresponds to about 7 packets/IRQ when running iperf with default
parameters at 1.3Gbps

Do not enable this feature in the sniffer (monitor)  mode, because
interrupt moderation cause timestamp accuracy deterioration.
For the sniffer flow, it is important to get precise timestamp.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 13 +++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h   |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 8205d3e..10919f9 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -156,6 +156,19 @@ void wil6210_enable_irq(struct wil6210_priv *wil)
 	iowrite32(WIL_ICR_ICC_VALUE, wil->csr + HOSTADDR(RGF_DMA_EP_MISC_ICR) +
 		  offsetof(struct RGF_ICR, ICC));
 
+	/* interrupt moderation parameters */
+	if (wil->wdev->iftype == NL80211_IFTYPE_MONITOR) {
+		/* disable interrupt moderation for monitor
+		 * to get better timestamp precision
+		 */
+		iowrite32(0, wil->csr + HOSTADDR(RGF_DMA_ITR_CNT_CRL));
+	} else {
+		iowrite32(WIL6210_ITR_TRSH,
+			  wil->csr + HOSTADDR(RGF_DMA_ITR_CNT_TRSH));
+		iowrite32(BIT_DMA_ITR_CNT_CRL_EN,
+			  wil->csr + HOSTADDR(RGF_DMA_ITR_CNT_CRL));
+	}
+
 	wil6210_unmask_irq_pseudo(wil);
 	wil6210_unmask_irq_tx(wil);
 	wil6210_unmask_irq_rx(wil);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index c4a5163..1f91eaf 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -39,6 +39,7 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 #define WIL6210_MAX_TX_RINGS	(24) /* HW limit */
 #define WIL6210_MAX_CID		(8) /* HW limit */
 #define WIL6210_NAPI_BUDGET	(16) /* arbitrary */
+#define WIL6210_ITR_TRSH	(10000) /* arbitrary - about 15 IRQs/msec */
 
 /* Hardware definitions begin */
 
-- 
1.8.3.2

