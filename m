Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876Ab1KRIWu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:22:50 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8Molp026329
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:22:50 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 56/77] iwlegacy: remove iwl-helpers.h
Date: Fri, 18 Nov 2011 09:22:18 +0100
Message-Id: <1321604559-10707-56-git-send-email-sgruszka@redhat.com> (sfid-20111118_092359_887420_C8DAA261)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This file was already merged into common.h

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-helpers.h |  187 ---------------------------
 1 files changed, 0 insertions(+), 187 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-helpers.h

diff --git a/drivers/net/wireless/iwlegacy/iwl-helpers.h b/drivers/net/wireless/iwlegacy/iwl-helpers.h
deleted file mode 100644
index 2db83fc..0000000
--- a/drivers/net/wireless/iwlegacy/iwl-helpers.h
+++ /dev/null
@@ -1,187 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
- *
- * Portions of this file are derived from the ipw3945 project, as well
- * as portions of the ieee80211 subsystem header files.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-
-#ifndef __il_helpers_h__
-#define __il_helpers_h__
-
-#include <linux/ctype.h>
-#include <net/mac80211.h>
-
-#include "iwl-io.h"
-
-/**
- * il_queue_inc_wrap - increment queue idx, wrap back to beginning
- * @idx -- current idx
- * @n_bd -- total number of entries in queue (must be power of 2)
- */
-static inline int il_queue_inc_wrap(int idx, int n_bd)
-{
-	return ++idx & (n_bd - 1);
-}
-
-/**
- * il_queue_dec_wrap - decrement queue idx, wrap back to end
- * @idx -- current idx
- * @n_bd -- total number of entries in queue (must be power of 2)
- */
-static inline int il_queue_dec_wrap(int idx, int n_bd)
-{
-	return --idx & (n_bd - 1);
-}
-
-/* TODO: Move fw_desc functions to iwl-pci.ko */
-static inline void il_free_fw_desc(struct pci_dev *pci_dev,
-				    struct fw_desc *desc)
-{
-	if (desc->v_addr)
-		dma_free_coherent(&pci_dev->dev, desc->len,
-				  desc->v_addr, desc->p_addr);
-	desc->v_addr = NULL;
-	desc->len = 0;
-}
-
-static inline int il_alloc_fw_desc(struct pci_dev *pci_dev,
-				    struct fw_desc *desc)
-{
-	if (!desc->len) {
-		desc->v_addr = NULL;
-		return -EINVAL;
-	}
-
-	desc->v_addr = dma_alloc_coherent(&pci_dev->dev, desc->len,
-					  &desc->p_addr, GFP_KERNEL);
-	return (desc->v_addr != NULL) ? 0 : -ENOMEM;
-}
-
-/*
- * we have 8 bits used like this:
- *
- * 7 6 5 4 3 2 1 0
- * | | | | | | | |
- * | | | | | | +-+-------- AC queue (0-3)
- * | | | | | |
- * | +-+-+-+-+------------ HW queue ID
- * |
- * +---------------------- unused
- */
-static inline void
-il_set_swq_id(struct il_tx_queue *txq, u8 ac, u8 hwq)
-{
-	BUG_ON(ac > 3);   /* only have 2 bits */
-	BUG_ON(hwq > 31); /* only use 5 bits */
-
-	txq->swq_id = (hwq << 2) | ac;
-}
-
-static inline void il_wake_queue(struct il_priv *il,
-				  struct il_tx_queue *txq)
-{
-	u8 queue = txq->swq_id;
-	u8 ac = queue & 3;
-	u8 hwq = (queue >> 2) & 0x1f;
-
-	if (test_and_clear_bit(hwq, il->queue_stopped))
-		if (atomic_dec_return(&il->queue_stop_count[ac]) <= 0)
-			ieee80211_wake_queue(il->hw, ac);
-}
-
-static inline void il_stop_queue(struct il_priv *il,
-				  struct il_tx_queue *txq)
-{
-	u8 queue = txq->swq_id;
-	u8 ac = queue & 3;
-	u8 hwq = (queue >> 2) & 0x1f;
-
-	if (!test_and_set_bit(hwq, il->queue_stopped))
-		if (atomic_inc_return(&il->queue_stop_count[ac]) > 0)
-			ieee80211_stop_queue(il->hw, ac);
-}
-
-#ifdef ieee80211_stop_queue
-#undef ieee80211_stop_queue
-#endif
-
-#define ieee80211_stop_queue DO_NOT_USE_ieee80211_stop_queue
-
-#ifdef ieee80211_wake_queue
-#undef ieee80211_wake_queue
-#endif
-
-#define ieee80211_wake_queue DO_NOT_USE_ieee80211_wake_queue
-
-static inline void il_disable_interrupts(struct il_priv *il)
-{
-	clear_bit(S_INT_ENABLED, &il->status);
-
-	/* disable interrupts from uCode/NIC to host */
-	_il_wr(il, CSR_INT_MASK, 0x00000000);
-
-	/* acknowledge/clear/reset any interrupts still pending
-	 * from uCode or flow handler (Rx/Tx DMA) */
-	_il_wr(il, CSR_INT, 0xffffffff);
-	_il_wr(il, CSR_FH_INT_STATUS, 0xffffffff);
-	D_ISR("Disabled interrupts\n");
-}
-
-static inline void il_enable_rfkill_int(struct il_priv *il)
-{
-	D_ISR("Enabling rfkill interrupt\n");
-	_il_wr(il, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
-}
-
-static inline void il_enable_interrupts(struct il_priv *il)
-{
-	D_ISR("Enabling interrupts\n");
-	set_bit(S_INT_ENABLED, &il->status);
-	_il_wr(il, CSR_INT_MASK, il->inta_mask);
-}
-
-/**
- * il_beacon_time_mask_low - mask of lower 32 bit of beacon time
- * @il -- pointer to il_priv data structure
- * @tsf_bits -- number of bits need to shift for masking)
- */
-static inline u32 il_beacon_time_mask_low(struct il_priv *il,
-					   u16 tsf_bits)
-{
-	return (1 << tsf_bits) - 1;
-}
-
-/**
- * il_beacon_time_mask_high - mask of higher 32 bit of beacon time
- * @il -- pointer to il_priv data structure
- * @tsf_bits -- number of bits need to shift for masking)
- */
-static inline u32 il_beacon_time_mask_high(struct il_priv *il,
-					    u16 tsf_bits)
-{
-	return ((1 << (32 - tsf_bits)) - 1) << tsf_bits;
-}
-
-#endif				/* __il_helpers_h__ */
-- 
1.7.1

