Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab1KRIVR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:17 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8LGpH026063
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:16 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 13/77] iwlegacy: remove _il_{read,write}_direct32
Date: Fri, 18 Nov 2011 09:21:35 +0100
Message-Id: <1321604559-10707-13-git-send-email-sgruszka@redhat.com> (sfid-20111118_092125_078246_63730154)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use _il_{rd,wr} instead of another name of these operations.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-4965-ucode.c |    4 +-
 drivers/net/wireless/iwlegacy/iwl-eeprom.c     |    2 +-
 drivers/net/wireless/iwlegacy/iwl-io.h         |   34 ++++++++---------------
 drivers/net/wireless/iwlegacy/iwl3945-base.c   |    4 +-
 4 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c b/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
index 3fa939e..4f0e6fe 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
@@ -63,7 +63,7 @@ il4965_verify_inst_sparse(struct il_priv *il, __le32 *image, u32 len)
 		 * if IL_DL_IO is set */
 		il_write_direct32(il, HBUS_TARG_MEM_RADDR,
 			i + IWL4965_RTC_INST_LOWER_BOUND);
-		val = _il_read_direct32(il, HBUS_TARG_MEM_RDAT);
+		val = _il_rd(il, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 			ret = -EIO;
 			errcnt++;
@@ -97,7 +97,7 @@ static int il4965_verify_inst_full(struct il_priv *il, __le32 *image,
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IL_DL_IO is set */
-		val = _il_read_direct32(il, HBUS_TARG_MEM_RDAT);
+		val = _il_rd(il, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 			IL_ERR("uCode INST section is invalid at "
 				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
diff --git a/drivers/net/wireless/iwlegacy/iwl-eeprom.c b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
index ba2be7b..5786abd 100644
--- a/drivers/net/wireless/iwlegacy/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
@@ -235,7 +235,7 @@ int il_eeprom_init(struct il_priv *il)
 							addr);
 			goto done;
 		}
-		r = _il_read_direct32(il, CSR_EEPROM_REG);
+		r = _il_rd(il, CSR_EEPROM_REG);
 		e[addr / 2] = cpu_to_le16(r >> 16);
 	}
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-io.h b/drivers/net/wireless/iwlegacy/iwl-io.h
index c2e32ed..ecf799d 100644
--- a/drivers/net/wireless/iwlegacy/iwl-io.h
+++ b/drivers/net/wireless/iwlegacy/iwl-io.h
@@ -144,11 +144,6 @@ static inline void _il_release_nic_access(struct il_priv *il)
 			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 }
 
-static inline u32 _il_read_direct32(struct il_priv *il, u32 reg)
-{
-	return _il_rd(il, reg);
-}
-
 static inline u32 il_read_direct32(struct il_priv *il, u32 reg)
 {
 	u32 value;
@@ -156,18 +151,13 @@ static inline u32 il_read_direct32(struct il_priv *il, u32 reg)
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
 	_il_grab_nic_access(il);
-	value = _il_read_direct32(il, reg);
+	value = _il_rd(il, reg);
 	_il_release_nic_access(il);
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 	return value;
 
 }
 
-static inline void _il_write_direct32(struct il_priv *il,
-					 u32 reg, u32 value)
-{
-	_il_wr(il, reg, value);
-}
 static inline void
 il_write_direct32(struct il_priv *il, u32 reg, u32 value)
 {
@@ -175,7 +165,7 @@ il_write_direct32(struct il_priv *il, u32 reg, u32 value)
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
 	if (!_il_grab_nic_access(il)) {
-		_il_write_direct32(il, reg, value);
+		_il_wr(il, reg, value);
 		_il_release_nic_access(il);
 	}
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
@@ -210,9 +200,9 @@ static inline int _il_poll_direct_bit(struct il_priv *il, u32 addr,
 
 static inline u32 _il_read_prph(struct il_priv *il, u32 reg)
 {
-	_il_write_direct32(il, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
+	_il_wr(il, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
 	rmb();
-	return _il_read_direct32(il, HBUS_TARG_PRPH_RDAT);
+	return _il_rd(il, HBUS_TARG_PRPH_RDAT);
 }
 static inline u32 il_read_prph(struct il_priv *il, u32 reg)
 {
@@ -230,10 +220,10 @@ static inline u32 il_read_prph(struct il_priv *il, u32 reg)
 static inline void _il_write_prph(struct il_priv *il,
 					     u32 addr, u32 val)
 {
-	_il_write_direct32(il, HBUS_TARG_PRPH_WADDR,
+	_il_wr(il, HBUS_TARG_PRPH_WADDR,
 			      ((addr & 0x0000FFFF) | (3 << 24)));
 	wmb();
-	_il_write_direct32(il, HBUS_TARG_PRPH_WDAT, val);
+	_il_wr(il, HBUS_TARG_PRPH_WDAT, val);
 }
 
 static inline void
@@ -302,9 +292,9 @@ static inline u32 il_read_targ_mem(struct il_priv *il, u32 addr)
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
 	_il_grab_nic_access(il);
 
-	_il_write_direct32(il, HBUS_TARG_MEM_RADDR, addr);
+	_il_wr(il, HBUS_TARG_MEM_RADDR, addr);
 	rmb();
-	value = _il_read_direct32(il, HBUS_TARG_MEM_RDAT);
+	value = _il_rd(il, HBUS_TARG_MEM_RDAT);
 
 	_il_release_nic_access(il);
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
@@ -318,9 +308,9 @@ il_write_targ_mem(struct il_priv *il, u32 addr, u32 val)
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
 	if (!_il_grab_nic_access(il)) {
-		_il_write_direct32(il, HBUS_TARG_MEM_WADDR, addr);
+		_il_wr(il, HBUS_TARG_MEM_WADDR, addr);
 		wmb();
-		_il_write_direct32(il, HBUS_TARG_MEM_WDAT, val);
+		_il_wr(il, HBUS_TARG_MEM_WDAT, val);
 		_il_release_nic_access(il);
 	}
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
@@ -334,10 +324,10 @@ il_write_targ_mem_buf(struct il_priv *il, u32 addr,
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
 	if (!_il_grab_nic_access(il)) {
-		_il_write_direct32(il, HBUS_TARG_MEM_WADDR, addr);
+		_il_wr(il, HBUS_TARG_MEM_WADDR, addr);
 		wmb();
 		for (; 0 < len; len -= sizeof(u32), values++)
-			_il_write_direct32(il,
+			_il_wr(il,
 					HBUS_TARG_MEM_WDAT, *values);
 
 		_il_release_nic_access(il);
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index def3140..d45e9f5 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -1706,7 +1706,7 @@ static int il3945_verify_inst_full(struct il_priv *il, __le32 *image, u32 len)
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IL_DL_IO is set */
-		val = _il_read_direct32(il, HBUS_TARG_MEM_RDAT);
+		val = _il_rd(il, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 			IL_ERR("uCode INST section is invalid at "
 				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
@@ -1747,7 +1747,7 @@ static int il3945_verify_inst_sparse(struct il_priv *il, __le32 *image, u32 len)
 		 * if IL_DL_IO is set */
 		il_write_direct32(il, HBUS_TARG_MEM_RADDR,
 			i + IWL39_RTC_INST_LOWER_BOUND);
-		val = _il_read_direct32(il, HBUS_TARG_MEM_RDAT);
+		val = _il_rd(il, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 #if 0 /* Enable this if you want to see details */
 			IL_ERR("uCode INST section is invalid at "
-- 
1.7.1

