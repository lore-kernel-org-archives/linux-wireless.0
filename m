Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na6sys009bog013.obsmtp.com ([74.125.150.66]:44393 "EHLO
	na6sys009bog013.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752430Ab2HDB3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 21:29:40 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 01/16] mwifiex: copy MSDU subframes correctly
Date: Fri,  3 Aug 2012 18:05:59 -0700
Message-Id: <1344042374-6892-2-git-send-email-bzhao@marvell.com> (sfid-20120804_035551_057217_9E3104EA)
In-Reply-To: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
References: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

All MSDU subframes, except the first one in AMSDU, were being written
wrongly at the location of first MSDU frame. Fixing that by copying
the MSDU at skb->tail of AMSDU.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index ab84eb9..c631c7c 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -62,9 +62,7 @@ mwifiex_11n_form_amsdu_pkt(struct sk_buff *skb_aggr,
 	};
 	struct tx_packet_hdr *tx_header;
 
-	skb_put(skb_aggr, sizeof(*tx_header));
-
-	tx_header = (struct tx_packet_hdr *) skb_aggr->data;
+	tx_header = (void *)skb_put(skb_aggr, sizeof(*tx_header));
 
 	/* Copy DA and SA */
 	dt_offset = 2 * ETH_ALEN;
@@ -82,9 +80,8 @@ mwifiex_11n_form_amsdu_pkt(struct sk_buff *skb_aggr,
 	tx_header->eth803_hdr.h_proto = htons(skb_src->len + LLC_SNAP_LEN);
 
 	/* Add payload */
-	skb_put(skb_aggr, skb_src->len);
-	memcpy(skb_aggr->data + sizeof(*tx_header), skb_src->data,
-	       skb_src->len);
+	memcpy(skb_put(skb_aggr, skb_src->len), skb_src->data, skb_src->len);
+
 	*pad = (((skb_src->len + LLC_SNAP_LEN) & 3)) ? (4 - (((skb_src->len +
 						      LLC_SNAP_LEN)) & 3)) : 0;
 	skb_put(skb_aggr, *pad);
-- 
1.7.0.2

