Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:50927 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742Ab3CEA2Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 19:28:24 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Paul Fox <pgf@laptop.org>, Daniel Drake <dsd@laptop.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/7] mwifiex: avoid [-Wmaybe-uninitialized] warnings in pcie.c
Date: Mon,  4 Mar 2013 16:27:55 -0800
Message-Id: <1362443279-6064-4-git-send-email-bzhao@marvell.com> (sfid-20130305_012826_949877_25748294)
In-Reply-To: <1362443279-6064-1-git-send-email-bzhao@marvell.com>
References: <1362443279-6064-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/mwifiex/pcie.c:1157:9: warning:
  'desc2' may be used uninitialized in this function
  [-Wmaybe-uninitialized]
drivers/net/wireless/mwifiex/pcie.c:1048:31: note:
  'desc2' was declared here

drivers/net/wireless/mwifiex/pcie.c:1159:9: warning:
  'desc' may be used uninitialized in this function
  [-Wmaybe-uninitialized]
drivers/net/wireless/mwifiex/pcie.c:1047:32: note:
  'desc' was declared here

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 44902a3..6283294 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1030,8 +1030,8 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 	u32 wrindx, num_tx_buffs, rx_val;
 	int ret;
 	dma_addr_t buf_pa;
-	struct mwifiex_pcie_buf_desc *desc;
-	struct mwifiex_pfu_buf_desc *desc2;
+	struct mwifiex_pcie_buf_desc *desc = NULL;
+	struct mwifiex_pfu_buf_desc *desc2 = NULL;
 	__le16 *tmp;
 
 	if (!(skb->data && skb->len)) {
-- 
1.7.0.2

