Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab2BFQJd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 11:09:33 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC 2/4] iwlwifi: always check if got h/w access before write
Date: Mon,  6 Feb 2012 17:09:22 +0100
Message-Id: <1328544564-8696-2-git-send-email-sgruszka@redhat.com> (sfid-20120206_170937_651550_087669B3)
In-Reply-To: <1328544564-8696-1-git-send-email-sgruszka@redhat.com>
References: <1328544564-8696-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before we write to the device registers always check if
iwl_grap_nic_access() was successful.

On the way change return type of grab_nic_access() to bool, and add
likely()/unlikely() statement.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.c            |   52 +++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-io.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    4 +-
 6 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index 56c6def..e9a0e93 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -188,7 +188,7 @@ static void iwl_tt_check_exit_ct_kill(unsigned long data)
 		}
 		iwl_read32(bus(priv), CSR_UCODE_DRV_GP1);
 		spin_lock_irqsave(&bus(priv)->reg_lock, flags);
-		if (!iwl_grab_nic_access(bus(priv)))
+		if (likely(iwl_grab_nic_access(bus(priv))))
 			iwl_release_nic_access(bus(priv));
 		spin_unlock_irqrestore(&bus(priv)->reg_lock, flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 90315c6..2642bf9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -329,7 +329,7 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 
 	/* Make sure device is powered up for SRAM reads */
 	spin_lock_irqsave(&bus(priv)->reg_lock, reg_flags);
-	if (iwl_grab_nic_access(bus(priv))) {
+	if (unlikely(!iwl_grab_nic_access(bus(priv)))) {
 		spin_unlock_irqrestore(&bus(priv)->reg_lock, reg_flags);
 		return;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index ce6d9c1..b5d0bcb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -117,16 +117,17 @@ int iwl_grab_nic_access_silent(struct iwl_bus *bus)
 	return 0;
 }
 
-int iwl_grab_nic_access(struct iwl_bus *bus)
+bool iwl_grab_nic_access(struct iwl_bus *bus)
 {
 	int ret = iwl_grab_nic_access_silent(bus);
 	if (unlikely(ret)) {
 		u32 val = iwl_read32(bus, CSR_GP_CNTRL);
 		WARN_ONCE(1, "Timeout waiting for ucode processor access "
 			     "(CSR_GP_CNTRL 0x%08x)\n", val);
+		return false;
 	}
 
-	return ret;
+	return true;
 }
 
 void iwl_release_nic_access(struct iwl_bus *bus)
@@ -155,7 +156,7 @@ void iwl_write_direct32(struct iwl_bus *bus, u32 reg, u32 value)
 	unsigned long flags;
 
 	spin_lock_irqsave(&bus->reg_lock, flags);
-	if (!iwl_grab_nic_access(bus)) {
+	if (likely(iwl_grab_nic_access(bus))) {
 		iwl_write32(bus, reg, value);
 		iwl_release_nic_access(bus);
 	}
@@ -210,7 +211,7 @@ void iwl_write_prph(struct iwl_bus *bus, u32 addr, u32 val)
 	unsigned long flags;
 
 	spin_lock_irqsave(&bus->reg_lock, flags);
-	if (!iwl_grab_nic_access(bus)) {
+	if (likely(iwl_grab_nic_access(bus))) {
 		__iwl_write_prph(bus, addr, val);
 		iwl_release_nic_access(bus);
 	}
@@ -222,9 +223,10 @@ void iwl_set_bits_prph(struct iwl_bus *bus, u32 reg, u32 mask)
 	unsigned long flags;
 
 	spin_lock_irqsave(&bus->reg_lock, flags);
-	iwl_grab_nic_access(bus);
-	__iwl_write_prph(bus, reg, __iwl_read_prph(bus, reg) | mask);
-	iwl_release_nic_access(bus);
+	if (likely(iwl_grab_nic_access(bus))) {
+		__iwl_write_prph(bus, reg, __iwl_read_prph(bus, reg) | mask);
+		iwl_release_nic_access(bus);
+	}
 	spin_unlock_irqrestore(&bus->reg_lock, flags);
 }
 
@@ -234,10 +236,11 @@ void iwl_set_bits_mask_prph(struct iwl_bus *bus, u32 reg,
 	unsigned long flags;
 
 	spin_lock_irqsave(&bus->reg_lock, flags);
-	iwl_grab_nic_access(bus);
-	__iwl_write_prph(bus, reg,
-			 (__iwl_read_prph(bus, reg) & mask) | bits);
-	iwl_release_nic_access(bus);
+	if (likely(iwl_grab_nic_access(bus))) {
+		__iwl_write_prph(bus, reg,
+				 (__iwl_read_prph(bus, reg) & mask) | bits);
+		iwl_release_nic_access(bus);
+	}
 	spin_unlock_irqrestore(&bus->reg_lock, flags);
 }
 
@@ -247,10 +250,11 @@ void iwl_clear_bits_prph(struct iwl_bus *bus, u32 reg, u32 mask)
 	u32 val;
 
 	spin_lock_irqsave(&bus->reg_lock, flags);
-	iwl_grab_nic_access(bus);
-	val = __iwl_read_prph(bus, reg);
-	__iwl_write_prph(bus, reg, (val & ~mask));
-	iwl_release_nic_access(bus);
+	if (likely(iwl_grab_nic_access(bus))) {
+		val = __iwl_read_prph(bus, reg);
+		__iwl_write_prph(bus, reg, (val & ~mask));
+		iwl_release_nic_access(bus);
+	}
 	spin_unlock_irqrestore(&bus->reg_lock, flags);
 }
 
@@ -262,15 +266,13 @@ void _iwl_read_targ_mem_words(struct iwl_bus *bus, u32 addr,
 	u32 *vals = buf;
 
 	spin_lock_irqsave(&bus->reg_lock, flags);
-	iwl_grab_nic_access(bus);
-
-	iwl_write32(bus, HBUS_TARG_MEM_RADDR, addr);
-	rmb();
-
-	for (offs = 0; offs < words; offs++)
-		vals[offs] = iwl_read32(bus, HBUS_TARG_MEM_RDAT);
-
-	iwl_release_nic_access(bus);
+	if (likely(iwl_grab_nic_access(bus))) {
+		iwl_write32(bus, HBUS_TARG_MEM_RADDR, addr);
+		rmb();
+		for (offs = 0; offs < words; offs++)
+			vals[offs] = iwl_read32(bus, HBUS_TARG_MEM_RDAT);
+		iwl_release_nic_access(bus);
+	}
 	spin_unlock_irqrestore(&bus->reg_lock, flags);
 }
 
@@ -291,7 +293,7 @@ int _iwl_write_targ_mem_words(struct iwl_bus *bus, u32 addr,
 	u32 *vals = buf;
 
 	spin_lock_irqsave(&bus->reg_lock, flags);
-	if (!iwl_grab_nic_access(bus)) {
+	if (likely(iwl_grab_nic_access(bus))) {
 		iwl_write32(bus, HBUS_TARG_MEM_WADDR, addr);
 		wmb();
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 427d065..f4763d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -61,7 +61,7 @@ int iwl_poll_direct_bit(struct iwl_bus *bus, u32 addr, u32 mask,
 			int timeout);
 
 int iwl_grab_nic_access_silent(struct iwl_bus *bus);
-int iwl_grab_nic_access(struct iwl_bus *bus);
+bool iwl_grab_nic_access(struct iwl_bus *bus);
 void iwl_release_nic_access(struct iwl_bus *bus);
 
 u32 iwl_read_direct32(struct iwl_bus *bus, u32 reg);
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 965d047..218071a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -443,7 +443,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	if (iwlagn_hw_valid_rtc_data_addr(base)) {
 		spin_lock_irqsave(&bus(priv)->reg_lock, flags);
 		ret = iwl_grab_nic_access_silent(bus(priv));
-		if (ret == 0) {
+		if (likely(ret == 0)) {
 			iwl_write32(bus(priv), HBUS_TARG_MEM_RADDR, base);
 			status = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
 			iwl_release_nic_access(bus(priv));
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 2900db9..7b7899d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -742,7 +742,8 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 
 	/* Make sure device is powered up for SRAM reads */
 	spin_lock_irqsave(&bus(trans)->reg_lock, reg_flags);
-	iwl_grab_nic_access(bus(trans));
+	if (unlikely(!iwl_grab_nic_access(bus(trans))))
+		goto out_unlock;
 
 	/* Set starting address; reads will auto-increment */
 	iwl_write32(bus(trans), HBUS_TARG_MEM_RADDR, ptr);
@@ -782,6 +783,7 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 
 	/* Allow device to power down */
 	iwl_release_nic_access(bus(trans));
+out_unlock:
 	spin_unlock_irqrestore(&bus(trans)->reg_lock, reg_flags);
 	return pos;
 }
-- 
1.7.1

