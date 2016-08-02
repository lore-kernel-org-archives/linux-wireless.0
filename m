Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24102 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbcHBLpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 07:45:39 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 2/8] wil6210: fix HALP handling in case of HALP vote time-out
Date: Tue,  2 Aug 2016 14:42:06 +0300
Message-Id: <1470138132-18071-3-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160802_192523_767358_9B5EF061)
In-Reply-To: <1470138132-18071-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1470138132-18071-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case HALP vote times out, we need to mask the HALP IRQ, as done
in case the interrupt is received, as this interrupt should be
set until completion of the low latency operation.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 11 +++++++++--
 drivers/net/wireless/ath/wil6210/main.c      |  7 +++++--
 drivers/net/wireless/ath/wil6210/wil6210.h   |  1 +
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 011e741..f10c47d 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2015 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2016 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -101,7 +101,7 @@ static void wil6210_mask_irq_misc(struct wil6210_priv *wil, bool mask_halp)
 	      mask_halp ? WIL6210_IRQ_DISABLE : WIL6210_IRQ_DISABLE_NO_HALP);
 }
 
-static void wil6210_mask_halp(struct wil6210_priv *wil)
+void wil6210_mask_halp(struct wil6210_priv *wil)
 {
 	wil_dbg_irq(wil, "%s()\n", __func__);
 
@@ -503,6 +503,13 @@ static int wil6210_debug_irq_mask(struct wil6210_priv *wil, u32 pseudo_cause)
 				offsetof(struct RGF_ICR, ICR));
 		u32 imv_misc = wil_r(wil, RGF_DMA_EP_MISC_ICR +
 				     offsetof(struct RGF_ICR, IMV));
+
+		/* HALP interrupt can be unmasked when misc interrupts are
+		 * masked
+		 */
+		if (icr_misc & BIT_DMA_EP_MISC_ICR_HALP)
+			return 0;
+
 		wil_err(wil, "IRQ when it should be masked: pseudo 0x%08x\n"
 				"Rx   icm:icr:imv 0x%08x 0x%08x 0x%08x\n"
 				"Tx   icm:icr:imv 0x%08x 0x%08x 0x%08x\n"
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 4bc92e5..4240e81 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1124,13 +1124,16 @@ void wil_halp_vote(struct wil6210_priv *wil)
 	if (++wil->halp.ref_cnt == 1) {
 		wil6210_set_halp(wil);
 		rc = wait_for_completion_timeout(&wil->halp.comp, to_jiffies);
-		if (!rc)
+		if (!rc) {
 			wil_err(wil, "%s: HALP vote timed out\n", __func__);
-		else
+			/* Mask HALP as done in case the interrupt is raised */
+			wil6210_mask_halp(wil);
+		} else {
 			wil_dbg_misc(wil,
 				     "%s: HALP vote completed after %d ms\n",
 				     __func__,
 				     jiffies_to_msecs(to_jiffies - rc));
+		}
 	}
 
 	wil_dbg_misc(wil, "%s: end, HALP ref_cnt (%d)\n", __func__,
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index ecab4af..9742446 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -828,6 +828,7 @@ void wil_unmask_irq(struct wil6210_priv *wil);
 void wil_configure_interrupt_moderation(struct wil6210_priv *wil);
 void wil_disable_irq(struct wil6210_priv *wil);
 void wil_enable_irq(struct wil6210_priv *wil);
+void wil6210_mask_halp(struct wil6210_priv *wil);
 
 /* P2P */
 bool wil_p2p_is_social_scan(struct cfg80211_scan_request *request);
-- 
1.9.1

