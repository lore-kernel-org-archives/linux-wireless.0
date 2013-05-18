Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:56142 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756507Ab3ERAyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 20:54:00 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 12/17] mwifiex: code rearrangement in mwifiex_get_rd_port()
Date: Fri, 17 May 2013 17:53:56 -0700
Message-ID: <1368838436-32704-1-git-send-email-bzhao@marvell.com> (sfid-20130518_025414_164555_1BB8FBE7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Get rid of 'if else' usage by returning in 'if' block.
This improves readability by removing indentations.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index e4357a6..a18a5b4 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -512,22 +512,23 @@ static int mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
 		*port = CTRL_PORT;
 		dev_dbg(adapter->dev, "data: port=%d mp_rd_bitmap=0x%08x\n",
 			*port, card->mp_rd_bitmap);
-	} else {
-		if (card->mp_rd_bitmap & (1 << card->curr_rd_port)) {
-			card->mp_rd_bitmap &= (u32)
-						(~(1 << card->curr_rd_port));
-			*port = card->curr_rd_port;
+		return 0;
+	}
 
-			if (++card->curr_rd_port == card->max_ports)
-				card->curr_rd_port = reg->start_rd_port;
-		} else {
-			return -1;
-		}
+	if (!(card->mp_rd_bitmap & (1 << card->curr_rd_port)))
+		return -1;
+
+	/* We are now handling the SDIO data ports */
+	card->mp_rd_bitmap &= (u32)(~(1 << card->curr_rd_port));
+	*port = card->curr_rd_port;
+
+	if (++card->curr_rd_port == card->max_ports)
+		card->curr_rd_port = reg->start_rd_port;
+
+	dev_dbg(adapter->dev,
+		"data: port=%d mp_rd_bitmap=0x%08x -> 0x%08x\n",
+		*port, rd_bitmap, card->mp_rd_bitmap);
 
-		dev_dbg(adapter->dev,
-			"data: port=%d mp_rd_bitmap=0x%08x -> 0x%08x\n",
-			*port, rd_bitmap, card->mp_rd_bitmap);
-	}
 	return 0;
 }
 
-- 
1.8.2.3

