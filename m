Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:63039 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab3KHHEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 02:04:49 -0500
Received: by mail-ee0-f45.google.com with SMTP id l10so152412eei.4
        for <linux-wireless@vger.kernel.org>; Thu, 07 Nov 2013 23:04:48 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 05/13] ath10k: make sure to mask all CE irqs
Date: Fri,  8 Nov 2013 08:01:27 +0100
Message-Id: <1383894095-27998-6-git-send-email-michal.kazior@tieto.com> (sfid-20131108_080501_068154_A55CD552)
In-Reply-To: <1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
 <1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CE error interrupts were not disabled. This could
lead to invalid memory accesses / memory
corruption.

Also make sure CE watermark interrupts are also
disabled.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 2b99bd4..7a49cde 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -243,6 +243,16 @@ static inline void ath10k_ce_error_intr_enable(struct ath10k *ar,
 			   misc_ie_addr | CE_ERROR_MASK);
 }
 
+static inline void ath10k_ce_error_intr_disable(struct ath10k *ar,
+						u32 ce_ctrl_addr)
+{
+	u32 misc_ie_addr = ath10k_pci_read32(ar,
+					     ce_ctrl_addr + MISC_IE_ADDRESS);
+
+	ath10k_pci_write32(ar, ce_ctrl_addr + MISC_IE_ADDRESS,
+			   misc_ie_addr & ~CE_ERROR_MASK);
+}
+
 static inline void ath10k_ce_engine_int_status_clear(struct ath10k *ar,
 						     u32 ce_ctrl_addr,
 						     unsigned int mask)
@@ -794,6 +804,8 @@ void ath10k_ce_disable_interrupts(struct ath10k *ar)
 		u32 ctrl_addr = ath10k_ce_base_address(ce_id);
 
 		ath10k_ce_copy_complete_intr_disable(ar, ctrl_addr);
+		ath10k_ce_error_intr_disable(ar, ctrl_addr);
+		ath10k_ce_watermark_intr_disable(ar, ctrl_addr);
 	}
 	ath10k_pci_sleep(ar);
 }
-- 
1.8.4.rc3

