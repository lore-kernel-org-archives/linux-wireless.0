Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16906 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbbCVRVk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 13:21:40 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 3/6] iwlwifi: dvm: run INIT firmware again upon .start()
Date: Sun, 22 Mar 2015 19:21:29 +0200
Message-Id: <1427044892-13907-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150322_182145_316819_2C022EE3)
In-Reply-To: <1427044767.8611.4.camel@egrumbacBox>
References: <1427044767.8611.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The assumption before this patch was that we don't need to
run again the INIT firmware after the system booted. The
INIT firmware runs calibrations which impact the physical
layer's behavior.
Users reported that it may be helpful to run these
calibrations again every time the interface is brought up.
The penatly is minimal, since the calibrations run fast.
This fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=94341

CC: <stable@vger.kernel.org>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/dev.h   | 1 -
 drivers/net/wireless/iwlwifi/dvm/ucode.c | 5 -----
 2 files changed, 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/dev.h b/drivers/net/wireless/iwlwifi/dvm/dev.h
index a6f22c3..3811878 100644
--- a/drivers/net/wireless/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/iwlwifi/dvm/dev.h
@@ -708,7 +708,6 @@ struct iwl_priv {
 	unsigned long reload_jiffies;
 	int reload_count;
 	bool ucode_loaded;
-	bool init_ucode_run;		/* Don't run init uCode again */
 
 	u8 plcp_delta_threshold;
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/ucode.c b/drivers/net/wireless/iwlwifi/dvm/ucode.c
index 4dbef7e..5244e43 100644
--- a/drivers/net/wireless/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/ucode.c
@@ -418,9 +418,6 @@ int iwl_run_init_ucode(struct iwl_priv *priv)
 	if (!priv->fw->img[IWL_UCODE_INIT].sec[0].len)
 		return 0;
 
-	if (priv->init_ucode_run)
-		return 0;
-
 	iwl_init_notification_wait(&priv->notif_wait, &calib_wait,
 				   calib_complete, ARRAY_SIZE(calib_complete),
 				   iwlagn_wait_calib, priv);
@@ -440,8 +437,6 @@ int iwl_run_init_ucode(struct iwl_priv *priv)
 	 */
 	ret = iwl_wait_notification(&priv->notif_wait, &calib_wait,
 					UCODE_CALIB_TIMEOUT);
-	if (!ret)
-		priv->init_ucode_run = true;
 
 	goto out;
 
-- 
1.9.1

