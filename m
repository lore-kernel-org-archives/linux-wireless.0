Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43306 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753501AbbHFHkM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 03:40:12 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t767e924001457
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2015 00:40:11 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0a-0016f401.pphosted.com with ESMTP id 1w3t9dsbpa-3
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2015 00:40:11 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Aniket Nagarnaik <aniketn@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: claim sdio bus while downloading the firmware
Date: Thu, 6 Aug 2015 00:39:16 -0700
Message-ID: <1438846756-30520-1-git-send-email-akarwar@marvell.com> (sfid-20150806_094017_155329_32A37480)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aniket Nagarnaik <aniketn@marvell.com>

Our 8887 A2 chip can have separate firmware images for
bluetooth and WLAN. We observed an issue during parallel
downloading of these images by btmrvl and mwifiex drivers.

This patch claims sdio bus before starting of the firmware
download in mwifiex and releases it after completion to
fix the problem.

Signed-off-by: Aniket Nagarnaik <aniketn@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 7cef27e9..5d05c6f 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -920,6 +920,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	if (!fwbuf)
 		return -ENOMEM;
 
+	sdio_claim_host(card->func);
+
 	/* Perform firmware data transfer */
 	do {
 		/* The host polls for the DN_LD_CARD_RDY and CARD_IO_READY
@@ -1024,6 +1026,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		offset += txlen;
 	} while (true);
 
+	sdio_release_host(card->func);
+
 	mwifiex_dbg(adapter, MSG,
 		    "info: FW download over, size %d bytes\n", offset);
 
-- 
1.8.1.4

