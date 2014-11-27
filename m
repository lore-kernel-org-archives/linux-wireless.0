Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:42905 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbaK0KWZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 05:22:25 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so7790706wiv.13
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2014 02:22:24 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/3] ath10k: remove unused callback argument
Date: Thu, 27 Nov 2014 11:09:36 +0100
Message-Id: <1417082978-1701-1-git-send-email-michal.kazior@tieto.com> (sfid-20141127_112228_960142_32E071D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This wasn't used since forever and there are no
plans on using it.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/hif.h | 3 +--
 drivers/net/wireless/ath/ath10k/htc.c | 3 +--
 drivers/net/wireless/ath/ath10k/pci.c | 2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 6ac5523..91d24a5 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -35,8 +35,7 @@ struct ath10k_hif_cb {
 			     struct sk_buff *wbuf,
 			     unsigned transfer_id);
 	int (*rx_completion)(struct ath10k *ar,
-			     struct sk_buff *wbuf,
-			     u8 pipe_id);
+			     struct sk_buff *wbuf);
 };
 
 struct ath10k_hif_ops {
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 676bd4e..e245e34 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -317,8 +317,7 @@ static int ath10k_htc_process_trailer(struct ath10k_htc *htc,
 }
 
 static int ath10k_htc_rx_completion_handler(struct ath10k *ar,
-					    struct sk_buff *skb,
-					    u8 pipe_id)
+					    struct sk_buff *skb)
 {
 	int status = 0;
 	struct ath10k_htc *htc = &ar->htc;
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 0816098..541f3bc 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -875,7 +875,7 @@ static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state)
 		ath10k_dbg_dump(ar, ATH10K_DBG_PCI_DUMP, NULL, "pci rx: ",
 				skb->data, skb->len);
 
-		cb->rx_completion(ar, skb, pipe_info->pipe_num);
+		cb->rx_completion(ar, skb);
 	}
 
 	ath10k_pci_rx_post_pipe(pipe_info);
-- 
1.8.5.3

