Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:42050 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbaGNGvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 02:51:16 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 6/7] wil6210: map RGF_USER_USAGE_1 on the debugfs
Date: Mon, 14 Jul 2014 09:49:42 +0300
Message-ID: <1405320583-5775-7-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140714_085124_644904_8C679EB1)
In-Reply-To: <1405320583-5775-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1405320583-5775-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Firmware sets this register with the offset of the firmware trace area
within the peripheral memory region. Critical for the firmware trace
to work

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c |    3 +++
 drivers/net/wireless/ath/wil6210/wil6210.h |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index d5b095d..8f66186 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1022,6 +1022,9 @@ int wil6210_debugfs_init(struct wil6210_priv *wil)
 	wil6210_debugfs_create_pseudo_ISR(wil, dbg);
 	wil6210_debugfs_create_ITR_CNT(wil, dbg);
 
+	wil_debugfs_create_iomem_x32("RGF_USER_USAGE_1", S_IRUGO, dbg,
+				     wil->csr +
+				     HOSTADDR(RGF_USER_USAGE_1));
 	debugfs_create_u32("mem_addr", S_IRUGO | S_IWUSR, dbg, &mem_addr);
 	debugfs_create_file("mem_val", S_IRUGO, dbg, wil, &fops_memread);
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 02205b0..a78aaab 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -85,6 +85,7 @@ struct RGF_ICR {
 } __packed;
 
 /* registers - FW addresses */
+#define RGF_USER_USAGE_1		(0x880004)
 #define RGF_USER_HW_MACHINE_STATE	(0x8801dc)
 	#define HW_MACHINE_BOOT_DONE	(0x3fffffd)
 #define RGF_USER_USER_CPU_0		(0x8801e0)
-- 
1.7.6

