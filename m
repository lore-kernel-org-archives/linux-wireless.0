Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:35827 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752830AbeFKVKA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Jun 2018 17:10:00 -0400
Received: by mail-pl0-f67.google.com with SMTP id k1-v6so4624611plt.2
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2018 14:10:00 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 1/4] ath10k: snoc: use correct bus-specific pointer in RX retry
Date: Mon, 11 Jun 2018 14:09:43 -0700
Message-Id: <20180611210946.241341-1-briannorris@chromium.org> (sfid-20180611_231106_141393_C1A17A55)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We're 'ath10k_snoc', not 'ath10k_pci'. This probably means we're
accessing junk data in ath10k_snoc_rx_replenish_retry(), unless
'ath10k_snoc' and 'ath10k_pci' happen to have very similar struct
layouts.

Noticed by inspection.

Fixes: d915105231ca ("ath10k: add hif rx methods for wcn3990")
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
It's possible this would be a for-4.18 target, since the buggy patch is
in the -rc1 merge. But this driver is not fully operational yet. Also,
I'm sending some companion refactorings to help avoid this bug. They
probably aren't 4.18 material.

Let me know if I should do anything differently.

 drivers/net/wireless/ath/ath10k/snoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index ee74e0060504..c7cfc9c9b3d7 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -449,7 +449,7 @@ static void ath10k_snoc_htt_rx_cb(struct ath10k_ce_pipe *ce_state)
 
 static void ath10k_snoc_rx_replenish_retry(struct timer_list *t)
 {
-	struct ath10k_pci *ar_snoc = from_timer(ar_snoc, t, rx_post_retry);
+	struct ath10k_snoc *ar_snoc = from_timer(ar_snoc, t, rx_post_retry);
 	struct ath10k *ar = ar_snoc->ar;
 
 	ath10k_snoc_rx_post(ar);
-- 
2.18.0.rc1.242.g61856ae69a-goog
