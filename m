Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18835 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755847AbaDNWdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 18:33:17 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 5/7] mwifiex: update timestamp information for aggregation packets
Date: Mon, 14 Apr 2014 15:32:53 -0700
Message-ID: <1397514775-4777-5-git-send-email-bzhao@marvell.com> (sfid-20140415_003330_390421_AE4C34BB)
In-Reply-To: <1397514775-4777-1-git-send-email-bzhao@marvell.com>
References: <1397514775-4777-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

New skbs are allocated at the time of AMSDU aggregation. Setting
up in timestamps for such skbs was missing which would result
into wrong queue delays passed to FW. Fix this by setting
timestamp of skbs created for AMSDU aggregation.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index b179652..860dfe7 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -160,6 +160,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	int pad = 0, ret;
 	struct mwifiex_tx_param tx_param;
 	struct txpd *ptx_pd = NULL;
+	struct timeval tv;
 	int headroom = adapter->iface_type == MWIFIEX_USB ? 0 : INTF_HEADER_LEN;
 
 	skb_src = skb_peek(&pra_list->skb_head);
@@ -184,6 +185,9 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	tx_info_aggr->bss_num = tx_info_src->bss_num;
 	skb_aggr->priority = skb_src->priority;
 
+	do_gettimeofday(&tv);
+	skb_aggr->tstamp = timeval_to_ktime(tv);
+
 	do {
 		/* Check if AMSDU can accommodate this MSDU */
 		if (skb_tailroom(skb_aggr) < (skb_src->len + LLC_SNAP_LEN))
-- 
1.8.2.3

