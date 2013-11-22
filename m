Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:54909 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3KVNIn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Nov 2013 08:08:43 -0500
Received: by mail-ea0-f176.google.com with SMTP id h14so508436eaj.35
        for <linux-wireless@vger.kernel.org>; Fri, 22 Nov 2013 05:08:42 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/8] ath10k: fix memory leak on hif_start failpath
Date: Fri, 22 Nov 2013 14:05:13 +0100
Message-Id: <1385125518-13461-4-git-send-email-michal.kazior@tieto.com> (sfid-20131122_140850_314963_0D0FFE16)
In-Reply-To: <1385125518-13461-1-git-send-email-michal.kazior@tieto.com>
References: <1385125518-13461-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If post_rx failed then completions were not freed.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index d4536cb..4067890 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1205,6 +1205,7 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 	if (ret) {
 		ath10k_warn("failed to post RX buffers for all pipes: %d\n",
 			    ret);
+		ath10k_pci_stop_ce(ar);
 		return ret;
 	}
 
-- 
1.8.4.rc3

