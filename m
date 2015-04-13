Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7457 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753746AbbDMKcp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 06:32:45 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t3DAU62h018936
	for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2015 03:32:39 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0a-0016f401.pphosted.com with ESMTP id 1tpw03vrp9-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2015 03:32:39 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 1/2] revert "mwifiex: enable aggregation for TID 6 and 7 streams"
Date: Mon, 13 Apr 2015 21:32:24 +0530
Message-ID: <1428940945-4123-1-git-send-email-patila@marvell.com> (sfid-20150413_123249_594558_0259326D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch reverts 'commit c5534844cdee ("mwifiex:
enable aggregation for TID 6 and 7 streams")'.
TID6 & TID7 is voice traffic which is quite time sensitive.
Do not enable any type of aggregation on these TIDs.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/wmm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index b2e9956..8be9d13 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -428,6 +428,15 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
 							priv->tos_to_tid_inv[i];
 		}
 
+		priv->aggr_prio_tbl[6].amsdu
+					= priv->aggr_prio_tbl[6].ampdu_ap
+					= priv->aggr_prio_tbl[6].ampdu_user
+					= BA_STREAM_NOT_ALLOWED;
+
+		priv->aggr_prio_tbl[7].amsdu = priv->aggr_prio_tbl[7].ampdu_ap
+					= priv->aggr_prio_tbl[7].ampdu_user
+					= BA_STREAM_NOT_ALLOWED;
+
 		mwifiex_set_ba_params(priv);
 		mwifiex_reset_11n_rx_seq_num(priv);
 
-- 
1.8.1.4

