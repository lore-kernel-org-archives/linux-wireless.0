Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5508 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933040AbdDEL6j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 07:58:39 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 11/11] wil6210: prevent access to 11AD device if resume fails
Date: Wed,  5 Apr 2017 14:58:14 +0300
Message-Id: <1491393494-11816-12-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170405_140157_074260_5666890F)
In-Reply-To: <1491393494-11816-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1491393494-11816-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case wil6210 resume fails, wil6210 suspend function will try
to access the suspended device in the next kernel suspend.
To prevent that, add wil_status_suspended flag to indicate if the
device is already suspended and clear it only if the resume succeeds.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/pm.c      | 16 ++++++++++++++--
 drivers/net/wireless/ath/wil6210/wil6210.h |  1 +
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/pm.c b/drivers/net/wireless/ath/wil6210/pm.c
index 7260bef..2ae4fe8 100644
--- a/drivers/net/wireless/ath/wil6210/pm.c
+++ b/drivers/net/wireless/ath/wil6210/pm.c
@@ -71,6 +71,11 @@ int wil_suspend(struct wil6210_priv *wil, bool is_runtime)
 
 	wil_dbg_pm(wil, "suspend: %s\n", is_runtime ? "runtime" : "system");
 
+	if (test_bit(wil_status_suspended, wil->status)) {
+		wil_dbg_pm(wil, "trying to suspend while suspended\n");
+		return 0;
+	}
+
 	/* if netif up, hardware is alive, shut it down */
 	if (ndev->flags & IFF_UP) {
 		rc = wil_down(wil);
@@ -86,10 +91,14 @@ int wil_suspend(struct wil6210_priv *wil, bool is_runtime)
 
 	if (wil->platform_ops.suspend) {
 		rc = wil->platform_ops.suspend(wil->platform_handle);
-		if (rc)
+		if (rc) {
 			wil_enable_irq(wil);
+			goto out;
+		}
 	}
 
+	set_bit(wil_status_suspended, wil->status);
+
 out:
 	wil_dbg_pm(wil, "suspend: %s => %d\n",
 		   is_runtime ? "runtime" : "system", rc);
@@ -117,10 +126,13 @@ int wil_resume(struct wil6210_priv *wil, bool is_runtime)
 
 	/* if netif up, bring hardware up
 	 * During open(), IFF_UP set after actual device method
-	 * invocation. This prevent recursive call to wil_up()
+	 * invocation. This prevent recursive call to wil_up().
+	 * wil_status_suspended will be cleared in wil_reset
 	 */
 	if (ndev->flags & IFF_UP)
 		rc = wil_up(wil);
+	else
+		clear_bit(wil_status_suspended, wil->status);
 
 out:
 	wil_dbg_pm(wil, "resume: %s => %d\n",
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index ec646d7..b00c803 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -412,6 +412,7 @@ enum { /* for wil6210_priv.status */
 	wil_status_irqen, /* FIXME: interrupts enabled - for debug */
 	wil_status_napi_en, /* NAPI enabled protected by wil->mutex */
 	wil_status_resetting, /* reset in progress */
+	wil_status_suspended, /* suspend completed, device is suspended */
 	wil_status_last /* keep last */
 };
 
-- 
1.9.1
