Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55196 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757227Ab1LBRqQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 12:46:16 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Kenny Hsu <kenny.hsu@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/16] iwlwifi: add range checking in tm sram read command
Date: Fri,  2 Dec 2011 08:48:27 -0800
Message-Id: <1322844520-21149-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111202_184634_109605_F434C69F)
In-Reply-To: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kenny Hsu <kenny.hsu@intel.com>

The size of sram may alter according to ucode type.
Retrieve the maximum sram size by current ucode
type for range checking to prevent wrong data access.

Signed-off-by: Kenny Hsu <kenny.hsu@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sv-open.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index 593f42d..a8d0ef6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -680,7 +680,7 @@ static int iwl_testmode_ownership(struct ieee80211_hw *hw, struct nlattr **tb)
 static int iwl_testmode_sram(struct ieee80211_hw *hw, struct nlattr **tb)
 {
 	struct iwl_priv *priv = hw->priv;
-	u32 base, ofs, size;
+	u32 base, ofs, size, maxsize;
 
 	if (priv->testmode_sram.sram_readed)
 		return -EBUSY;
@@ -695,6 +695,27 @@ static int iwl_testmode_sram(struct ieee80211_hw *hw, struct nlattr **tb)
 		return -ENOMSG;
 	}
 	size = nla_get_u32(tb[IWL_TM_ATTR_SRAM_SIZE]);
+	switch (priv->ucode_type) {
+	case IWL_UCODE_REGULAR:
+		maxsize = trans(priv)->ucode_rt.data.len;
+		break;
+	case IWL_UCODE_INIT:
+		maxsize = trans(priv)->ucode_init.data.len;
+		break;
+	case IWL_UCODE_WOWLAN:
+		maxsize = trans(priv)->ucode_wowlan.data.len;
+		break;
+	case IWL_UCODE_NONE:
+		IWL_DEBUG_INFO(priv, "Error, uCode does not been loaded\n");
+		return -ENOSYS;
+	default:
+		IWL_DEBUG_INFO(priv, "Error, unsupported uCode type\n");
+		return -ENOSYS;
+	}
+	if ((ofs + size) > maxsize) {
+		IWL_DEBUG_INFO(priv, "Invalid offset/size: out of range\n");
+		return -EINVAL;
+	}
 	priv->testmode_sram.buff_size = (size / 4) * 4;
 	priv->testmode_sram.buff_addr =
 		kmalloc(priv->testmode_sram.buff_size, GFP_KERNEL);
-- 
1.7.0.4

