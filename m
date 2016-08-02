Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43958 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbcHBLnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 07:43:53 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 4/8] wil6210: change HALP logging category to IRQ
Date: Tue,  2 Aug 2016 14:42:08 +0300
Message-Id: <1470138132-18071-5-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160802_194951_228240_7140E58F)
In-Reply-To: <1470138132-18071-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1470138132-18071-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Change the logging category of HALP functions from
MISC to IRQ, since the HALP mechanism is closely
related to interrupts. Both HALP and IRQ create
a heavy load of logging messages when enabled,
so their logging is typically disabled during normal debug
scenarios. Having them in the same logging category
will make it easier to disable logging for both in one go.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c |  4 ++--
 drivers/net/wireless/ath/wil6210/main.c      | 26 +++++++++++++-------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index f10c47d..64046e0 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -599,7 +599,7 @@ void wil6210_clear_irq(struct wil6210_priv *wil)
 
 void wil6210_set_halp(struct wil6210_priv *wil)
 {
-	wil_dbg_misc(wil, "%s()\n", __func__);
+	wil_dbg_irq(wil, "%s()\n", __func__);
 
 	wil_w(wil, RGF_DMA_EP_MISC_ICR + offsetof(struct RGF_ICR, ICS),
 	      BIT_DMA_EP_MISC_ICR_HALP);
@@ -607,7 +607,7 @@ void wil6210_set_halp(struct wil6210_priv *wil)
 
 void wil6210_clear_halp(struct wil6210_priv *wil)
 {
-	wil_dbg_misc(wil, "%s()\n", __func__);
+	wil_dbg_irq(wil, "%s()\n", __func__);
 
 	wil_w(wil, RGF_DMA_EP_MISC_ICR + offsetof(struct RGF_ICR, ICR),
 	      BIT_DMA_EP_MISC_ICR_HALP);
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 4240e81..1205d76 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1118,8 +1118,8 @@ void wil_halp_vote(struct wil6210_priv *wil)
 
 	mutex_lock(&wil->halp.lock);
 
-	wil_dbg_misc(wil, "%s: start, HALP ref_cnt (%d)\n", __func__,
-		     wil->halp.ref_cnt);
+	wil_dbg_irq(wil, "%s: start, HALP ref_cnt (%d)\n", __func__,
+		    wil->halp.ref_cnt);
 
 	if (++wil->halp.ref_cnt == 1) {
 		wil6210_set_halp(wil);
@@ -1129,15 +1129,15 @@ void wil_halp_vote(struct wil6210_priv *wil)
 			/* Mask HALP as done in case the interrupt is raised */
 			wil6210_mask_halp(wil);
 		} else {
-			wil_dbg_misc(wil,
-				     "%s: HALP vote completed after %d ms\n",
-				     __func__,
-				     jiffies_to_msecs(to_jiffies - rc));
+			wil_dbg_irq(wil,
+				    "%s: HALP vote completed after %d ms\n",
+				    __func__,
+				    jiffies_to_msecs(to_jiffies - rc));
 		}
 	}
 
-	wil_dbg_misc(wil, "%s: end, HALP ref_cnt (%d)\n", __func__,
-		     wil->halp.ref_cnt);
+	wil_dbg_irq(wil, "%s: end, HALP ref_cnt (%d)\n", __func__,
+		    wil->halp.ref_cnt);
 
 	mutex_unlock(&wil->halp.lock);
 }
@@ -1148,16 +1148,16 @@ void wil_halp_unvote(struct wil6210_priv *wil)
 
 	mutex_lock(&wil->halp.lock);
 
-	wil_dbg_misc(wil, "%s: start, HALP ref_cnt (%d)\n", __func__,
-		     wil->halp.ref_cnt);
+	wil_dbg_irq(wil, "%s: start, HALP ref_cnt (%d)\n", __func__,
+		    wil->halp.ref_cnt);
 
 	if (--wil->halp.ref_cnt == 0) {
 		wil6210_clear_halp(wil);
-		wil_dbg_misc(wil, "%s: HALP unvote\n", __func__);
+		wil_dbg_irq(wil, "%s: HALP unvote\n", __func__);
 	}
 
-	wil_dbg_misc(wil, "%s: end, HALP ref_cnt (%d)\n", __func__,
-		     wil->halp.ref_cnt);
+	wil_dbg_irq(wil, "%s: end, HALP ref_cnt (%d)\n", __func__,
+		    wil->halp.ref_cnt);
 
 	mutex_unlock(&wil->halp.lock);
 }
-- 
1.9.1

