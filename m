Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:48982 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab3KHHEx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 02:04:53 -0500
Received: by mail-ee0-f48.google.com with SMTP id d49so771438eek.21
        for <linux-wireless@vger.kernel.org>; Thu, 07 Nov 2013 23:04:51 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 10/13] ath10k: guard against CE corruption from firmware
Date: Fri,  8 Nov 2013 08:01:32 +0100
Message-Id: <1383894095-27998-11-git-send-email-michal.kazior@tieto.com> (sfid-20131108_080807_432999_0D4472A7)
In-Reply-To: <1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
 <1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case firmware crashes it may report CE
completions for entries that were never
submitted/filled with meaningful data. This in
turn led to NULL dereferences.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htc.c | 5 +++++
 drivers/net/wireless/ath/ath10k/pci.c | 7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 3118d75..6d7a72e 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -191,6 +191,11 @@ static int ath10k_htc_tx_completion_handler(struct ath10k *ar,
 	struct ath10k_htc *htc = &ar->htc;
 	struct ath10k_htc_ep *ep = &htc->endpoint[eid];
 
+	if (!skb) {
+		ath10k_warn("invalid sk_buff completion - NULL pointer. firmware crashed?\n");
+		return 0;
+	}
+
 	ath10k_htc_notify_tx_completion(ep, skb);
 	/* the skb now belongs to the completion handler */
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index e41665f..0b89726 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1270,6 +1270,13 @@ static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info)
 		 * Indicate the completion to higer layer to free
 		 * the buffer
 		 */
+
+		if (!netbuf) {
+			ath10k_warn("invalid sk_buff on CE %d - NULL pointer. firmware crashed?\n",
+				    ce_hdl->id);
+			continue;
+		}
+
 		ATH10K_SKB_CB(netbuf)->is_aborted = true;
 		ar_pci->msg_callbacks_current.tx_completion(ar,
 							    netbuf,
-- 
1.8.4.rc3

