Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62674 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753100Ab3LCHSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 02:18:41 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 12/12] mwifiex: do not flood kmsg/dmesg with USB debug messages
Date: Mon, 2 Dec 2013 23:17:59 -0800
Message-ID: <1386055079-6623-13-git-send-email-bzhao@marvell.com> (sfid-20131203_081851_332245_71D46AAC)
In-Reply-To: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
References: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ujjal Roy <royujjal@gmail.com>

When TX data URB reaches high water mark the message
"data: -ENOSR is returned" is printed.
This is not an error case, so change it to debug print.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 3446da6..37f26af 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -112,7 +112,7 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 
 	switch (ret) {
 	case -ENOSR:
-		dev_err(adapter->dev, "data: -ENOSR is returned\n");
+		dev_dbg(adapter->dev, "data: -ENOSR is returned\n");
 		break;
 	case -EBUSY:
 		if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
-- 
1.8.2.3

