Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4689 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757130AbaFTSqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 14:46:16 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Andrew Wiley <wiley.andrew.j@gmail.com>,
	Linus Gasser <list@markas-al-nour.org>,
	Michael Hirsch <hirsch@teufel.de>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.16] mwifiex: fix Tx timeout issue
Date: Fri, 20 Jun 2014 11:45:25 -0700
Message-ID: <1403289925-4912-1-git-send-email-bzhao@marvell.com> (sfid-20140620_204620_222289_1FB1397F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

https://bugzilla.kernel.org/show_bug.cgi?id=70191
https://bugzilla.kernel.org/show_bug.cgi?id=77581

It is observed that sometimes Tx packet is downloaded without
adding driver's txpd header. This results in firmware parsing
garbage data as packet length. Sometimes firmware is unable
to read the packet if length comes out as invalid. This stops
further traffic and timeout occurs.

The root cause is uninitialized fields in tx_info(skb->cb) of
packet used to get garbage values. In this case if
MWIFIEX_BUF_FLAG_REQUEUED_PKT flag is mistakenly set, txpd
header was skipped. This patch makes sure that tx_info is
correctly initialized to fix the problem.

Cc: <stable@vger.kernel.org>
Reported-by: Andrew Wiley <wiley.andrew.j@gmail.com>
Reported-by: Linus Gasser <list@markas-al-nour.org>
Reported-by: Michael Hirsch <hirsch@teufel.de>
Tested-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Maithili Hinge <maithili@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 657504c..3e5194f 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -644,6 +644,7 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
+	memset(tx_info, 0, sizeof(*tx_info));
 	tx_info->bss_num = priv->bss_num;
 	tx_info->bss_type = priv->bss_type;
 	tx_info->pkt_len = skb->len;
-- 
1.8.2.3

