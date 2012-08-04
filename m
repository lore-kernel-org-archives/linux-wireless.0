Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na6sys009bog036.obsmtp.com ([74.125.150.110]:42143 "EHLO
	na6sys009bog036.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409Ab2HDBl6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 21:41:58 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 03/16] mwifiex: correction in MSDU padding logic
Date: Fri,  3 Aug 2012 18:06:01 -0700
Message-Id: <1344042374-6892-4-git-send-email-bzhao@marvell.com> (sfid-20120804_034201_526138_CBEE2228)
In-Reply-To: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
References: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Padding arithmetic will always work for MSDUs provided first MSDU
ends on 4-byte boundary. Fixing it by making sure that all MSDU ends
on 4-byte boundary.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 04222f2..395f1bf 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -82,8 +82,8 @@ mwifiex_11n_form_amsdu_pkt(struct sk_buff *skb_aggr,
 	/* Add payload */
 	memcpy(skb_put(skb_aggr, skb_src->len), skb_src->data, skb_src->len);
 
-	*pad = (((skb_src->len + LLC_SNAP_LEN) & 3)) ? (4 - (((skb_src->len +
-						      LLC_SNAP_LEN)) & 3)) : 0;
+	/* Add padding for new MSDU to start from 4 byte boundary */
+	*pad = (4 - ((unsigned long)skb_aggr->tail & 0x3)) % 4;
 
 	return skb_aggr->len + *pad;
 }
-- 
1.7.0.2

