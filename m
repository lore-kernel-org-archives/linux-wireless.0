Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26704 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab1IFRPL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 13:15:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/10] iwlagn: disply queue read/write pointer when stuck
Date: Tue,  6 Sep 2011 09:31:22 -0700
Message-Id: <1315326685-22213-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110906_191527_552650_FDC110B6)
In-Reply-To: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When driver detect queue stuck, display current read/write pointer before
perform frimware reload.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 5bf6250..c495fc3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1497,6 +1497,8 @@ static int iwl_trans_pcie_check_stuck_queue(struct iwl_trans *trans, int cnt)
 	if (time_after(jiffies, timeout)) {
 		IWL_ERR(trans, "Queue %d stuck for %u ms.\n", q->id,
 			hw_params(trans).wd_timeout);
+		IWL_ERR(trans, "Current read_ptr %d write_ptr %d\n",
+			q->read_ptr, q->write_ptr);
 		return 1;
 	}
 
-- 
1.7.0.4

