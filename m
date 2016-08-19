Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59606 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754967AbcHSVrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 17:47:24 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 07/20] rtl8xxxu: Switch 8192cu/8188cu devices to use rtl8xxxu_init_queue_reserved_page()
Date: Fri, 19 Aug 2016 17:46:29 -0400
Message-Id: <1471643202-26250-8-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160819_234846_997320_C9BA8720)
In-Reply-To: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This was the last user of the old
rtl8xxxu_old_init_queue_reserved_page() which can now be removed.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
index 69d1a14..cd13c25 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
@@ -579,5 +579,9 @@ struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.pbp_rx = PBP_PAGE_SIZE_128,
 	.pbp_tx = PBP_PAGE_SIZE_128,
 	.mactable = rtl8xxxu_gen1_mac_init_table,
+	.total_page_num = TX_TOTAL_PAGE_NUM,
+	.page_num_hi = TX_PAGE_NUM_HI_PQ,
+	.page_num_lo = TX_PAGE_NUM_LO_PQ,
+	.page_num_norm = TX_PAGE_NUM_NORM_PQ,
 };
 #endif
-- 
2.7.4
