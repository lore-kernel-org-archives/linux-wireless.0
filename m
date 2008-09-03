Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56324 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015AbYICDbY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:24 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 22/39] iwlwifi: fix 64bit platform firmware loading
Date: Wed,  3 Sep 2008 11:26:42 +0800
Message-Id: <1220412419-15404-23-git-send-email-yi.zhu@intel.com> (sfid-20080903_055043_293663_8CEAD5B0)
In-Reply-To: <1220412419-15404-22-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-13-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-14-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-15-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-16-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-17-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-18-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-19-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-20-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-21-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-22-git-send-email-yi.zhu@intel.com>
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
index e04a26f..79ff288 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -533,14 +533,11 @@ static int iwl5000_load_section(struct iwl_priv *priv,
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

