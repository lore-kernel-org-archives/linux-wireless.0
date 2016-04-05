Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30435 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755083AbcDEH2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 03:28:55 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u357SI2J028604
	for <linux-wireless@vger.kernel.org>; Tue, 5 Apr 2016 00:28:54 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0a-0016f401.pphosted.com with ESMTP id 222bekhtp6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2016 00:28:54 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 5/7] mwifiex: schedule main workqueue for transmitting bridge packets
Date: Tue, 5 Apr 2016 00:22:30 -0700
Message-ID: <1459840952-25338-5-git-send-email-akarwar@marvell.com> (sfid-20160405_092901_752293_D6B64385)
In-Reply-To: <1459840952-25338-1-git-send-email-akarwar@marvell.com>
References: <1459840952-25338-1-git-send-email-akarwar@marvell.com>
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

