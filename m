Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6022 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933030AbbJIL1Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 07:27:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t99BPHxY011866
	for <linux-wireless@vger.kernel.org>; Fri, 9 Oct 2015 04:27:24 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0a-0016f401.pphosted.com with ESMTP id 1xaccgxgd2-2
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2015 04:27:24 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/3] mwifiex: remove unnecessary NULL check
Date: Fri, 9 Oct 2015 04:26:35 -0700
Message-ID: <1444389995-4869-3-git-send-email-akarwar@marvell.com> (sfid-20151009_132735_333591_37C736FA)
In-Reply-To: <1444389995-4869-1-git-send-email-akarwar@marvell.com>
References: <1444389995-4869-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

ra_list cannot be NULL here, so remove the unnecessary NULL check.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/wmm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 7bbdfe4..2db51b1 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -691,7 +691,7 @@ void mwifiex_update_ralist_tx_pause_in_tdls_cs(struct mwifiex_private *priv,
 			if (!memcmp(ra_list->ra, mac, ETH_ALEN))
 				continue;
 
-			if (ra_list && ra_list->tx_paused != tx_pause) {
+			if (ra_list->tx_paused != tx_pause) {
 				pkt_cnt += ra_list->total_pkt_count;
 				ra_list->tx_paused = tx_pause;
 				if (tx_pause)
-- 
1.8.1.4

