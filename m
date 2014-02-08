Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26739 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533AbaBHAZ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:25:57 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Aaron Durbin <adurbin@chromium.org>,
	Paul Stewart <pstew@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 10/30] mwifiex: don't leak DMA command skbuffs
Date: Fri, 7 Feb 2014 16:25:51 -0800
Message-ID: <1391819151-21073-2-git-send-email-bzhao@marvell.com> (sfid-20140208_012607_975617_A9CCEF62)
In-Reply-To: <1391819151-21073-1-git-send-email-bzhao@marvell.com>
References: <1391819151-21073-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aaron Durbin <adurbin@chromium.org>

The current mwifiex pcie driver assumed that it would get
its cmdrsp_complete() callback called before another command
was sent to unmap the command's skbuff. However, that is not
true. The mwifiex_check_ps_cond() will send a sleep command
to the card without having adapter->curr_cmd set. Within the
workqueue's state machine the adapter's state would be set
to allow commands (curr_cmd = NULL && cmd_sent = false) after
having receieved the response from the sleep command. The
card->cmd_buf would then be overridden with the new command
but the first command's skbuff was not unmapped. This leaks
mapped skbuffs when a bounce buffer is employed.

To rectify this unmap the card->cmd_buf when the response is
received from the card instead of waiting for the
cmdrsp_complete() callback.

Signed-off-by: Aaron Durbin <adurbin@chromium.org>
Reviewed-by: Paul Stewart <pstew@chromium.org>
Reviewed-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 4e1c6b2..d11d4ac 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1513,6 +1513,13 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 
 	mwifiex_unmap_pci_memory(adapter, skb, PCI_DMA_FROMDEVICE);
 
+	/* Unmap the command as a response has been received. */
+	if (card->cmd_buf) {
+		mwifiex_unmap_pci_memory(adapter, card->cmd_buf,
+					 PCI_DMA_TODEVICE);
+		card->cmd_buf = NULL;
+	}
+
 	pkt_len = *((__le16 *)skb->data);
 	rx_len = le16_to_cpu(pkt_len);
 	skb_trim(skb, rx_len);
@@ -1569,7 +1576,6 @@ static int mwifiex_pcie_cmdrsp_complete(struct mwifiex_adapter *adapter,
 					struct sk_buff *skb)
 {
 	struct pcie_service_card *card = adapter->card;
-	struct sk_buff *skb_tmp;
 
 	if (skb) {
 		card->cmdrsp_buf = skb;
@@ -1579,12 +1585,6 @@ static int mwifiex_pcie_cmdrsp_complete(struct mwifiex_adapter *adapter,
 			return -1;
 	}
 
-	skb_tmp = card->cmd_buf;
-	if (skb_tmp) {
-		mwifiex_unmap_pci_memory(adapter, skb_tmp, PCI_DMA_FROMDEVICE);
-		card->cmd_buf = NULL;
-	}
-
 	return 0;
 }
 
-- 
1.8.2.3

