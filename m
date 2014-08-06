Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2556 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbaHFHcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2014 03:32:22 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	Dedy Lansky <qca_dlansky@qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH v2 01/13] wil6210: map MAC timer for packet lifetime into debugfs
Date: Wed, 6 Aug 2014 10:31:49 +0300
Message-ID: <1407310322-22568-2-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140806_093226_447872_38B05AA9)
In-Reply-To: <1407310322-22568-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1407310322-22568-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

expose reading RGF_MAC_MTRL_COUNTER_0 in debugfs

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 3 +++
 drivers/net/wireless/ath/wil6210/wil6210.h | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 8f66186..dee2380 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1021,6 +1021,9 @@ int wil6210_debugfs_init(struct wil6210_priv *wil)
 				   HOSTADDR(RGF_DMA_EP_MISC_ICR));
 	wil6210_debugfs_create_pseudo_ISR(wil, dbg);
 	wil6210_debugfs_create_ITR_CNT(wil, dbg);
+	wil_debugfs_create_iomem_x32("MAC_MTRL_COUNTER_0", S_IRUGO, dbg,
+				     wil->csr +
+				     HOSTADDR(RGF_MAC_MTRL_COUNTER_0));
 
 	wil_debugfs_create_iomem_x32("RGF_USER_USAGE_1", S_IRUGO, dbg,
 				     wil->csr +
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 67e9624..077e623 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -133,6 +133,9 @@ struct RGF_ICR {
 #define RGF_HP_CTRL			(0x88265c)
 #define RGF_PCIE_LOS_COUNTER_CTL	(0x882dc4)
 
+/* MAC timer, usec, for packet lifetime */
+#define RGF_MAC_MTRL_COUNTER_0		(0x886aa8)
+
 /* popular locations */
 #define HOST_MBOX   HOSTADDR(RGF_USER_USER_SCRATCH_PAD)
 #define HOST_SW_INT (HOSTADDR(RGF_USER_USER_ICR) + \
-- 
1.8.5.2

