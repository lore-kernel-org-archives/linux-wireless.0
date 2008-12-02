Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9103 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbYLBUNM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:13:12 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 02/11] iwlwifi: fix printk size format error
Date: Tue,  2 Dec 2008 12:13:58 -0800
Message-Id: <1228248847-10424-3-git-send-email-reinette.chatre@intel.com> (sfid-20081202_211319_655538_7F32ABE1)
In-Reply-To: <1228248847-10424-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228248847-10424-1-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

The patch fixes a printk size format error.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4f45894..de1ec54 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1539,7 +1539,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
 		/* Hardware disappeared. It might have already raised
 		 * an interrupt */
-		IWL_WARNING("HARDWARE GONE?? INTA == 0x%080x\n", inta);
+		IWL_WARNING("HARDWARE GONE?? INTA == 0x%08x\n", inta);
 		goto unplugged;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 7902339..074b43c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4450,7 +4450,7 @@ static irqreturn_t iwl3945_isr(int irq, void *data)
 
 	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
 		/* Hardware disappeared */
-		IWL_WARNING("HARDWARE GONE?? INTA == 0x%080x\n", inta);
+		IWL_WARNING("HARDWARE GONE?? INTA == 0x%08x\n", inta);
 		goto unplugged;
 	}
 
-- 
1.5.4.3

