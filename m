Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:8358 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091Ab0FFG4T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:19 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/4] iwl3945: enable stuck queue detection on 3945
Date: Sat,  5 Jun 2010 23:56:00 -0700
Message-Id: <1275807363-18150-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807363-18150-1-git-send-email-reinette.chatre@intel.com>
References: <1275807363-18150-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

We learn from
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=1834 and
https://bugzilla.redhat.com/show_bug.cgi?id=589777
that 3945 can also suffer from a stuck command queue. Enable stuck queue
detection for iwl3945 to enable recovery in this case.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 068f7f8..c44a303 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2852,6 +2852,7 @@ static struct iwl_lib_ops iwl3945_lib = {
 	.isr = iwl_isr_legacy,
 	.config_ap = iwl3945_config_ap,
 	.manage_ibss_station = iwl3945_manage_ibss_station,
+	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl3945_good_plcp_health,
 
 	.debugfs_ops = {
-- 
1.7.0.4

