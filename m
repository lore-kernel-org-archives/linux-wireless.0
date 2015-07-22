Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4743 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964845AbbGVLy0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 07:54:26 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t6MBnm6P028385
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 04:54:26 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 1vqm5jkw4w-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 04:54:26 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Zhaoyang Liu <liuzy@marvell.com>
Subject: [PATCH 4/4] mwifiex: corrections in PCIe event skb handling
Date: Wed, 22 Jul 2015 04:53:45 -0700
Message-ID: <1437566025-3324-4-git-send-email-akarwar@marvell.com> (sfid-20150722_135432_251632_7335E659)
In-Reply-To: <1437566025-3324-1-git-send-email-akarwar@marvell.com>
References: <1437566025-3324-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preallocated event SKBs are getting reused for PCIe chipset.
Their physical addresses are shared with firmware so that
firmware can write data into them.

This patch makes sure that SKB is cleared and length is set to
default while submitting it to firmware.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 77b9055..33c75d7 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1807,6 +1807,8 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 
 	if (!card->evt_buf_list[rdptr]) {
 		skb_push(skb, INTF_HEADER_LEN);
+		skb_put(skb, MAX_EVENT_SIZE - skb->len);
+		memset(skb->data, 0, MAX_EVENT_SIZE);
 		if (mwifiex_map_pci_memory(adapter, skb,
 					   MAX_EVENT_SIZE,
 					   PCI_DMA_FROMDEVICE))
-- 
1.8.1.4

