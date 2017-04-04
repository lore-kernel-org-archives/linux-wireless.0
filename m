Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59612 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751081AbdDDEtB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 00:49:01 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v344derJ012774
        for <linux-wireless@vger.kernel.org>; Mon, 3 Apr 2017 21:49:00 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 29m4j882cs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Mon, 03 Apr 2017 21:49:00 -0700
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] mwifiex: Fix invalid port issue
Date: Tue, 4 Apr 2017 10:16:28 +0530
Message-ID: <1491281188-6471-1-git-send-email-gbhat@marvell.com> (sfid-20170404_065037_442970_65D45E2F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have to use start port, for TX/RX of single packet,
instead of current aggregating port. This will fix SDIO
CMD53(TX/RX) returning -ETIMEDOUT and halting the data path.

fixes: 0cb52aac4 ('mwifiex: do not set multiport flag for tx/rx single packet')
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 58d3da0..369450a 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -1380,7 +1380,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 		}
 
 		if (card->mpa_rx.pkt_cnt == 1)
-			mport = adapter->ioport + port;
+			mport = adapter->ioport + card->mpa_rx.start_port;
 
 		if (mwifiex_read_data_sync(adapter, card->mpa_rx.buf,
 					   card->mpa_rx.buf_len, mport, 1))
@@ -1813,7 +1813,7 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 		}
 
 		if (card->mpa_tx.pkt_cnt == 1)
-			mport = adapter->ioport + port;
+			mport = adapter->ioport + card->mpa_tx.start_port;
 
 		ret = mwifiex_write_data_to_card(adapter, card->mpa_tx.buf,
 						 card->mpa_tx.buf_len, mport);
-- 
1.9.1
