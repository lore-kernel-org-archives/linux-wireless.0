Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48527 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2FKJxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 05:53:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/13] iwlwifi: iwl_{read,write}_targ_mem_words takes dwords
Date: Mon, 11 Jun 2012 11:53:04 +0200
Message-Id: <1339408392-19425-6-git-send-email-johannes@sipsolutions.net> (sfid-20120611_115340_774060_1C4F35F2)
In-Reply-To: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
References: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Change its name to better reflect this.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.c       |   20 ++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-io.h       |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl-test.c     |    8 ++++----
 4 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index f60be39..7f49526 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -473,7 +473,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 			}
 
 			if (priv->wowlan_sram)
-				_iwl_read_targ_mem_words(
+				_iwl_read_targ_mem_dwords(
 				      priv->trans, 0x800000,
 				      priv->wowlan_sram,
 				      img->sec[IWL_UCODE_SECTION_DATA].len / 4);
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 5f2df70..66c8733 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -298,8 +298,8 @@ void iwl_clear_bits_prph(struct iwl_trans *trans, u32 reg, u32 mask)
 }
 EXPORT_SYMBOL_GPL(iwl_clear_bits_prph);
 
-void _iwl_read_targ_mem_words(struct iwl_trans *trans, u32 addr,
-			      void *buf, int words)
+void _iwl_read_targ_mem_dwords(struct iwl_trans *trans, u32 addr,
+			       void *buf, int dwords)
 {
 	unsigned long flags;
 	int offs;
@@ -308,26 +308,26 @@ void _iwl_read_targ_mem_words(struct iwl_trans *trans, u32 addr,
 	spin_lock_irqsave(&trans->reg_lock, flags);
 	if (likely(iwl_grab_nic_access(trans))) {
 		iwl_write32(trans, HBUS_TARG_MEM_RADDR, addr);
-		for (offs = 0; offs < words; offs++)
+		for (offs = 0; offs < dwords; offs++)
 			vals[offs] = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
 		iwl_release_nic_access(trans);
 	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
-EXPORT_SYMBOL_GPL(_iwl_read_targ_mem_words);
+EXPORT_SYMBOL_GPL(_iwl_read_targ_mem_dwords);
 
 u32 iwl_read_targ_mem(struct iwl_trans *trans, u32 addr)
 {
 	u32 value;
 
-	_iwl_read_targ_mem_words(trans, addr, &value, 1);
+	_iwl_read_targ_mem_dwords(trans, addr, &value, 1);
 
 	return value;
 }
 EXPORT_SYMBOL_GPL(iwl_read_targ_mem);
 
-int _iwl_write_targ_mem_words(struct iwl_trans *trans, u32 addr,
-				void *buf, int words)
+int _iwl_write_targ_mem_dwords(struct iwl_trans *trans, u32 addr,
+			       void *buf, int dwords)
 {
 	unsigned long flags;
 	int offs, result = 0;
@@ -336,7 +336,7 @@ int _iwl_write_targ_mem_words(struct iwl_trans *trans, u32 addr,
 	spin_lock_irqsave(&trans->reg_lock, flags);
 	if (likely(iwl_grab_nic_access(trans))) {
 		iwl_write32(trans, HBUS_TARG_MEM_WADDR, addr);
-		for (offs = 0; offs < words; offs++)
+		for (offs = 0; offs < dwords; offs++)
 			iwl_write32(trans, HBUS_TARG_MEM_WDAT, vals[offs]);
 		iwl_release_nic_access(trans);
 	} else
@@ -345,10 +345,10 @@ int _iwl_write_targ_mem_words(struct iwl_trans *trans, u32 addr,
 
 	return result;
 }
-EXPORT_SYMBOL_GPL(_iwl_write_targ_mem_words);
+EXPORT_SYMBOL_GPL(_iwl_write_targ_mem_dwords);
 
 int iwl_write_targ_mem(struct iwl_trans *trans, u32 addr, u32 val)
 {
-	return _iwl_write_targ_mem_words(trans, addr, &val, 1);
+	return _iwl_write_targ_mem_dwords(trans, addr, &val, 1);
 }
 EXPORT_SYMBOL_GPL(iwl_write_targ_mem);
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 45a59c9..50d3819 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -76,18 +76,18 @@ void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 reg,
 			    u32 bits, u32 mask);
 void iwl_clear_bits_prph(struct iwl_trans *trans, u32 reg, u32 mask);
 
-void _iwl_read_targ_mem_words(struct iwl_trans *trans, u32 addr,
-			      void *buf, int words);
+void _iwl_read_targ_mem_dwords(struct iwl_trans *trans, u32 addr,
+			       void *buf, int dwords);
 
 #define iwl_read_targ_mem_bytes(trans, addr, buf, bufsize)	\
 	do {							\
 		BUILD_BUG_ON((bufsize) % sizeof(u32));		\
-		_iwl_read_targ_mem_words(trans, addr, buf,	\
-					 (bufsize) / sizeof(u32));\
+		_iwl_read_targ_mem_dwords(trans, addr, buf,	\
+					  (bufsize) / sizeof(u32));\
 	} while (0)
 
-int _iwl_write_targ_mem_words(struct iwl_trans *trans, u32 addr,
-			      void *buf, int words);
+int _iwl_write_targ_mem_dwords(struct iwl_trans *trans, u32 addr,
+			       void *buf, int dwords);
 
 u32 iwl_read_targ_mem(struct iwl_trans *trans, u32 addr);
 int iwl_write_targ_mem(struct iwl_trans *trans, u32 addr, u32 val);
diff --git a/drivers/net/wireless/iwlwifi/iwl-test.c b/drivers/net/wireless/iwlwifi/iwl-test.c
index 7a264ae..81e8c71 100644
--- a/drivers/net/wireless/iwlwifi/iwl-test.c
+++ b/drivers/net/wireless/iwlwifi/iwl-test.c
@@ -476,9 +476,9 @@ static int iwl_test_indirect_read(struct iwl_test *tst, u32 addr, u32 size)
 			iwl_release_nic_access(trans);
 			spin_unlock_irqrestore(&trans->reg_lock, flags);
 	} else { /* target memory (SRAM) */
-		_iwl_read_targ_mem_words(trans, addr,
-					 tst->mem.addr,
-					 tst->mem.size / 4);
+		_iwl_read_targ_mem_dwords(trans, addr,
+					  tst->mem.addr,
+					  tst->mem.size / 4);
 	}
 
 	tst->mem.nchunks =
@@ -522,7 +522,7 @@ static int iwl_test_indirect_write(struct iwl_test *tst, u32 addr,
 						       *(u32 *)(buf+i));
 			}
 	} else if (iwl_test_valid_hw_addr(tst, addr)) {
-		_iwl_write_targ_mem_words(trans, addr, buf, size/4);
+		_iwl_write_targ_mem_dwords(trans, addr, buf, size / 4);
 	} else {
 		return -EINVAL;
 	}
-- 
1.7.10

