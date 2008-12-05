Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49805 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756096AbYLEP5p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 10:57:45 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, "Zhu, Yi" <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/6] iwlwifi: fix "MAC in deep sleep" error
Date: Fri,  5 Dec 2008 07:58:39 -0800
Message-Id: <1228492721-27381-5-git-send-email-reinette.chatre@intel.com> (sfid-20081205_165752_571930_D60D3374)
In-Reply-To: <1228492721-27381-4-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228492721-27381-1-git-send-email-reinette.chatre@intel.com>
 <1228492721-27381-2-git-send-email-reinette.chatre@intel.com>
 <1228492721-27381-3-git-send-email-reinette.chatre@intel.com>
 <1228492721-27381-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu, Yi <yi.zhu@intel.com>

This patch fixes the misue of CSR_GP_CNTRL with CSR_RESET address
in polling the CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY bit in
iwl4965_apm_reset(). This causes "MAC in deep sleep" error sometimes.
The patch also fixes the timeout value and the iwl_poll_bit() return
value check.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 87c7bb0..c961e2c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -482,11 +482,11 @@ static int iwl4965_apm_reset(struct iwl_priv *priv)
 
 	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
-	ret = iwl_poll_bit(priv, CSR_RESET,
+	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
 			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25);
+			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 
-	if (ret)
+	if (ret < 0)
 		goto out;
 
 	udelay(10);
-- 
1.5.4.3

