Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:55331 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204AbaHGJOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 05:14:30 -0400
Received: by mail-wi0-f180.google.com with SMTP id n3so4620350wiv.7
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 02:14:28 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/5] ath10k: ignore ar_pci->started in pipe cleanup
Date: Thu,  7 Aug 2014 11:05:06 +0200
Message-Id: <1407402308-29899-4-git-send-email-michal.kazior@tieto.com> (sfid-20140807_113153_716729_F2275624)
In-Reply-To: <1407402308-29899-1-git-send-email-michal.kazior@tieto.com>
References: <1407402308-29899-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Structures used by these functions are now
guaranteed to remain accessible until driver is
unregistered.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 6a5ca9e..8244658 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1088,10 +1088,6 @@ static void ath10k_pci_rx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info)
 
 	ar = pipe_info->hif_ce_state;
 	ar_pci = ath10k_pci_priv(ar);
-
-	if (!ar_pci->started)
-		return;
-
 	ce_hdl = pipe_info->ce_hdl;
 
 	while (ath10k_ce_revoke_recv_next(ce_hdl, (void **)&netbuf,
@@ -1122,10 +1118,6 @@ static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info)
 
 	ar = pipe_info->hif_ce_state;
 	ar_pci = ath10k_pci_priv(ar);
-
-	if (!ar_pci->started)
-		return;
-
 	ce_hdl = pipe_info->ce_hdl;
 
 	while (ath10k_ce_cancel_send_next(ce_hdl, (void **)&netbuf,
-- 
1.8.5.3

