Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33090 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858AbbLNMRV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 07:17:21 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBECGb8i027452
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:20 -0800
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 1yswmng020-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:20 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 08/14] mwifiex: remove redundant timestamp assignment
Date: Mon, 14 Dec 2015 04:15:09 -0800
Message-ID: <1450095315-19927-9-git-send-email-akarwar@marvell.com> (sfid-20151214_131725_703237_E1218B65)
In-Reply-To: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
References: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During AMSDU aggregation, we are already using timestamp
value of a first packet being aggregated. This patch removes
redundant ktime_get_real() call.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/11n_aggr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
index aa498e0..1efef3b 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
@@ -203,8 +203,6 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	skb_aggr->priority = skb_src->priority;
 	skb_aggr->tstamp = skb_src->tstamp;
 
-	skb_aggr->tstamp = ktime_get_real();
-
 	do {
 		/* Check if AMSDU can accommodate this MSDU */
 		if (skb_tailroom(skb_aggr) < (skb_src->len + LLC_SNAP_LEN))
-- 
1.8.1.4

