Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5508 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932927AbdDEL6W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 07:58:22 -0400
Cc: Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 01/11] wil6210: fix sequence for scan-abort during reset
Date: Wed,  5 Apr 2017 14:58:04 +0300
Message-Id: <1491393494-11816-2-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170405_140202_121116_7E7A5A41)
In-Reply-To: <1491393494-11816-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1491393494-11816-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>

Communication with FW must be done before wil->status
is initialized in order to properly handle cases where
communication with FW halts during reset sequence.

Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index c33cc4a..7e72096 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -948,15 +948,15 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 	/* Disable device led before reset*/
 	wmi_led_cfg(wil, false);
 
+	mutex_lock(&wil->p2p_wdev_mutex);
+	wil_abort_scan(wil, false);
+	mutex_unlock(&wil->p2p_wdev_mutex);
+
 	/* prevent NAPI from being scheduled and prevent wmi commands */
 	mutex_lock(&wil->wmi_mutex);
 	bitmap_zero(wil->status, wil_status_last);
 	mutex_unlock(&wil->wmi_mutex);
 
-	mutex_lock(&wil->p2p_wdev_mutex);
-	wil_abort_scan(wil, false);
-	mutex_unlock(&wil->p2p_wdev_mutex);
-
 	wil_mask_irq(wil);
 
 	wmi_event_flush(wil);
-- 
1.9.1
