Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24718 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbZFCShS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 14:37:18 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/6] iwlagn: delay ict interrupt.
Date: Wed,  3 Jun 2009 11:44:10 -0700
Message-Id: <1244054652-19451-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1244054652-19451-4-git-send-email-reinette.chatre@intel.com>
References: <1244054652-19451-1-git-send-email-reinette.chatre@intel.com>
 <1244054652-19451-2-git-send-email-reinette.chatre@intel.com>
 <1244054652-19451-3-git-send-email-reinette.chatre@intel.com>
 <1244054652-19451-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

 Wait until ucode is loaded and driver receive ALIVE_REPLY then switch
 to ICT interrupt. This ensures we receive all interrupts indicating
 successful ucode load.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e6ecb3f..b77208d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1887,8 +1887,6 @@ static int __iwl_up(struct iwl_priv *priv)
 
 	/* clear (again), then enable host interrupts */
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
-	/* enable dram interrupt */
-	iwl_reset_ict(priv);
 	iwl_enable_interrupts(priv);
 
 	/* really make sure rfkill handshake bits are cleared */
@@ -1962,6 +1960,9 @@ static void iwl_bg_alive_start(struct work_struct *data)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
+	/* enable dram interrupt */
+	iwl_reset_ict(priv);
+
 	mutex_lock(&priv->mutex);
 	iwl_alive_start(priv);
 	mutex_unlock(&priv->mutex);
-- 
1.5.6.3

