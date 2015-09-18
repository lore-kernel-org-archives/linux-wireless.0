Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6733 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988AbbIRNdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:33:03 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t8IDOR8b027007
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:33:02 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 1wy3qpfe8a-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:33:02 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 08/16] mwifiex: avoid memsetting PCIe event buffer
Date: Fri, 18 Sep 2015 06:32:10 -0700
Message-ID: <1442583138-2979-9-git-send-email-akarwar@marvell.com> (sfid-20150918_153308_984116_7A0543C3)
In-Reply-To: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
References: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preallocated PCIe buffer is being reused for all PCIe interface
events. Physical address of the buffer is shared with firmware
so that it can perform DMA on it. As event length is specified
in the header, there should not be a problem if the buffer gets
overwritten.
We will save some cycles by avoiding memset everytime while
submitting the buffer to firmware.

Fixes: 2728cecdc7d6bf3d21(mwifiex: corrections in PCIe event skb)
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 408b684..21192b6 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1815,7 +1815,6 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 	if (!card->evt_buf_list[rdptr]) {
 		skb_push(skb, INTF_HEADER_LEN);
 		skb_put(skb, MAX_EVENT_SIZE - skb->len);
-		memset(skb->data, 0, MAX_EVENT_SIZE);
 		if (mwifiex_map_pci_memory(adapter, skb,
 					   MAX_EVENT_SIZE,
 					   PCI_DMA_FROMDEVICE))
-- 
1.8.1.4

