Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:40823 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754113Ab3GWCTR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:19:17 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 17/21] mwifiex: correction in mwifiex_check_fw_status() return status
Date: Mon, 22 Jul 2013 19:17:54 -0700
Message-ID: <1374545878-15683-18-git-send-email-bzhao@marvell.com> (sfid-20130723_041923_056928_942BCB66)
In-Reply-To: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

For PCIe cards, when wrong firmware is downloaded, firmware is
failed to be ready in 10 seconds. We should return an error at
this point. But currently we are sending first command to firmware.
As expected firmware doesn't respond to this command and command
timeout occurs.

This patch fixes the problem by removing unnecessary 'ret'
variable modifications in "if (ret) {" block.
The block is just supposed to update "adapter->winner" flag.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 098153f..52da8ee 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1954,12 +1954,10 @@ mwifiex_check_fw_status(struct mwifiex_adapter *adapter, u32 poll_num)
 		else if (!winner_status) {
 			dev_err(adapter->dev, "PCI-E is the winner\n");
 			adapter->winner = 1;
-			ret = -1;
 		} else {
 			dev_err(adapter->dev,
 				"PCI-E is not the winner <%#x,%d>, exit dnld\n",
 				ret, adapter->winner);
-			ret = 0;
 		}
 	}
 
-- 
1.8.2.3

