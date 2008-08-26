Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18520 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbYHZCiR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 22:38:17 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2.6.27 2/2] iwlwifi: fix 64bit platform firmware loading
Date: Tue, 26 Aug 2008 10:34:31 +0800
Message-Id: <1219718071-13587-2-git-send-email-yi.zhu@intel.com> (sfid-20080826_043820_676571_4D937DA1)
In-Reply-To: <1219718071-13587-1-git-send-email-yi.zhu@intel.com>
References: <1219718071-13587-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes loading firmware from memory above 34bit.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   11 ++++-------
 drivers/net/wireless/iwlwifi/iwl-fh.h   |    1 +
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 897652c..b011d1c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -534,14 +534,11 @@ static int iwl5000_load_section(struct iwl_priv *priv,
 		FH_TFDIB_CTRL0_REG(FH_SRVC_CHNL),
 		phy_addr & FH_MEM_TFDIB_DRAM_ADDR_LSB_MSK);
 
-	/* FIME: write the MSB of the phy_addr in CTRL1
-	 * iwl_write_direct32(priv,
-		IWL_FH_TFDIB_CTRL1_REG(IWL_FH_SRVC_CHNL),
-		((phy_addr & MSB_MSK)
-			<< FH_MEM_TFDIB_REG1_ADDR_BITSHIFT) | byte_count);
-	 */
 	iwl_write_direct32(priv,
-		FH_TFDIB_CTRL1_REG(FH_SRVC_CHNL), byte_cnt);
+		FH_TFDIB_CTRL1_REG(FH_SRVC_CHNL),
+		(iwl_get_dma_hi_address(phy_addr)
+			<< FH_MEM_TFDIB_REG1_ADDR_BITSHIFT) | byte_cnt);
+
 	iwl_write_direct32(priv,
 		FH_TCSR_CHNL_TX_BUF_STS_REG(FH_SRVC_CHNL),
 		1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM |
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 9446424..cd11c0c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -287,6 +287,7 @@
 
 #define FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE	(0x01000000)
 
+#define FH_MEM_TFDIB_REG1_ADDR_BITSHIFT	28
 
 /**
  * Transmit DMA Channel Control/Status Registers (TCSR)
-- 
1.5.3.6

