Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:35554 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752616AbdHBVBJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 17:01:09 -0400
Cc: Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2 7/9] wil6210: fix interface-up check
Date: Thu,  3 Aug 2017 00:00:47 +0300
Message-Id: <1501707649-9665-8-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170802_230113_956897_815FE5DC)
In-Reply-To: <1501707649-9665-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1501707649-9665-1-git-send-email-qca_merez@qca.qualcomm.com>
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
 drivers/net/wireless/ath/wil6210/pm.c   | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

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
index 820ed17..8f5d1b44 100644
--- a/drivers/net/wireless/ath/wil6210/pm.c
+++ b/drivers/net/wireless/ath/wil6210/pm.c
@@ -21,10 +21,11 @@ int wil_can_suspend(struct wil6210_priv *wil, bool is_runtime)
 {
 	int rc = 0;
 	struct wireless_dev *wdev = wil->wdev;
+	struct net_device *ndev = wil_to_ndev(wil);
 
 	wil_dbg_pm(wil, "can_suspend: %s\n", is_runtime ? "runtime" : "system");
 
-	if (!netif_running(wil_to_ndev(wil))) {
+	if (!(ndev->flags & IFF_UP)) {
 		/* can always sleep when down */
 		wil_dbg_pm(wil, "Interface is down\n");
 		goto out;
-- 
1.9.1
