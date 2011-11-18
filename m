Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab1KRIVP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:15 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8LEvi026051
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:15 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 12/77] iwlegacy: mark il_{grab,release}_nic_access as unlocked
Date: Fri, 18 Nov 2011 09:21:34 +0100
Message-Id: <1321604559-10707-12-git-send-email-sgruszka@redhat.com> (sfid-20111118_092121_486942_908EA938)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-io.h       |   42 ++++++++++++-------------
 drivers/net/wireless/iwlegacy/iwl4965-base.c |    4 +-
 2 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-io.h b/drivers/net/wireless/iwlegacy/iwl-io.h
index 7ad262e..c2e32ed 100644
--- a/drivers/net/wireless/iwlegacy/iwl-io.h
+++ b/drivers/net/wireless/iwlegacy/iwl-io.h
@@ -137,14 +137,12 @@ static inline int _il_grab_nic_access(struct il_priv *il)
 
 	return 0;
 }
-#define il_grab_nic_access(il) _il_grab_nic_access(il)
 
 static inline void _il_release_nic_access(struct il_priv *il)
 {
 	_il_clear_bit(il, CSR_GP_CNTRL,
 			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 }
-#define il_release_nic_access(il) _il_release_nic_access(il)
 
 static inline u32 _il_read_direct32(struct il_priv *il, u32 reg)
 {
@@ -157,9 +155,9 @@ static inline u32 il_read_direct32(struct il_priv *il, u32 reg)
 	unsigned long reg_flags;
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	il_grab_nic_access(il);
+	_il_grab_nic_access(il);
 	value = _il_read_direct32(il, reg);
-	il_release_nic_access(il);
+	_il_release_nic_access(il);
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 	return value;
 
@@ -176,9 +174,9 @@ il_write_direct32(struct il_priv *il, u32 reg, u32 value)
 	unsigned long reg_flags;
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	if (!il_grab_nic_access(il)) {
+	if (!_il_grab_nic_access(il)) {
 		_il_write_direct32(il, reg, value);
-		il_release_nic_access(il);
+		_il_release_nic_access(il);
 	}
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 }
@@ -222,9 +220,9 @@ static inline u32 il_read_prph(struct il_priv *il, u32 reg)
 	u32 val;
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	il_grab_nic_access(il);
+	_il_grab_nic_access(il);
 	val = _il_read_prph(il, reg);
-	il_release_nic_access(il);
+	_il_release_nic_access(il);
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 	return val;
 }
@@ -244,9 +242,9 @@ il_write_prph(struct il_priv *il, u32 addr, u32 val)
 	unsigned long reg_flags;
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	if (!il_grab_nic_access(il)) {
+	if (!_il_grab_nic_access(il)) {
 		_il_write_prph(il, addr, val);
-		il_release_nic_access(il);
+		_il_release_nic_access(il);
 	}
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 }
@@ -260,9 +258,9 @@ il_set_bits_prph(struct il_priv *il, u32 reg, u32 mask)
 	unsigned long reg_flags;
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	il_grab_nic_access(il);
+	_il_grab_nic_access(il);
 	_il_set_bits_prph(il, reg, mask);
-	il_release_nic_access(il);
+	_il_release_nic_access(il);
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 }
 
@@ -276,9 +274,9 @@ static inline void il_set_bits_mask_prph(struct il_priv *il, u32 reg,
 	unsigned long reg_flags;
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	il_grab_nic_access(il);
+	_il_grab_nic_access(il);
 	_il_set_bits_mask_prph(il, reg, bits, mask);
-	il_release_nic_access(il);
+	_il_release_nic_access(il);
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 }
 
@@ -289,10 +287,10 @@ static inline void il_clear_bits_prph(struct il_priv
 	u32 val;
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	il_grab_nic_access(il);
+	_il_grab_nic_access(il);
 	val = _il_read_prph(il, reg);
 	_il_write_prph(il, reg, (val & ~mask));
-	il_release_nic_access(il);
+	_il_release_nic_access(il);
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 }
 
@@ -302,13 +300,13 @@ static inline u32 il_read_targ_mem(struct il_priv *il, u32 addr)
 	u32 value;
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	il_grab_nic_access(il);
+	_il_grab_nic_access(il);
 
 	_il_write_direct32(il, HBUS_TARG_MEM_RADDR, addr);
 	rmb();
 	value = _il_read_direct32(il, HBUS_TARG_MEM_RDAT);
 
-	il_release_nic_access(il);
+	_il_release_nic_access(il);
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 	return value;
 }
@@ -319,11 +317,11 @@ il_write_targ_mem(struct il_priv *il, u32 addr, u32 val)
 	unsigned long reg_flags;
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	if (!il_grab_nic_access(il)) {
+	if (!_il_grab_nic_access(il)) {
 		_il_write_direct32(il, HBUS_TARG_MEM_WADDR, addr);
 		wmb();
 		_il_write_direct32(il, HBUS_TARG_MEM_WDAT, val);
-		il_release_nic_access(il);
+		_il_release_nic_access(il);
 	}
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 }
@@ -335,14 +333,14 @@ il_write_targ_mem_buf(struct il_priv *il, u32 addr,
 	unsigned long reg_flags;
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	if (!il_grab_nic_access(il)) {
+	if (!_il_grab_nic_access(il)) {
 		_il_write_direct32(il, HBUS_TARG_MEM_WADDR, addr);
 		wmb();
 		for (; 0 < len; len -= sizeof(u32), values++)
 			_il_write_direct32(il,
 					HBUS_TARG_MEM_WDAT, *values);
 
-		il_release_nic_access(il);
+		_il_release_nic_access(il);
 	}
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 }
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index f3ec8bb..f4eb037 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -522,8 +522,8 @@ static void il4965_perform_ct_kill_task(struct il_priv *il)
 	_il_rd(il, CSR_UCODE_DRV_GP1);
 
 	spin_lock_irqsave(&il->reg_lock, flags);
-	if (!il_grab_nic_access(il))
-		il_release_nic_access(il);
+	if (!_il_grab_nic_access(il))
+		_il_release_nic_access(il);
 	spin_unlock_irqrestore(&il->reg_lock, flags);
 }
 
-- 
1.7.1

