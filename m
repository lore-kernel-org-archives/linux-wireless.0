Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:21042 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759263Ab2AFWTr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 17:19:47 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Kenny Hsu <kenny.hsu@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 5/7] iwlwifi: update error dump in testmode command sram_read
Date: Fri,  6 Jan 2012 13:16:31 -0800
Message-Id: <1325884593-31298-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120106_232015_321053_999229AA)
In-Reply-To: <1325884593-31298-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1325884593-31298-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kenny Hsu <kenny.hsu@intel.com>

The error message will be show up by using IWL_ERR
insteads of IWl_DEBUG_INFO.

Signed-off-by: Kenny Hsu <kenny.hsu@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-testmode.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 58575fd..b56cd90 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -759,21 +759,21 @@ static int iwl_testmode_sram(struct ieee80211_hw *hw, struct nlattr **tb)
 		maxsize = trans(priv)->ucode_wowlan.data.len;
 		break;
 	case IWL_UCODE_NONE:
-		IWL_DEBUG_INFO(priv, "Error, uCode does not been loaded\n");
+		IWL_ERR(priv, "Error, uCode does not been loaded\n");
 		return -ENOSYS;
 	default:
-		IWL_DEBUG_INFO(priv, "Error, unsupported uCode type\n");
+		IWL_ERR(priv, "Error, unsupported uCode type\n");
 		return -ENOSYS;
 	}
 	if ((ofs + size) > (maxsize + SRAM_DATA_SEG_OFFSET)) {
-		IWL_DEBUG_INFO(priv, "Invalid offset/size: out of range\n");
+		IWL_ERR(priv, "Invalid offset/size: out of range\n");
 		return -EINVAL;
 	}
 	priv->testmode_sram.buff_size = (size / 4) * 4;
 	priv->testmode_sram.buff_addr =
 		kmalloc(priv->testmode_sram.buff_size, GFP_KERNEL);
 	if (priv->testmode_sram.buff_addr == NULL) {
-		IWL_DEBUG_INFO(priv, "Error allocating memory\n");
+		IWL_ERR(priv, "Error allocating memory\n");
 		return -ENOMEM;
 	}
 	_iwl_read_targ_mem_words(bus(priv), ofs,
-- 
1.7.0.4

