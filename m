Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:35769 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759250Ab2AFWTr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 17:19:47 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Kenny Hsu <kenny.hsu@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/7] iwlwifi: enhance testmode command sram_read
Date: Fri,  6 Jan 2012 13:16:30 -0800
Message-Id: <1325884593-31298-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120106_232018_427691_E916F754)
In-Reply-To: <1325884593-31298-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1325884593-31298-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kenny Hsu <kenny.hsu@intel.com>

This patch enables SRAM read function to support entire target memory.

Signed-off-by: Kenny Hsu <kenny.hsu@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-testmode.c |    7 +++----
 drivers/net/wireless/iwlwifi/iwl-testmode.h |    3 +++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 2fc2067..58575fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -733,7 +733,7 @@ static int iwl_testmode_ownership(struct ieee80211_hw *hw, struct nlattr **tb)
 static int iwl_testmode_sram(struct ieee80211_hw *hw, struct nlattr **tb)
 {
 	struct iwl_priv *priv = hw->priv;
-	u32 base, ofs, size, maxsize;
+	u32 ofs, size, maxsize;
 
 	if (priv->testmode_sram.sram_readed)
 		return -EBUSY;
@@ -765,7 +765,7 @@ static int iwl_testmode_sram(struct ieee80211_hw *hw, struct nlattr **tb)
 		IWL_DEBUG_INFO(priv, "Error, unsupported uCode type\n");
 		return -ENOSYS;
 	}
-	if ((ofs + size) > maxsize) {
+	if ((ofs + size) > (maxsize + SRAM_DATA_SEG_OFFSET)) {
 		IWL_DEBUG_INFO(priv, "Invalid offset/size: out of range\n");
 		return -EINVAL;
 	}
@@ -776,8 +776,7 @@ static int iwl_testmode_sram(struct ieee80211_hw *hw, struct nlattr **tb)
 		IWL_DEBUG_INFO(priv, "Error allocating memory\n");
 		return -ENOMEM;
 	}
-	base = 0x800000;
-	_iwl_read_targ_mem_words(bus(priv), base + ofs,
+	_iwl_read_targ_mem_words(bus(priv), ofs,
 					priv->testmode_sram.buff_addr,
 					priv->testmode_sram.buff_size / 4);
 	priv->testmode_sram.num_chunks =
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index 26138f1..9c6a67a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -271,4 +271,7 @@ enum iwl_tm_attr_t {
 /* Maximum data size of each dump it packet */
 #define DUMP_CHUNK_SIZE		(PAGE_SIZE - 1024)
 
+/* Address offset of data segment in SRAM */
+#define SRAM_DATA_SEG_OFFSET   0x800000
+
 #endif
-- 
1.7.0.4

