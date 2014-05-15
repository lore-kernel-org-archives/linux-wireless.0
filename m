Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:59909 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaEOM4M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 08:56:12 -0400
Received: by mail-ee0-f42.google.com with SMTP id d49so648947eek.29
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 05:56:11 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, apenwarr@gmail.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] ath10k: add explicit memory barrier for ring index update
Date: Thu, 15 May 2014 14:48:59 +0200
Message-Id: <1400158139-13836-4-git-send-email-michal.kazior@tieto.com> (sfid-20140515_145619_117378_C9ED6383)
In-Reply-To: <1400158139-13836-1-git-send-email-michal.kazior@tieto.com>
References: <1400158139-13836-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avery reported he had some issues related to
instructions being re-ordered on his ARM test
system resulting in firmware crashes.

This makes sure that data is in place before CE
ring index is updated telling firmware it can
fetch the data.

Reported-By: Avery Pennarun <apenwarr@gmail.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 966f26e..e66159e 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -63,6 +63,7 @@ static inline void ath10k_ce_dest_ring_write_index_set(struct ath10k *ar,
 						       u32 ce_ctrl_addr,
 						       unsigned int n)
 {
+	mb();
 	ath10k_pci_write32(ar, ce_ctrl_addr + DST_WR_INDEX_ADDRESS, n);
 }
 
@@ -76,6 +77,7 @@ static inline void ath10k_ce_src_ring_write_index_set(struct ath10k *ar,
 						      u32 ce_ctrl_addr,
 						      unsigned int n)
 {
+	mb();
 	ath10k_pci_write32(ar, ce_ctrl_addr + SR_WR_INDEX_ADDRESS, n);
 }
 
-- 
1.8.5.3

