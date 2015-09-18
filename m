Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30683 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752474AbbIRNcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:32:51 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t8IDOQIZ027003
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:32:50 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0a-0016f401.pphosted.com with ESMTP id 1wy3qpfe7s-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:32:50 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 03/16] mwifiex: minor corrections in multiport aggregation code
Date: Fri, 18 Sep 2015 06:32:05 -0700
Message-ID: <1442583138-2979-4-git-send-email-akarwar@marvell.com> (sfid-20150918_153254_086682_44DDEA88)
In-Reply-To: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
References: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch includes below changes
1) Check if multiport aggregation feature flag while doing rx
length validation check.
2) Reset buffer size variables when buffers are freed.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 5d05c6f..d35210c 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1606,8 +1606,9 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 				(rx_len + MWIFIEX_SDIO_BLOCK_SIZE -
 				 1) / MWIFIEX_SDIO_BLOCK_SIZE;
 			if (rx_len <= INTF_HEADER_LEN ||
-			    (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE) >
-			     card->mpa_rx.buf_size) {
+			    (card->mpa_rx.enabled &&
+			     ((rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE) >
+			      card->mpa_rx.buf_size))) {
 				mwifiex_dbg(adapter, ERROR,
 					    "invalid rx_len=%d\n",
 					    rx_len);
@@ -1925,6 +1926,8 @@ error:
 	if (ret) {
 		kfree(card->mpa_tx.buf);
 		kfree(card->mpa_rx.buf);
+		card->mpa_tx.buf_size = 0;
+		card->mpa_rx.buf_size = 0;
 	}
 
 	return ret;
-- 
1.8.1.4

