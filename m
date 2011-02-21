Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab1BUIDc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 03:03:32 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: stable@kernel.org, kernel@lists.fedoraproject.org
Cc: Kyle McMartin <kmcmartin@redhat.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2.6.35] iwl3945: remove plcp check
Date: Mon, 21 Feb 2011 09:03:36 +0100
Message-Id: <1298275416-3871-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit c91d01556f52255a31575be0cb1981c92a2a5028 upstream.

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
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 2a9480d..7b4fc94 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2837,7 +2837,6 @@ static struct iwl_lib_ops iwl3945_lib = {
 	.config_ap = iwl3945_config_ap,
 	.manage_ibss_station = iwl3945_manage_ibss_station,
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
-	.check_plcp_health = iwl3945_good_plcp_health,
 
 	.debugfs_ops = {
 		.rx_stats_read = iwl3945_ucode_rx_stats_read,
-- 
1.7.1

