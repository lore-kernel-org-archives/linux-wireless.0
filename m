Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56511 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932077AbbFAMea (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 08:34:30 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t51CUdPs028520
	for <linux-wireless@vger.kernel.org>; Mon, 1 Jun 2015 05:34:26 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1urjjr0nfu-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 05:34:26 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCHv4 17/17] mwifiex: do not decrease tx_pending for AMSDU packet once more
Date: Mon, 1 Jun 2015 23:32:15 +0530
Message-ID: <1433181735-15712-18-git-send-email-patila@marvell.com> (sfid-20150601_150350_544385_42B69E54)
In-Reply-To: <1433181735-15712-1-git-send-email-patila@marvell.com>
References: <1433181735-15712-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Negative adapter->tx_pending is observed while running data traffic,
because tx_pending is decreased once more for AMSDU packet.

since tx_pending have been decreased for all the source MSDU packets,
we don't need to update once more for AMSDU packet.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/txrx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index c4c7d8d..5ed9b79 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -319,11 +319,11 @@ int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 		priv->stats.tx_errors++;
 	}
 
-	if (tx_info->flags & MWIFIEX_BUF_FLAG_BRIDGED_PKT) {
+	if (tx_info->flags & MWIFIEX_BUF_FLAG_BRIDGED_PKT)
 		atomic_dec_return(&adapter->pending_bridged_pkts);
-		if (tx_info->flags & MWIFIEX_BUF_FLAG_AGGR_PKT)
-			goto done;
-	}
+
+	if (tx_info->flags & MWIFIEX_BUF_FLAG_AGGR_PKT)
+		goto done;
 
 	if (aggr)
 		/* For skb_aggr, do not wake up tx queue */
-- 
1.8.1.4

