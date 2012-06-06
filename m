Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab2FFNXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 22/29] iwlwifi: add iwl_set_bits_mask
Date: Wed,  6 Jun 2012 15:22:03 +0200
Message-Id: <1338988930-11561-22-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152336_240767_F14FDC4D)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In a few cases we need to set a value in
a certain mask inside a register, add the
function iwl_set_bits_mask() to make such
code easy.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-io.c |   18 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-io.h |    2 ++
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index ee93274..5f2df70 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -65,6 +65,24 @@ void iwl_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask)
 }
 EXPORT_SYMBOL_GPL(iwl_clear_bit);
 
+void iwl_set_bits_mask(struct iwl_trans *trans, u32 reg, u32 mask, u32 value)
+{
+	unsigned long flags;
+	u32 v;
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	WARN_ON_ONCE(value & ~mask);
+#endif
+
+	spin_lock_irqsave(&trans->reg_lock, flags);
+	v = iwl_read32(trans, reg);
+	v &= ~mask;
+	v |= value;
+	iwl_write32(trans, reg, v);
+	spin_unlock_irqrestore(&trans->reg_lock, flags);
+}
+EXPORT_SYMBOL_GPL(iwl_set_bits_mask);
+
 int iwl_poll_bit(struct iwl_trans *trans, u32 addr,
 		 u32 bits, u32 mask, int timeout)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index abb3250..4a9a45f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -54,6 +54,8 @@ static inline u32 iwl_read32(struct iwl_trans *trans, u32 ofs)
 void iwl_set_bit(struct iwl_trans *trans, u32 reg, u32 mask);
 void iwl_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask);
 
+void iwl_set_bits_mask(struct iwl_trans *trans, u32 reg, u32 mask, u32 value);
+
 int iwl_poll_bit(struct iwl_trans *trans, u32 addr,
 		 u32 bits, u32 mask, int timeout);
 int iwl_poll_direct_bit(struct iwl_trans *trans, u32 addr, u32 mask,
-- 
1.7.10

