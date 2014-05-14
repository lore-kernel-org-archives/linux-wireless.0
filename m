Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45921 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751612AbaENCuW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 22:50:22 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	James Cameron <quozl@laptop.org>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: restore current SDIO write port in failure cases
Date: Tue, 13 May 2014 19:49:42 -0700
Message-ID: <1400035782-24355-1-git-send-email-bzhao@marvell.com> (sfid-20140514_045027_055507_1F8E3115)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

During SDIO MP aggregation, we at first acquire current write
port to write data onto and then proceed with using this port
for SDIO write. If error occurs later in mwifiex_write_data_sync
because device is suspended or SDIO write failure, we do not
restore current write port and write bitmap. This results into
leaking one port and hole in SDIO write port bitmap.
Restore current write port and reset bitmap accordingly in
failure cases to avoid this.

Reported-by: James Cameron <quozl@laptop.org>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index a1773d3..4ce3d7b 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1678,8 +1678,12 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 	if (ret) {
 		if (type == MWIFIEX_TYPE_CMD)
 			adapter->cmd_sent = false;
-		if (type == MWIFIEX_TYPE_DATA)
+		if (type == MWIFIEX_TYPE_DATA) {
 			adapter->data_sent = false;
+			/* restore curr_wr_port in error cases */
+			card->curr_wr_port = port;
+			card->mp_wr_bitmap |= (u32)(1 << card->curr_wr_port);
+		}
 	} else {
 		if (type == MWIFIEX_TYPE_DATA) {
 			if (!(card->mp_wr_bitmap & (1 << card->curr_wr_port)))
-- 
1.8.2.3

