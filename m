Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:43367 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab1JRGN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 02:13:27 -0400
Date: Tue, 18 Oct 2011 09:13:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/4] mwifiex: remove unneeded kfree(NULL);
Message-ID: <20111018061306.GG27732@elgon.mountain> (sfid-20111018_081331_649431_1F42EB7D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The previous if statement means this that pointer is NULL so there
is no need to free it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

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
