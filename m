Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:54510 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754788Ab3CUA54 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 20:57:56 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.9] mwifiex: reset skb->data after processing PCIe sleep confirm cmd respose
Date: Wed, 20 Mar 2013 17:56:23 -0700
Message-ID: <1363827383-8758-1-git-send-email-bzhao@marvell.com> (sfid-20130321_015800_327872_A9089282)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch is a bug fix for an issue wherein power save was not
working for PCIe. This happens because for processing power save
sleep confirm command we pull skb so that skb->data points ahead
of interface header. We use same skb to get other cmda responses
as well. So if we don't push skb after processing cmd response,
it results into reduction in skb->len and finally skb->len reaches
zero. This causes failure in processing sleep command response.
Fix this by pushing skb by INTF_HEADER_LEN at the end of command
response processing.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 7ee4289..b6710c7 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1521,6 +1521,7 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 		}
 		memcpy(adapter->upld_buf, skb->data,
 		       min_t(u32, MWIFIEX_SIZE_OF_CMD_BUFFER, skb->len));
+		skb_push(skb, INTF_HEADER_LEN);
 		if (mwifiex_map_pci_memory(adapter, skb, MWIFIEX_UPLD_SIZE,
 					   PCI_DMA_FROMDEVICE))
 			return -1;
-- 
1.7.0.2

