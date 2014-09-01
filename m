Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:65039 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483AbaIAHb1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 03:31:27 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 07/17] mwifiex: minor cleanup in multiport aggregation
Date: Mon, 1 Sep 2014 18:28:55 +0530
Message-ID: <1409576345-13717-8-git-send-email-patila@marvell.com> (sfid-20140901_093131_709085_317103B3)
In-Reply-To: <1409576345-13717-1-git-send-email-patila@marvell.com>
References: <1409576345-13717-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

'mp_data_port_mask' and 'mp_end_port' gives correct information
even for the chipsets supporting SDIO new mode (32 ports).
We will get rid of this chip specific handling.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 993841e..bdab122 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -622,22 +622,15 @@ static int mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u32 *port)
 
 	dev_dbg(adapter->dev, "data: mp_wr_bitmap=0x%08x\n", wr_bitmap);
 
-	if (card->supports_sdio_new_mode &&
-	    !(wr_bitmap & reg->data_port_mask)) {
+	if (!(wr_bitmap & card->mp_data_port_mask)) {
 		adapter->data_sent = true;
 		return -EBUSY;
-	} else if (!card->supports_sdio_new_mode &&
-		   !(wr_bitmap & card->mp_data_port_mask)) {
-		return -1;
 	}
 
 	if (card->mp_wr_bitmap & (1 << card->curr_wr_port)) {
 		card->mp_wr_bitmap &= (u32) (~(1 << card->curr_wr_port));
 		*port = card->curr_wr_port;
-		if (((card->supports_sdio_new_mode) &&
-		     (++card->curr_wr_port == card->max_ports)) ||
-		    ((!card->supports_sdio_new_mode) &&
-		     (++card->curr_wr_port == card->mp_end_port)))
+		if (++card->curr_wr_port == card->mp_end_port)
 			card->curr_wr_port = reg->start_wr_port;
 	} else {
 		adapter->data_sent = true;
-- 
1.8.1.4

