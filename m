Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37143 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754355AbbCRJNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 05:13:24 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t2I99lCj009594
	for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2015 02:13:24 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0a-0016f401.pphosted.com with ESMTP id 1t6thu9qbd-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2015 02:13:24 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH] mwifiex: fix crash in SDIO RX path
Date: Wed, 18 Mar 2015 20:12:52 +0530
Message-ID: <1426689772-24302-1-git-send-email-patila@marvell.com> (sfid-20150318_101331_298201_7055BD25)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With patch '960d6d08e39 "mwifiex: delay skb allocation for RX
until cmd53 over"' we no more pass skb parameter to MP aggregation setup
helper function. We instead pass length to be aggregated.

This patch fixes an issue where we were passing length parameter of NULL
skb to aggregation routine resulting into crash. We should instead pass
rx_len received from mp_regs.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 330e9d0..4f08c58 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1375,7 +1375,7 @@ rx_curr_single:
 	if (f_post_aggr_cur) {
 		dev_dbg(adapter->dev, "info: current packet aggregation\n");
 		/* Curr pkt can be aggregated */
-		mp_rx_aggr_setup(card, skb->len, port);
+		mp_rx_aggr_setup(card, rx_len, port);
 	}
 
 	return 0;
-- 
1.8.1.4

