Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14445 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871AbbLNMRY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 07:17:24 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBECFMEI012493
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:23 -0800
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0a-0016f401.pphosted.com with ESMTP id 1yswkxr04r-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:23 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 10/14] mwifiex: fix AMPDU not setup on TDLS link problem
Date: Mon, 14 Dec 2015 04:15:11 -0800
Message-ID: <1450095315-19927-11-git-send-email-akarwar@marvell.com> (sfid-20151214_131747_874424_DC508AAF)
In-Reply-To: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
References: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes AP sends TDLS setup response as AMSDU packet.
As driver doesn't parse it and update peer station's 11n
capability in this case, AMPDU doesn't get setup.

This patch calls mwifiex_process_tdls_action_frame() in
AMSDU Rx path to fix the problem.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
index b3970a8..09578c6 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -48,7 +48,17 @@ static int mwifiex_11n_dispatch_amsdu_pkt(struct mwifiex_private *priv,
 					 priv->wdev.iftype, 0, false);
 
 		while (!skb_queue_empty(&list)) {
+			struct rx_packet_hdr *rx_hdr;
+
 			rx_skb = __skb_dequeue(&list);
+			rx_hdr = (struct rx_packet_hdr *)rx_skb->data;
+			if (ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info) &&
+			    ntohs(rx_hdr->eth803_hdr.h_proto) == ETH_P_TDLS) {
+				mwifiex_process_tdls_action_frame(priv,
+								  (u8 *)rx_hdr,
+								  skb->len);
+			}
+
 			ret = mwifiex_recv_packet(priv, rx_skb);
 			if (ret == -1)
 				mwifiex_dbg(priv->adapter, ERROR,
-- 
1.8.1.4

