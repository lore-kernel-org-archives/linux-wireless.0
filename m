Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54380 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751139AbaDQSrl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 14:47:41 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 5/5] mwifiex: enable aggregation for TID 6 and 7 streams
Date: Thu, 17 Apr 2014 11:47:03 -0700
Message-ID: <1397760423-11455-5-git-send-email-bzhao@marvell.com> (sfid-20140417_204800_421283_AD004D13)
In-Reply-To: <1397760423-11455-1-git-send-email-bzhao@marvell.com>
References: <1397760423-11455-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently AMSDU and AMPDU aggregation is enabled for TID 0 to
TID 5 streams. Lets enable it for remaining two streams also.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/wmm.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 0a7cc74..94b6c74 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -426,15 +426,6 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
 							priv->tos_to_tid_inv[i];
 		}
 
-		priv->aggr_prio_tbl[6].amsdu
-					= priv->aggr_prio_tbl[6].ampdu_ap
-					= priv->aggr_prio_tbl[6].ampdu_user
-					= BA_STREAM_NOT_ALLOWED;
-
-		priv->aggr_prio_tbl[7].amsdu = priv->aggr_prio_tbl[7].ampdu_ap
-					= priv->aggr_prio_tbl[7].ampdu_user
-					= BA_STREAM_NOT_ALLOWED;
-
 		mwifiex_set_ba_params(priv);
 		mwifiex_reset_11n_rx_seq_num(priv);
 
-- 
1.8.2.3

