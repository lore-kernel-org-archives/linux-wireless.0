Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17839 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988AbbIRNdH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:33:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t8IDPBmU030912
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:33:07 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 1wy3qm7eqm-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:33:07 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 10/16] mwifiex: Suppress -ENOSR error for data traffic on USB
Date: Fri, 18 Sep 2015 06:32:12 -0700
Message-ID: <1442583138-2979-11-git-send-email-akarwar@marvell.com> (sfid-20150918_153316_658076_FCC7069F)
In-Reply-To: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
References: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have preallocated buffer pool for Tx data. During high
data traffic, all buffers are submitted to USB and driver needs
to wait until one of the buffers get available for next Tx
packet.

"data: -ENOSR is returned" errors is expected in this case. Let's
lower the priority of this message.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 8b1e5b5..98f097d 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -130,7 +130,7 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 
 	switch (ret) {
 	case -ENOSR:
-		mwifiex_dbg(adapter, ERROR, "data: -ENOSR is returned\n");
+		mwifiex_dbg(adapter, DATA, "data: -ENOSR is returned\n");
 		break;
 	case -EBUSY:
 		if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
-- 
1.8.1.4

