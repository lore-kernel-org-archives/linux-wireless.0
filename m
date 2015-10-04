Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24814 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbJDHYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 03:24:00 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 10/10] wil6210: Do no schedule firmware recovery during reset flow
Date: Sun,  4 Oct 2015 10:23:27 +0300
Message-Id: <1443943407-6663-11-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20151004_092405_612039_7B3EC68E)
In-Reply-To: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>

During reset flow, ignore firmware errors detected prior
to the actual hardware reset as the recovery flow would
make additional unnecessary reset.

Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c    | 8 ++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index de6e3c2..aade16b 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -767,6 +767,8 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 	if (wil->hw_version == HW_VER_UNKNOWN)
 		return -ENODEV;
 
+	set_bit(wil_status_resetting, wil->status);
+
 	cancel_work_sync(&wil->disconnect_worker);
 	wil6210_disconnect(wil, NULL, WLAN_REASON_DEAUTH_LEAVING, false);
 	wil_bcast_fini(wil);
@@ -853,6 +855,12 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 void wil_fw_error_recovery(struct wil6210_priv *wil)
 {
 	wil_dbg_misc(wil, "starting fw error recovery\n");
+
+	if (test_bit(wil_status_resetting, wil->status)) {
+		wil_info(wil, "Reset already in progress\n");
+		return;
+	}
+
 	wil->recovery_state = fw_recovery_pending;
 	schedule_work(&wil->fw_error_worker);
 }
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 9a90a58..f619bf2 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -409,6 +409,7 @@ enum { /* for wil6210_priv.status */
 	wil_status_reset_done,
 	wil_status_irqen, /* FIXME: interrupts enabled - for debug */
 	wil_status_napi_en, /* NAPI enabled protected by wil->mutex */
+	wil_status_resetting, /* reset in progress */
 	wil_status_last /* keep last */
 };
 
-- 
2.1.4

