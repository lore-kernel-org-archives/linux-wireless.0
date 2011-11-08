Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:50768 "HELO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752689Ab1KHDc2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 22:32:28 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH RESEND 1/4] mwifiex: remove unneeded kfree(NULL);
Date: Mon,  7 Nov 2011 19:31:44 -0800
Message-Id: <1320723107-24202-2-git-send-email-bzhao@marvell.com> (sfid-20111108_043230_543807_5486F261)
In-Reply-To: <1320723107-24202-1-git-send-email-bzhao@marvell.com>
References: <1320723107-24202-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

The previous if statement means this that pointer is NULL so there
is no need to free it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index d34acf0..4466976 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -386,7 +386,6 @@ static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
 	card->txbd_ring_vbase = kzalloc(card->txbd_ring_size, GFP_KERNEL);
 	if (!card->txbd_ring_vbase) {
 		dev_err(adapter->dev, "Unable to allocate buffer for txbd ring.\n");
-		kfree(card->txbd_ring_vbase);
 		return -1;
 	}
 	card->txbd_ring_pbase = virt_to_phys(card->txbd_ring_vbase);
-- 
1.7.0.2

