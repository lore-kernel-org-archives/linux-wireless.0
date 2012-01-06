Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:21042 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab2AFWTr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 17:19:47 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Kenny Hsu <kenny.hsu@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/7] iwlwifi: update testmode command of direct register access
Date: Fri,  6 Jan 2012 13:16:29 -0800
Message-Id: <1325884593-31298-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120106_232008_630347_CDFF149F)
In-Reply-To: <1325884593-31298-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1325884593-31298-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kenny Hsu <kenny.hsu@intel.com>

In order to make sure the testcommand function of direct register
access can be performed even NIC is asleep, replace corresponding
handler iwl_read32 and iwl_write32 by using iwl_direct_read32 and
iwl_direct_write32.

Signed-off-by: Kenny Hsu <kenny.hsu@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-testmode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 4a5cddd..2fc2067 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -299,7 +299,7 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
 	case IWL_TM_CMD_APP2DEV_DIRECT_REG_READ32:
-		val32 = iwl_read32(bus(priv), ofs);
+		val32 = iwl_read_direct32(bus(priv), ofs);
 		IWL_INFO(priv, "32bit value to read 0x%x\n", val32);
 
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
@@ -321,7 +321,7 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 		} else {
 			val32 = nla_get_u32(tb[IWL_TM_ATTR_REG_VALUE32]);
 			IWL_INFO(priv, "32bit value to write 0x%x\n", val32);
-			iwl_write32(bus(priv), ofs, val32);
+			iwl_write_direct32(bus(priv), ofs, val32);
 		}
 		break;
 	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE8:
-- 
1.7.0.4

