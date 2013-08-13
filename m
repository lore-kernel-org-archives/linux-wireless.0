Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:65255 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab3HMF7q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 01:59:46 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 4/4] ath10k: plug possible memory leak in WMI
Date: Tue, 13 Aug 2013 07:59:38 +0200
Message-ID: <1376373578-2180-5-git-send-email-michal.kazior@tieto.com> (sfid-20130813_075950_561025_2547E8EB)
In-Reply-To: <1376373578-2180-1-git-send-email-michal.kazior@tieto.com>
References: <1375949813-10969-1-git-send-email-michal.kazior@tieto.com>
 <1376373578-2180-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was a possible memory leak when WMI command
queue reached it's limit. Command buffers were not
freed.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 55f90c7..775fedf 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -110,6 +110,7 @@ static int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb,
 	if (atomic_add_return(1, &ar->wmi.pending_tx_count) >
 	    WMI_MAX_PENDING_TX_COUNT) {
 		/* avoid using up memory when FW hangs */
+		dev_kfree_skb(skb);
 		atomic_dec(&ar->wmi.pending_tx_count);
 		return -EBUSY;
 	}
-- 
1.7.9.5

