Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22844 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932864AbXHHHih (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:38:37 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ben Cahill <ben.m.cahill@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 27/28] iwlwifi: Correct missing hardware detection in iwl_isr()
Date: Wed,  8 Aug 2007 15:33:44 +0800
Message-Id: <11865584891294-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584861970-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
 <11865584473732-git-send-email-yi.zhu@intel.com>
 <11865584503648-git-send-email-yi.zhu@intel.com>
 <11865584521358-git-send-email-yi.zhu@intel.com>
 <11865584543903-git-send-email-yi.zhu@intel.com>
 <11865584562811-git-send-email-yi.zhu@intel.com>
 <11865584583336-git-send-email-yi.zhu@intel.com>
 <11865584603865-git-send-email-yi.zhu@intel.com>
 <11865584631842-git-send-email-yi.zhu@intel.com>
 <11865584661209-git-send-email-yi.zhu@intel.com>
 <11865584683474-git-send-email-yi.zhu@intel.com>
 <1186558470949-git-send-email-yi.zhu@intel.com>
 <11865584733882-git-send-email-yi.zhu@intel.com>
 <11865584754153-git-send-email-yi.zhu@intel.com>
 <11865584771950-git-send-email-yi.zhu@intel.com>
 <1186558479530-git-send-email-yi.zhu@intel.com>
 <11865584823402-git-send-email-yi.zhu@intel.com>
 <11865584841976-git-send-email-yi.zhu@intel.com>
 <11865584861970-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

This patch corrects missing hardware detection in iwl_isr().

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index ad7e67c..881945d 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -5282,8 +5282,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 		goto none;
 	}
 
-	if ((inta == 0xFFFFFFFF) || (inta == 0xa5a5a5a5)
-	    || (inta == 0x5a5a5a5a)) {
+	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
 		/* Hardware disappeared */
 		IWL_WARNING("HARDWARE GONE?? INTA == 0x%080x\n", inta);
 		goto none;
-- 
1.5.2
