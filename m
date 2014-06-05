Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40888 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaFEH4W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 03:56:22 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so9099546wib.4
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2014 00:56:21 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: sanitize tx ring index access properly
Date: Thu,  5 Jun 2014 09:48:40 +0200
Message-Id: <1401954520-3365-3-git-send-email-michal.kazior@tieto.com> (sfid-20140605_095626_839059_EDE05139)
In-Reply-To: <1401954520-3365-1-git-send-email-michal.kazior@tieto.com>
References: <1401954520-3365-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The tx ring index was immediately trimmed with a
bitmask. This discarded the 0xFFFFFFFF error case
(which theoretically can happen when a device is
abruptly disconnected) and led to using an invalid
tx ring index. This could lead to memory
corruption.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index d185dc0..7c6c7d5 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -603,16 +603,19 @@ static int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
 		if (ret)
 			return ret;
 
-		src_ring->hw_index =
-			ath10k_ce_src_ring_read_index_get(ar, ctrl_addr);
-		src_ring->hw_index &= nentries_mask;
+		read_index = ath10k_ce_src_ring_read_index_get(ar, ctrl_addr);
+		if (read_index == 0xFFFFFFFF)
+			return -ENODEV;
+
+		read_index &= nentries_mask;
+		src_ring->hw_index = read_index;
 
 		ath10k_pci_sleep(ar);
 	}
 
 	read_index = src_ring->hw_index;
 
-	if ((read_index == sw_index) || (read_index == 0xffffffff))
+	if (read_index == sw_index)
 		return -EIO;
 
 	sbase = src_ring->shadow_base;
-- 
1.8.5.3

