Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46407 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab2H2OKm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2012 10:10:42 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 1/4] ath6kl: Refactor ath6kl_init_hw_start() and ath6kl_init_hw_stop()
Date: Wed, 29 Aug 2012 19:40:25 +0530
Message-ID: <1346249428-24741-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120829_161047_168772_0F7A7FA6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So that these functions will be used to re-initialize the fw
upon detecting fw error. This refactoring moves ar->state
setting out of core stop/start functionality.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index eb3677b..be27ebe 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1546,7 +1546,7 @@ static const char *ath6kl_init_get_hif_name(enum ath6kl_hif_type type)
 	return NULL;
 }
 
-int ath6kl_init_hw_start(struct ath6kl *ar)
+static int __ath6kl_init_hw_start(struct ath6kl *ar)
 {
 	long timeleft;
 	int ret, i;
@@ -1642,8 +1642,6 @@ int ath6kl_init_hw_start(struct ath6kl *ar)
 			goto err_htc_stop;
 	}
 
-	ar->state = ATH6KL_STATE_ON;
-
 	return 0;
 
 err_htc_stop:
@@ -1656,7 +1654,18 @@ err_power_off:
 	return ret;
 }
 
-int ath6kl_init_hw_stop(struct ath6kl *ar)
+int ath6kl_init_hw_start(struct ath6kl *ar)
+{
+	int err;
+
+	err = __ath6kl_init_hw_start(ar);
+	if (err)
+		return err;
+	ar->state = ATH6KL_STATE_ON;
+	return 0;
+}
+
+static int __ath6kl_init_hw_stop(struct ath6kl *ar)
 {
 	int ret;
 
@@ -1672,8 +1681,17 @@ int ath6kl_init_hw_stop(struct ath6kl *ar)
 	if (ret)
 		ath6kl_warn("failed to power off hif: %d\n", ret);
 
-	ar->state = ATH6KL_STATE_OFF;
+	return 0;
+}
 
+int ath6kl_init_hw_stop(struct ath6kl *ar)
+{
+	int err;
+
+	err = __ath6kl_init_hw_stop(ar);
+	if (err)
+		return err;
+	ar->state = ATH6KL_STATE_OFF;
 	return 0;
 }
 
-- 
1.7.0.4

