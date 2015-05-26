Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:13034 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753327AbbEZNfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 09:35:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4QDYnnf009579
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2015 06:35:07 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1umgmahafq-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2015 06:35:07 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/6] mwifiex: fix SDIO firmware dump problem
Date: Tue, 26 May 2015 06:34:27 -0700
Message-ID: <1432647272-5734-2-git-send-email-akarwar@marvell.com> (sfid-20150526_153527_111963_98575514)
In-Reply-To: <1432647272-5734-1-git-send-email-akarwar@marvell.com>
References: <1432647272-5734-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's been observed that firmware doesn't go back to normal
state when all firmware memories are dumped. As a result,
further commands are blocked. This happens due to missing
driver change of writing READ DONE to control register for
SDIO interface.

This patch adds a missing change to fix the problem.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index f4b1de7..a3d810b8 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -2241,6 +2241,13 @@ static void mwifiex_sdio_fw_dump_work(struct mwifiex_adapter *adapter)
 
 		if (memory_size == 0) {
 			mwifiex_dbg(adapter, DUMP, "Firmware dump Finished!\n");
+			ret = mwifiex_write_reg(adapter,
+						card->reg->fw_dump_ctrl,
+						FW_DUMP_READ_DONE);
+			if (ret) {
+				mwifiex_dbg(adapter, ERROR, "SDIO write err\n");
+				return;
+			}
 			break;
 		}
 
-- 
1.8.1.4

