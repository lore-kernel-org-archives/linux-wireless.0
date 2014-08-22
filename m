Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:46108 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308AbaHVMnJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 08:43:09 -0400
Received: by mail-la0-f52.google.com with SMTP id b17so10020581lan.11
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 05:43:08 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 3/5] ath10k: ignore ar_pci->started in pipe cleanup
Date: Fri, 22 Aug 2014 14:33:16 +0200
Message-Id: <1408710798-25198-4-git-send-email-michal.kazior@tieto.com> (sfid-20140822_144323_111751_C0B65226)
In-Reply-To: <1408710798-25198-1-git-send-email-michal.kazior@tieto.com>
References: <1408710798-25198-1-git-send-email-michal.kazior@tieto.com>
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
index daa38ce..cb4049f 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1143,10 +1143,6 @@ static void ath10k_pci_rx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info)
 
 	ar = pipe_info->hif_ce_state;
 	ar_pci = ath10k_pci_priv(ar);
-
-	if (!ar_pci->started)
-		return;
-
 	ce_hdl = pipe_info->ce_hdl;
 
 	while (ath10k_ce_revoke_recv_next(ce_hdl, (void **)&netbuf,
@@ -1177,10 +1173,6 @@ static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info)
 
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

