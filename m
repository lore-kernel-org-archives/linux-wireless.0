Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56619 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754557AbbA3Imj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 03:42:39 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0U8cxUS006804
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 00:42:39 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1s7fgab5jc-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 00:42:39 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/4] mwifiex: fix NULL packet downloading issues
Date: Fri, 30 Jan 2015 00:40:06 -0800
Message-ID: <1422607207-15229-3-git-send-email-akarwar@marvell.com> (sfid-20150130_094250_809558_572AEBBA)
In-Reply-To: <1422607207-15229-1-git-send-email-akarwar@marvell.com>
References: <1422607207-15229-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes sure that skb is freed after downloading
NULL packet in error cases. Also, USB chipsets return
-EINPROGRESS after downloading packets, they are freed in
USB completion handler later. We will add missing change
to set tx_lock_flag for USB which blocks further packets.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_tx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 1debe76..5ce2d9a 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -183,9 +183,13 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 	}
 	switch (ret) {
 	case -EBUSY:
-		adapter->data_sent = true;
-		/* Fall through FAILURE handling */
+		dev_kfree_skb_any(skb);
+		dev_err(adapter->dev, "%s: host_to_card failed: ret=%d\n",
+			__func__, ret);
+		adapter->dbg.num_tx_host_to_card_failure++;
+		break;
 	case -1:
+		adapter->data_sent = false;
 		dev_kfree_skb_any(skb);
 		dev_err(adapter->dev, "%s: host_to_card failed: ret=%d\n",
 			__func__, ret);
@@ -198,6 +202,7 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 		adapter->tx_lock_flag = true;
 		break;
 	case -EINPROGRESS:
+		adapter->tx_lock_flag = true;
 		break;
 	default:
 		break;
-- 
1.8.1.4

