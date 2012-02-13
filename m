Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab2BMKXx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:23:53 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 02/24] iwlegacy: always check if got h/w access before write
Date: Mon, 13 Feb 2012 11:23:09 +0100
Message-Id: <1329128611-6815-3-git-send-email-sgruszka@redhat.com> (sfid-20120213_112357_620180_1874B50C)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before we write to the device register always check if
_il_grap_nic_access() was successful.

Change type return type _il_grap_nic_access() to bool, and
add likely()/unlikely() statements.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |    2 +-
 drivers/net/wireless/iwlegacy/common.c   |   10 +++++-----
 drivers/net/wireless/iwlegacy/common.h   |   27 +++++++++++++++------------
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 235812a..90c9bfb 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -3778,7 +3778,7 @@ il4965_perform_ct_kill_task(struct il_priv *il)
 	_il_rd(il, CSR_UCODE_DRV_GP1);
 
 	spin_lock_irqsave(&il->reg_lock, flags);
-	if (!_il_grab_nic_access(il))
+	if (likely(_il_grab_nic_access(il)))
 		_il_release_nic_access(il);
 	spin_unlock_irqrestore(&il->reg_lock, flags);
 }
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 3900967..6dbd11f 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -81,7 +81,7 @@ il_clear_bit(struct il_priv *p, u32 r, u32 m)
 }
 EXPORT_SYMBOL(il_clear_bit);
 
-int
+bool
 _il_grab_nic_access(struct il_priv *il)
 {
 	int ret;
@@ -116,10 +116,10 @@ _il_grab_nic_access(struct il_priv *il)
 		WARN_ONCE(1, "Timeout waiting for ucode processor access "
 			     "(CSR_GP_CNTRL 0x%08x)\n", val);
 		_il_wr(il, CSR_RESET, CSR_RESET_REG_FLAG_FORCE_NMI);
-		return -EIO;
+		return false;
 	}
 
-	return 0;
+	return true;
 }
 EXPORT_SYMBOL_GPL(_il_grab_nic_access);
 
@@ -161,7 +161,7 @@ il_wr_prph(struct il_priv *il, u32 addr, u32 val)
 	unsigned long reg_flags;
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	if (!_il_grab_nic_access(il)) {
+	if (likely(_il_grab_nic_access(il))) {
 		_il_wr_prph(il, addr, val);
 		_il_release_nic_access(il);
 	}
@@ -194,7 +194,7 @@ il_write_targ_mem(struct il_priv *il, u32 addr, u32 val)
 	unsigned long reg_flags;
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	if (!_il_grab_nic_access(il)) {
+	if (likely(_il_grab_nic_access(il))) {
 		_il_wr(il, HBUS_TARG_MEM_WADDR, addr);
 		wmb();
 		_il_wr(il, HBUS_TARG_MEM_WDAT, val);
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 7080956..1dfaa58 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -2103,7 +2103,7 @@ irqreturn_t il_isr(int irq, void *data);
 
 extern void il_set_bit(struct il_priv *p, u32 r, u32 m);
 extern void il_clear_bit(struct il_priv *p, u32 r, u32 m);
-extern int _il_grab_nic_access(struct il_priv *il);
+extern bool _il_grab_nic_access(struct il_priv *il);
 extern int _il_poll_bit(struct il_priv *il, u32 addr, u32 bits, u32 mask, int timeout);
 extern int il_poll_bit(struct il_priv *il, u32 addr, u32 mask, int timeout);
 extern u32 il_rd_prph(struct il_priv *il, u32 reg);
@@ -2168,7 +2168,7 @@ il_wr(struct il_priv *il, u32 reg, u32 value)
 	unsigned long reg_flags;
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	if (!_il_grab_nic_access(il)) {
+	if (likely(_il_grab_nic_access(il))) {
 		_il_wr(il, reg, value);
 		_il_release_nic_access(il);
 	}
@@ -2197,9 +2197,10 @@ il_set_bits_prph(struct il_priv *il, u32 reg, u32 mask)
 	unsigned long reg_flags;
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	_il_grab_nic_access(il);
-	_il_wr_prph(il, reg, (_il_rd_prph(il, reg) | mask));
-	_il_release_nic_access(il);
+	if (likely(_il_grab_nic_access(il))) {
+		_il_wr_prph(il, reg, (_il_rd_prph(il, reg) | mask));
+		_il_release_nic_access(il);
+	}
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 }
 
@@ -2209,9 +2210,10 @@ il_set_bits_mask_prph(struct il_priv *il, u32 reg, u32 bits, u32 mask)
 	unsigned long reg_flags;
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	_il_grab_nic_access(il);
-	_il_wr_prph(il, reg, ((_il_rd_prph(il, reg) & mask) | bits));
-	_il_release_nic_access(il);
+	if (likely(_il_grab_nic_access(il))) {
+		_il_wr_prph(il, reg, ((_il_rd_prph(il, reg) & mask) | bits));
+		_il_release_nic_access(il);
+	}
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 }
 
@@ -2222,10 +2224,11 @@ il_clear_bits_prph(struct il_priv *il, u32 reg, u32 mask)
 	u32 val;
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	_il_grab_nic_access(il);
-	val = _il_rd_prph(il, reg);
-	_il_wr_prph(il, reg, (val & ~mask));
-	_il_release_nic_access(il);
+	if (likely(_il_grab_nic_access(il))) {
+		val = _il_rd_prph(il, reg);
+		_il_wr_prph(il, reg, (val & ~mask));
+		_il_release_nic_access(il);
+	}
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 }
 
-- 
1.7.1

