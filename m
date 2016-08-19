Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38272 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754043AbcHSVrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 17:47:24 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 05/20] rtl8xxxu: Add TX page defines for 8723b
Date: Fri, 19 Aug 2016 17:46:27 -0400
Message-Id: <1471643202-26250-6-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160819_234843_646114_B9E805F9)
In-Reply-To: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This switches the 8723b driver to use the new
rtl8xxxu_init_queue_reserved_page() function.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h       | 6 ++++++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 4341d56..da4f148 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -43,6 +43,7 @@
 
 #define TX_TOTAL_PAGE_NUM		0xf8
 #define TX_TOTAL_PAGE_NUM_8192E		0xf3
+#define TX_TOTAL_PAGE_NUM_8723B		0xf7
 /* (HPQ + LPQ + NPQ + PUBQ) = TX_TOTAL_PAGE_NUM */
 #define TX_PAGE_NUM_PUBQ		0xe7
 #define TX_PAGE_NUM_HI_PQ		0x0c
@@ -54,6 +55,11 @@
 #define TX_PAGE_NUM_LO_PQ_8192E		0x0c
 #define TX_PAGE_NUM_NORM_PQ_8192E	0x00
 
+#define TX_PAGE_NUM_PUBQ_8723B		0xe7
+#define TX_PAGE_NUM_HI_PQ_8723B		0x0c
+#define TX_PAGE_NUM_LO_PQ_8723B		0x02
+#define TX_PAGE_NUM_NORM_PQ_8723B	0x02
+
 #define RTL_FW_PAGE_SIZE		4096
 #define RTL8XXXU_FIRMWARE_POLL_MAX	1000
 
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
index 9d45afb..c1323f0 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
@@ -1674,4 +1674,8 @@ struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.pbp_rx = PBP_PAGE_SIZE_256,
 	.pbp_tx = PBP_PAGE_SIZE_256,
 	.mactable = rtl8723b_mac_init_table,
+	.total_page_num = TX_TOTAL_PAGE_NUM_8723B,
+	.page_num_hi = TX_PAGE_NUM_HI_PQ_8723B,
+	.page_num_lo = TX_PAGE_NUM_LO_PQ_8723B,
+	.page_num_norm = TX_PAGE_NUM_NORM_PQ_8723B,
 };
-- 
2.7.4
