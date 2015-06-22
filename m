Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37774 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932919AbbFVIGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:06:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t5M7xsZq032685
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:06:53 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1v57pduf0e-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:06:53 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 03/17] mwifiex: do not increase tx_pkts_queued if receive address tx paused
Date: Mon, 22 Jun 2015 19:06:09 +0530
Message-ID: <1434980183-2901-4-git-send-email-patila@marvell.com> (sfid-20150622_100657_302419_318D31A7)
In-Reply-To: <1434980183-2901-1-git-send-email-patila@marvell.com>
References: <1434980183-2901-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

If tx_pkts_queued is increased for tx paused receive address, tx process
will be triggered for this packet. But since RA list was tx paused,
there will be an infinite loop in mwifiex_wmm_process_tx waiting for the
event(tx pause, tdls cs) to cancel tx pause. This will be an dead loop,
since main_process was locked at this time, there will be no opportunity
to process event.

So do not increase tx_pkts_queued if receive address tx paused,
this will be restored RA list is unpaused.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/wmm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 8a4dd24..8e343b3 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -803,7 +803,10 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 		atomic_set(&priv->wmm.highest_queued_prio,
 			   priv->tos_to_tid_inv[tid_down]);
 
-	atomic_inc(&priv->wmm.tx_pkts_queued);
+	if (ra_list->tx_paused)
+		priv->wmm.pkts_paused[tid_down]++;
+	else
+		atomic_inc(&priv->wmm.tx_pkts_queued);
 
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 }
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
