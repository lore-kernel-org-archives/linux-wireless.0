Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33061 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757097AbcDEILL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 04:11:11 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u3586bJj013891
	for <linux-wireless@vger.kernel.org>; Tue, 5 Apr 2016 01:11:05 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 222dkfh9h2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2016 01:11:05 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH RESEND 5/7] mwifiex: schedule main workqueue for transmitting bridge packets
Date: Tue, 5 Apr 2016 01:04:38 -0700
Message-ID: <1459843480-25956-5-git-send-email-akarwar@marvell.com> (sfid-20160405_101133_867977_A70B6B15)
In-Reply-To: <1459843480-25956-1-git-send-email-akarwar@marvell.com>
References: <1459843480-25956-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Bridge packets are enqueued to wmm tx queue, but will not be sent
until main workqeue is scheduled for new interrupt or other
reason. This adds unnecessary delay during traffic.

We will schedule main workqueue when bridge packet is queued.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
index 193a809..305589e 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
@@ -216,6 +216,8 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 	atomic_inc(&adapter->tx_pending);
 	atomic_inc(&adapter->pending_bridged_pkts);
 
+	mwifiex_queue_main_work(priv->adapter);
+
 	return;
 }
 
-- 
1.8.1.4

