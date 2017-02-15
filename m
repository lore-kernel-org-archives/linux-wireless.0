Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52366 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752505AbdBOXwA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 18:52:00 -0500
From: <ryanhsu@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
CC: <lenb@kernel.org>, <ryanhsu@qca.qualcomm.com>
Subject: [PATCH 2/2] ath10k: improve the firmware download time for QCA9377
Date: Wed, 15 Feb 2017 15:50:38 -0800
Message-ID: <1487202638-13244-2-git-send-email-ryanhsu@qca.qualcomm.com> (sfid-20170216_005207_167508_D90A58CB)
In-Reply-To: <1487202638-13244-1-git-send-email-ryanhsu@qca.qualcomm.com>
References: <1487202638-13244-1-git-send-email-ryanhsu@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ryan Hsu <ryanhsu@qca.qualcomm.com>

QCA9377 is the family of QCA61x4 which shared the same procedure
to enable the hardware clock that could improve the firmware download time.

Signed-off-by: Ryan Hsu <ryanhsu@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c6de267..91e2731 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -282,7 +282,9 @@
 			.board_size = QCA9377_BOARD_DATA_SZ,
 			.board_ext_size = QCA9377_BOARD_EXT_DATA_SZ,
 		},
-		.hw_ops = &qca988x_ops,
+		.hw_ops = &qca6174_ops,
+		.hw_clk = qca6174_clk,
+		.target_cpu_freq = 176000000,
 		.decap_align_bytes = 4,
 	},
 	{
-- 
1.9.1
