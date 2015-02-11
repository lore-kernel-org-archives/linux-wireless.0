Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16714 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445AbbBKMNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2015 07:13:08 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t1BCA4pk015501
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2015 04:13:07 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1sfwqx17jx-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2015 04:13:06 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<szli@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 4/4] mwifiex: modify TX buff size for SD8887
Date: Wed, 11 Feb 2015 23:12:27 +0530
Message-ID: <1423676547-5213-4-git-send-email-patila@marvell.com> (sfid-20150211_131314_866114_C6C6A1AF)
In-Reply-To: <1423676547-5213-1-git-send-email-patila@marvell.com>
References: <1423676547-5213-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FW crash has been observed while running iperf TX with SD8887
devices. This is because of invalid TX buffer setting. SD8887
supports 2K buffer sizes. This patch fixes this issue.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 3fe9fb4..c636944 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -472,7 +472,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8887 = {
 	.reg = &mwifiex_reg_sd8887,
 	.max_ports = 32,
 	.mp_agg_pkt_limit = 16,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
 	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
 	.supports_sdio_new_mode = true,
-- 
1.8.1.4

