Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:37826 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752555AbdGaQcv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Jul 2017 12:32:51 -0400
Cc: Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 08/10] wil6210: fix interface-up check
Date: Mon, 31 Jul 2017 19:32:31 +0300
Message-Id: <1501518753-6339-9-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170731_183255_473697_979DDD87)
In-Reply-To: <1501518753-6339-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1501518753-6339-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>

While wil_open is executed, any call to netif_running
would return a success. In case there are failures
within wil_open, should not treat the device as if it
is already opened in relevant functions (like FW recovery
and runtime suspend check).

Fix that by checking the device up flag instead.

Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 3 ++-
 drivers/net/wireless/ath/wil6210/pm.c   | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 8968c2c..b1e2814 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -394,10 +394,11 @@ static void wil_fw_error_worker(struct work_struct *work)
 	struct wil6210_priv *wil = container_of(work, struct wil6210_priv,
 						fw_error_worker);
 	struct wireless_dev *wdev = wil->wdev;
+	struct net_device *ndev = wil_to_ndev(wil);
 
 	wil_dbg_misc(wil, "fw error worker\n");
 
-	if (!netif_running(wil_to_ndev(wil))) {
+	if (!(ndev->flags & IFF_UP)) {
 		wil_info(wil, "No recovery - interface is down\n");
 		return;
 	}
diff --git a/drivers/net/wireless/ath/wil6210/pm.c b/drivers/net/wireless/ath/wil6210/pm.c
index 4a18f8e..4f61dc1 100644
--- a/drivers/net/wireless/ath/wil6210/pm.c
+++ b/drivers/net/wireless/ath/wil6210/pm.c
@@ -24,6 +24,7 @@ int wil_can_suspend(struct wil6210_priv *wil, bool is_runtime)
 {
 	int rc = 0;
 	struct wireless_dev *wdev = wil->wdev;
+	struct net_device *ndev = wil_to_ndev(wil);
 	bool wmi_only = test_bit(WMI_FW_CAPABILITY_WMI_ONLY,
 				 wil->fw_capabilities);
 
@@ -35,7 +36,8 @@ int wil_can_suspend(struct wil6210_priv *wil, bool is_runtime)
 		rc = -EPERM;
 		goto out;
 	}
-	if (!netif_running(wil_to_ndev(wil))) {
+
+	if (!(ndev->flags & IFF_UP)) {
 		/* can always sleep when down */
 		wil_dbg_pm(wil, "Interface is down\n");
 		goto out;
-- 
1.9.1
