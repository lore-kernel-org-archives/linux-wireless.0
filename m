Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41018 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751609AbbCMGig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 02:38:36 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t2D6ZAUx006745
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 23:38:36 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1t3pmg8hwh-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 23:38:36 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	<crlo@marvell.com>, <pchen@marvell.com>, <szli@marvell.com>,
	<nishants@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCHv2 3/9] mwifiex: enhance SD8897 MP aggregation limits
Date: Fri, 13 Mar 2015 17:37:53 +0530
Message-ID: <1426248479-28451-4-git-send-email-patila@marvell.com> (sfid-20150313_073839_462400_C9B2973B)
In-Reply-To: <1426248479-28451-1-git-send-email-patila@marvell.com>
References: <1426248479-28451-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SD8897 support buffers of 4K and 16 such ports can be accomodated.
So basically 64K buffer size in single aggregation is supported.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index c636944..264bc9b 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -67,6 +67,8 @@
 
 #define MWIFIEX_MP_AGGR_BUF_SIZE_16K	(16384)
 #define MWIFIEX_MP_AGGR_BUF_SIZE_32K	(32768)
+/* we leave one block of 256 bytes for DMA alignment*/
+#define MWIFIEX_MP_AGGR_BUF_SIZE_MAX    (65280)
 
 /* Misc. Config Register : Auto Re-enable interrupts */
 #define AUTO_RE_ENABLE_INT              BIT(4)
@@ -458,8 +460,8 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
 	.max_ports = 32,
 	.mp_agg_pkt_limit = 16,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
-	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
-	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
 	.supports_sdio_new_mode = true,
 	.has_control_mask = false,
 	.can_dump_fw = true,
-- 
1.8.1.4

