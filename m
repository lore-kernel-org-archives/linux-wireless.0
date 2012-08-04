Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na6sys009bog036.obsmtp.com ([74.125.150.110]:54063 "EHLO
	na6sys009bog036.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409Ab2HDBl4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 21:41:56 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 02/16] mwifiex: remove extra padding to AMSDU
Date: Fri,  3 Aug 2012 18:06:00 -0700
Message-Id: <1344042374-6892-3-git-send-email-bzhao@marvell.com> (sfid-20120804_034200_058195_9E8793C3)
In-Reply-To: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
References: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Since commit: fb3c19bc9687d972b83faf366b38ac807eca8f25, adding
extra padding to AMSDU is redundant since same is being performed at
mwifiex_11n_aggregate_pkt after forming the AMSDU packet. Fixing it
by removing it.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index c631c7c..04222f2 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -84,7 +84,6 @@ mwifiex_11n_form_amsdu_pkt(struct sk_buff *skb_aggr,
 
 	*pad = (((skb_src->len + LLC_SNAP_LEN) & 3)) ? (4 - (((skb_src->len +
 						      LLC_SNAP_LEN)) & 3)) : 0;
-	skb_put(skb_aggr, *pad);
 
 	return skb_aggr->len + *pad;
 }
-- 
1.7.0.2

