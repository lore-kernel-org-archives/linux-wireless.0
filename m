Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2852 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbYJFILy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 04:11:54 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 4/7] iwlwifi: scan fix comment
Date: Mon,  6 Oct 2008 16:05:30 +0800
Message-Id: <1223280333-4383-5-git-send-email-yi.zhu@intel.com> (sfid-20081006_101202_497821_B395FCD1)
In-Reply-To: <1223280333-4383-4-git-send-email-yi.zhu@intel.com>
References: <1223280333-4383-1-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-2-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-3-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-4-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves comment to proper line, it has moved during
code shuffling.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index debdbd9..639904a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -843,7 +843,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 
 		/* Force use of chains B and C (0x6) for scan Rx for 4965
 		 * Avoid A (0x1) because of its off-channel reception on A-band.
-		 * MIMO is not used here, but value is required */
+		 */
 		if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965)
 			rx_chain = 0x6;
 	} else {
@@ -851,6 +851,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		goto done;
 	}
 
+	/* MIMO is not used here, but value is required */
 	scan->rx_chain = RXON_RX_CHAIN_DRIVER_FORCE_MSK |
 				cpu_to_le16((0x7 << RXON_RX_CHAIN_VALID_POS) |
 				(rx_chain << RXON_RX_CHAIN_FORCE_SEL_POS) |
-- 
1.5.3.6

