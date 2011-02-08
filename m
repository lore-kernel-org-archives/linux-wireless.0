Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab1BHJFK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 04:05:10 -0500
Date: Tue, 8 Feb 2011 10:04:47 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
Subject: [PATCH] iwl3945: increase plcp check threshold
Message-ID: <20110208090446.GA2490@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwl3945: increase plcp check threshold

Patch fixes:
https://bugzilla.redhat.com/show_bug.cgi?id=654599

Many users report very low speed problem on 3945 devices,
this patch fixes problem, but only for some of them.

For unknown reason, sometimes after hw scanning, device is not able
to receive frames at high rate. Since plcp health check may request
hw scan to "reset radio", performance problem start to be observable
after update kernel to .35, where plcp check was introduced.

Bug reporter confirmed that increase plcp check threshold fixed
problem for him.

Reported-and-tested-by: SilvioTO <silviotoya@yahoo.it>
Cc: stable@kernel.org  # 2.6.35+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
Patch is oneliner, but does not apply on older kernel versions,
I will provide -stable patches when fix will land in mainline

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 58213e7..27faa5e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2775,7 +2775,7 @@ static struct iwl_base_params iwl3945_base_params = {
 	.use_isr_legacy = true,
 	.led_compensation = 64,
 	.broken_powersave = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_MAX,
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 512,
 	.tx_power_by_driver = true,
