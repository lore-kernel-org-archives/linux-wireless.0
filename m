Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab1BIHqJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 02:46:09 -0500
Date: Wed, 9 Feb 2011 08:46:06 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>
Subject: [PATCH v2] iwl3945: remove plcp check
Message-ID: <20110209074606.GA5528@redhat.com>
References: <20110208090446.GA2490@redhat.com>
 <1297180040.20613.39.camel@wwguy-ubuntu>
 <20110209063137.GD2184@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110209063137.GD2184@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch fixes:
https://bugzilla.redhat.com/show_bug.cgi?id=654599
 
Many users report very low speed problem on 3945 devices,
this patch fixes problem, but only for some of them.
 
For unknown reason, sometimes after hw scanning, device is not able
to receive frames at high rate. Since plcp health check may request
hw scan to "reset radio", performance problem start to be observable
after update kernel to .35, where plcp check was introduced.

Bug reporter confirmed that removing plcp check fixed problem for him.
 
Reported-and-tested-by: SilvioTO <silviotoya@yahoo.it>
Cc: stable@kernel.org  # 2.6.35+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2
Instead of tuning threshold remove the check completely

This is minimal fix, without any additional code removal
(what introduce one compile warning). I will remove dead code
after Intel push they current driver split work, to do not
create merge problems now.

Patch also does not apply cleanly on 2.6.35, I will provide
additional -stable patch when this one hit mainline.

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 58213e7..5b6932c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2734,7 +2734,6 @@ static struct iwl_lib_ops iwl3945_lib = {
 	.isr_ops = {
 		.isr = iwl_isr_legacy,
 	},
-	.check_plcp_health = iwl3945_good_plcp_health,
 
 	.debugfs_ops = {
 		.rx_stats_read = iwl3945_ucode_rx_stats_read,
