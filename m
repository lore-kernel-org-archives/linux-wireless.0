Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17316 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbcBWNUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 08:20:32 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u1NDK59w006024
	for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2016 05:20:31 -0800
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0b-0016f401.pphosted.com with ESMTP id 218m3q0sae-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2016 05:20:31 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 4/4] mwifiex: do not set multiport flag for tx/rx single packet
Date: Tue, 23 Feb 2016 05:16:19 -0800
Message-ID: <1456233379-12099-4-git-send-email-akarwar@marvell.com> (sfid-20160223_142035_366490_94970954)
In-Reply-To: <1456233379-12099-1-git-send-email-akarwar@marvell.com>
References: <1456233379-12099-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

multiport address flag(0x1000) should not be set during sdio cmd53,
if we have only one packet to read/write.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 838b260..b2c839a 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -1355,6 +1355,9 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 				 card->mpa_rx.start_port;
 		}
 
+		if (card->mpa_rx.pkt_cnt == 1)
+			mport = adapter->ioport + port;
+
 		if (mwifiex_read_data_sync(adapter, card->mpa_rx.buf,
 					   card->mpa_rx.buf_len, mport, 1))
 			goto error;
@@ -1786,6 +1789,9 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 				 card->mpa_tx.start_port;
 		}
 
+		if (card->mpa_tx.pkt_cnt == 1)
+			mport = adapter->ioport + port;
+
 		ret = mwifiex_write_data_to_card(adapter, card->mpa_tx.buf,
 						 card->mpa_tx.buf_len, mport);
 
-- 
1.8.1.4

