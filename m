Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:4183 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbaFPQib (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:31 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 11/25] wil6210: writeable ITR registers
Date: Mon, 16 Jun 2014 19:37:09 +0300
Message-ID: <1402936643-31819-12-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_183836_600395_B4EEBFB9)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Interrupt threshold registers may be written to.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 8767f4c..4cb54eb 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -321,11 +321,11 @@ static int wil6210_debugfs_create_ITR_CNT(struct wil6210_priv *wil,
 	if (IS_ERR_OR_NULL(d))
 		return -ENODEV;
 
-	wil_debugfs_create_iomem_x32("TRSH", S_IRUGO, d, wil->csr +
+	wil_debugfs_create_iomem_x32("TRSH", S_IRUGO | S_IWUSR, d, wil->csr +
 				     HOSTADDR(RGF_DMA_ITR_CNT_TRSH));
-	wil_debugfs_create_iomem_x32("DATA", S_IRUGO, d, wil->csr +
+	wil_debugfs_create_iomem_x32("DATA", S_IRUGO | S_IWUSR, d, wil->csr +
 				     HOSTADDR(RGF_DMA_ITR_CNT_DATA));
-	wil_debugfs_create_iomem_x32("CTL", S_IRUGO, d, wil->csr +
+	wil_debugfs_create_iomem_x32("CTL", S_IRUGO | S_IWUSR, d, wil->csr +
 				     HOSTADDR(RGF_DMA_ITR_CNT_CRL));
 
 	return 0;
-- 
1.9.1

