Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33762 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbYLIT2A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 14:28:00 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/4] iwlifi: remove twice defined SINGLE_FRAME RX FH MASK
Date: Tue,  9 Dec 2008 11:28:59 -0800
Message-Id: <1228850941-16677-3-git-send-email-reinette.chatre@intel.com> (sfid-20081209_202808_807200_152D01F4)
In-Reply-To: <1228850941-16677-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228850941-16677-1-git-send-email-reinette.chatre@intel.com>
 <1228850941-16677-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch removes second definition of FH_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME
in iwl-fh.h

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Reported-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Acked-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fh.h |    3 ---
 drivers/net/wireless/iwlwifi/iwl-rx.c |    2 +-
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 2ff9434..d7da198 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -266,11 +266,8 @@
 #define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_NO_INT_VAL    (0x00000000)
 #define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL  (0x00001000)
 
-#define FH_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME	(0x00008000)
-
 #define FH_RSCSR_FRAME_SIZE_MSK	(0x00003FFF)	/* bits 0-13 */
 
-
 /**
  * Rx Shared Status Registers (RSSR)
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 58d339e..6ae767d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -439,7 +439,7 @@ int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 			   FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
 			   FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY |
 			   FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
-			   FH_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME |
+			   FH_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME_MSK |
 			   rb_size|
 			   (rb_timeout << FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS)|
 			   (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
-- 
1.5.4.3

