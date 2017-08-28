Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:41752 "EHLO
        alexa-out-lv-01.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751241AbdH1TTC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Aug 2017 15:19:02 -0400
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4/7] wil6210: move pre-FW configuration to separate function
Date: Mon, 28 Aug 2017 22:18:44 +0300
Message-Id: <1503947927-18877-5-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170828_211914_416888_788E7A3C)
In-Reply-To: <1503947927-18877-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1503947927-18877-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>

Re-arrange the code to have dedicated function for device configuration
which takes place before FW starts running.

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 40 ++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index e2ea490..927e332 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -930,6 +930,27 @@ int wil_ps_update(struct wil6210_priv *wil, enum wmi_ps_profile_type ps_profile)
 	return rc;
 }
 
+static void wil_pre_fw_config(struct wil6210_priv *wil)
+{
+	/* Mark FW as loaded from host */
+	wil_s(wil, RGF_USER_USAGE_6, 1);
+
+	/* clear any interrupts which on-card-firmware
+	 * may have set
+	 */
+	wil6210_clear_irq(wil);
+	/* CAF_ICR - clear and mask */
+	/* it is W1C, clear by writing back same value */
+	wil_s(wil, RGF_CAF_ICR + offsetof(struct RGF_ICR, ICR), 0);
+	wil_w(wil, RGF_CAF_ICR + offsetof(struct RGF_ICR, IMV), ~0);
+
+	if (wil->fw_calib_result > 0) {
+		__le32 val = cpu_to_le32(wil->fw_calib_result |
+						(CALIB_RESULT_SIGNATURE << 8));
+		wil_w(wil, RGF_USER_FW_CALIB_RESULT, (u32 __force)val);
+	}
+}
+
 /*
  * We reset all the structures, and we reset the UMAC.
  * After calling this routine, you're expected to reload
@@ -1023,24 +1044,7 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 		if (rc)
 			return rc;
 
-		/* Mark FW as loaded from host */
-		wil_s(wil, RGF_USER_USAGE_6, 1);
-
-		/* clear any interrupts which on-card-firmware
-		 * may have set
-		 */
-		wil6210_clear_irq(wil);
-		/* CAF_ICR - clear and mask */
-		/* it is W1C, clear by writing back same value */
-		wil_s(wil, RGF_CAF_ICR + offsetof(struct RGF_ICR, ICR), 0);
-		wil_w(wil, RGF_CAF_ICR + offsetof(struct RGF_ICR, IMV), ~0);
-
-		if (wil->fw_calib_result > 0) {
-			__le32 val = cpu_to_le32(wil->fw_calib_result |
-						 (CALIB_RESULT_SIGNATURE << 8));
-			wil_w(wil, RGF_USER_FW_CALIB_RESULT, (u32 __force)val);
-		}
-
+		wil_pre_fw_config(wil);
 		wil_release_cpu(wil);
 	}
 
-- 
1.9.1
