Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:9562 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab0CYUoe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:44:34 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/3] iwlwifi: clear unattended interrupts in tasklet
Date: Thu, 25 Mar 2010 13:44:29 -0700
Message-Id: <1269549869-19162-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549869-19162-1-git-send-email-reinette.chatre@intel.com>
References: <1269549869-19162-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

Previously in interrupt handling tasklet, iwlwifi driver only clear/ack
those interrupts that are enabled by the driver through inta_mask.
If the hardware generates unattended interrupts, driver will not ack them,
defeating the interrupt coalescing feature. This results in high number
of interrupts per second and high CPU utilization.

This patch addresses this issue by acking those unattended interrupts
in the tasklet. Local test showed an order of magnitude improvement
in terms of the number of interrupts without sacrificing networking
throughput. This is a workaround for hardware issue.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c8e2e3a..e4c2e1e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1258,7 +1258,15 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	/* Ack/clear/reset pending uCode interrupts.
 	 * Note:  Some bits in CSR_INT are "OR" of bits in CSR_FH_INT_STATUS,
 	 */
-	iwl_write32(priv, CSR_INT, priv->inta);
+	/* There is a hardware bug in the interrupt mask function that some
+	 * interrupts (i.e. CSR_INT_BIT_SCD) can still be generated even if
+	 * they are disabled in the CSR_INT_MASK register. Furthermore the
+	 * ICT interrupt handling mechanism has another bug that might cause
+	 * these unmasked interrupts fail to be detected. We workaround the
+	 * hardware bugs here by ACKing all the possible interrupts so that
+	 * interrupt coalescing can still be achieved.
+	 */
+	iwl_write32(priv, CSR_INT, priv->inta | ~priv->inta_mask);
 
 	inta = priv->inta;
 
-- 
1.6.3.3

