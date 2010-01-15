Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62939 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758541Ab0AOVnv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 16:43:51 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/9] iwlwifi: software w/a for h/w bug cause Rx bit get clear
Date: Fri, 15 Jan 2010 13:43:38 -0800
Message-Id: <1263591821-14867-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1263591821-14867-1-git-send-email-reinette.chatre@intel.com>
References: <1263591821-14867-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

This is a w/a for a hardware bug. the h/w bug may cause the Rx bit
(bit 15 before shifting it to 31) to clear when using interrupt coalescing.

This does not mean frames are lost - their processing is just delayed until
next interrupt arrives.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f94a323..2323073 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1803,6 +1803,16 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	if (val == 0xffffffff)
 		val = 0;
 
+	/*
+	 * this is a w/a for a h/w bug. the h/w bug may cause the Rx bit
+	 * (bit 15 before shifting it to 31) to clear when using interrupt
+	 * coalescing. fortunately, bits 18 and 19 stay set when this happens
+	 * so we use them to decide on the real state of the Rx bit.
+	 * In order words, bit 15 is set if bit 18 or bit 19 are set.
+	 */
+	if (val & 0xC0000)
+		val |= 0x8000;
+
 	inta = (0xff & val) | ((0xff00 & val) << 16);
 	IWL_DEBUG_ISR(priv, "ISR inta 0x%08x, enabled 0x%08x ict 0x%08x\n",
 			inta, inta_mask, val);
-- 
1.6.3.3

