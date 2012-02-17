Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64433 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab2BQUXy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:54 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Amit Beka <amit.beka@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 17/26] iwlwifi: fixes to testmode indirect access
Date: Fri, 17 Feb 2012 11:13:45 -0800
Message-Id: <1329506034-1394-18-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212408_179375_E6311DA3)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amit Beka <amit.beka@intel.com>

Fixed casting of buffer addressing, and added size to
the read method, like in __iwl_read_prph.

Signed-off-by: Amit Beka <amit.beka@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-testmode.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 5f00a37..ba5c63a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -799,9 +799,10 @@ static int iwl_testmode_indirect_read(struct iwl_priv *priv, u32 addr, u32 size)
 		addr < IWL_TM_ABS_PRPH_START + PRPH_END) {
 			spin_lock_irqsave(&trans->reg_lock, flags);
 			iwl_grab_nic_access(trans);
-			iwl_write32(trans, HBUS_TARG_PRPH_RADDR, addr);
+			iwl_write32(trans, HBUS_TARG_PRPH_RADDR,
+				addr | (3 << 24));
 			for (i = 0; i < size; i += 4)
-				priv->testmode_mem.buff_addr[i] =
+				*(u32 *)(priv->testmode_mem.buff_addr + i) =
 					iwl_read32(trans, HBUS_TARG_PRPH_RDAT);
 			iwl_release_nic_access(trans);
 			spin_unlock_irqrestore(&trans->reg_lock, flags);
@@ -833,7 +834,8 @@ static int iwl_testmode_indirect_write(struct iwl_priv *priv, u32 addr,
 				spin_lock_irqsave(&trans->reg_lock, flags);
 				iwl_grab_nic_access(trans);
 				iwl_write32(trans, HBUS_TARG_PRPH_WADDR,
-					    (addr & 0x0000FFFF) | (size << 24));
+					    (addr & 0x0000FFFF) |
+					    ((size - 1) << 24));
 				iwl_write32(trans, HBUS_TARG_PRPH_WDAT, val);
 				iwl_release_nic_access(trans);
 				/* needed after consecutive writes w/o read */
@@ -844,7 +846,7 @@ static int iwl_testmode_indirect_write(struct iwl_priv *priv, u32 addr,
 					return -EINVAL;
 				for (i = 0; i < size; i += 4)
 					iwl_write_prph(trans, addr+i,
-						*(u32 *)buf+i);
+						*(u32 *)(buf+i));
 			}
 	} else if (iwlagn_hw_valid_rtc_data_addr(addr) ||
 		(IWLAGN_RTC_INST_LOWER_BOUND <= addr &&
-- 
1.7.0.4

