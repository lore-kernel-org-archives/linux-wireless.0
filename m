Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44560 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbXJYJWy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:54 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 19/30] iwlwifi: add 5965 SCD registers to iwl-prph.h
Date: Thu, 25 Oct 2007 17:15:40 +0800
Message-Id: <11933037794199-git-send-email-yi.zhu@intel.com> (sfid-20071025_104105_165589_E64A038D)
In-Reply-To: <11933037784073-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
 <119330375796-git-send-email-yi.zhu@intel.com>
 <11933037584069-git-send-email-yi.zhu@intel.com>
 <11933037601236-git-send-email-yi.zhu@intel.com>
 <11933037613709-git-send-email-yi.zhu@intel.com>
 <1193303762680-git-send-email-yi.zhu@intel.com>
 <11933037641168-git-send-email-yi.zhu@intel.com>
 <11933037663659-git-send-email-yi.zhu@intel.com>
 <11933037674045-git-send-email-yi.zhu@intel.com>
 <11933037692766-git-send-email-yi.zhu@intel.com>
 <1193303770550-git-send-email-yi.zhu@intel.com>
 <11933037721573-git-send-email-yi.zhu@intel.com>
 <1193303773185-git-send-email-yi.zhu@intel.com>
 <11933037743841-git-send-email-yi.zhu@intel.com>
 <11933037762104-git-send-email-yi.zhu@intel.com>
 <11933037784073-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch adds SCD registers for 5965

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index ee4af3f..137947d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -236,7 +236,6 @@
 #define ALM_SCD_SBYP_MODE_1_REG             (ALM_SCD_BASE + 0x02C)
 #define ALM_SCD_SBYP_MODE_2_REG             (ALM_SCD_BASE + 0x030)
 
-
 /* 4965 SCD memory mapped registers */
 #define KDR_SCD_BASE		(PRPH_BASE + 0xa02c00)
 
@@ -267,4 +266,15 @@
 #define KDR_SCD_QUERY_MIN_FRAME_SIZE   (KDR_SCD_BASE + 0x100)
 #define KDR_SCD_QUEUE_STATUS_BITS(x)   (KDR_SCD_BASE + 0x104 + (x) * 4)
 
+/* SP SCD */
+#define SHL_SCD_BASE			(PRPH_BASE + 0xa02c00)
+
+#define SHL_SCD_AIT                    (SHL_SCD_BASE + 0x0c)
+#define SHL_SCD_TXFACT                 (SHL_SCD_BASE + 0x10)
+#define SHL_SCD_QUEUE_WRPTR(x)         (SHL_SCD_BASE + 0x18 + (x) * 4)
+#define SHL_SCD_QUEUE_RDPTR(x)         (SHL_SCD_BASE + 0x68 + (x) * 4)
+#define SHL_SCD_QUEUECHAIN_SEL         (SHL_SCD_BASE + 0xe8)
+#define SHL_SCD_AGGR_SEL	       (SHL_SCD_BASE + 0x248)
+#define SHL_SCD_INTERRUPT_MASK         (SHL_SCD_BASE + 0x108)
+
 #endif				/* __iwl_prph_h__ */
-- 
1.5.2
