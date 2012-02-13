Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524Ab2BMKYG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:24:06 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 03/24] iwlegacy: cleanup/fix memory barriers
Date: Mon, 13 Feb 2012 11:23:10 +0100
Message-Id: <1329128611-6815-4-git-send-email-sgruszka@redhat.com> (sfid-20120213_112422_732338_60739C11)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wmb(), rmb() are not needed when writel(), readl() are used as
accessors for MMIO. We use them indirectly via iowrite32(),
ioread32().

What is needed mmiowb(), for synchronizing writes coming from
different CPUs on PCIe bridge (see in patch comments). This
fortunately is not needed on x86, where mmiowb() is just
defined as compiler barrier. As iwlegacy devices are most likely
not used on anything other than x86, this is not so important
fix.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.c |    2 --
 drivers/net/wireless/iwlegacy/common.h |    9 +++++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 6dbd11f..50308da 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -179,7 +179,6 @@ il_read_targ_mem(struct il_priv *il, u32 addr)
 	_il_grab_nic_access(il);
 
 	_il_wr(il, HBUS_TARG_MEM_RADDR, addr);
-	rmb();
 	value = _il_rd(il, HBUS_TARG_MEM_RDAT);
 
 	_il_release_nic_access(il);
@@ -196,7 +195,6 @@ il_write_targ_mem(struct il_priv *il, u32 addr, u32 val)
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
 	if (likely(_il_grab_nic_access(il))) {
 		_il_wr(il, HBUS_TARG_MEM_WADDR, addr);
-		wmb();
 		_il_wr(il, HBUS_TARG_MEM_WDAT, val);
 		_il_release_nic_access(il);
 	}
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 1dfaa58..df9b5b4 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -2146,6 +2146,13 @@ static inline void
 _il_release_nic_access(struct il_priv *il)
 {
 	_il_clear_bit(il, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	/*
+	 * In above we are reading CSR_GP_CNTRL register, what will flush any
+	 * previous writes, but still want write, which clear MAC_ACCESS_REQ
+	 * bit, be performed on PCI bus before any other writes scheduled on
+	 * different CPUs (after we drop reg_lock).
+	 */
+	mmiowb();
 }
 
 static inline u32
@@ -2179,7 +2186,6 @@ static inline u32
 _il_rd_prph(struct il_priv *il, u32 reg)
 {
 	_il_wr(il, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
-	rmb();
 	return _il_rd(il, HBUS_TARG_PRPH_RDAT);
 }
 
@@ -2187,7 +2193,6 @@ static inline void
 _il_wr_prph(struct il_priv *il, u32 addr, u32 val)
 {
 	_il_wr(il, HBUS_TARG_PRPH_WADDR, ((addr & 0x0000FFFF) | (3 << 24)));
-	wmb();
 	_il_wr(il, HBUS_TARG_PRPH_WDAT, val);
 }
 
-- 
1.7.1

