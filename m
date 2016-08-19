Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54756 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755283AbcHSVrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 17:47:24 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 06/20] rtl8xxxu: Switch 8723a to use new rtl8xxxu_init_queue_reserved_page() routine
Date: Fri, 19 Aug 2016 17:46:28 -0400
Message-Id: <1471643202-26250-7-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160819_234842_533385_B26DA597)
In-Reply-To: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This changes the pub-queue value written to REQ_RQPN, however the old
code used a hard coded minimum value assuming there would always be an
active lo-queue, even when no USB EP was found for it.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
index 686c551..d6f4968 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
@@ -396,4 +396,8 @@ struct rtl8xxxu_fileops rtl8723au_fops = {
 	.pbp_rx = PBP_PAGE_SIZE_128,
 	.pbp_tx = PBP_PAGE_SIZE_128,
 	.mactable = rtl8xxxu_gen1_mac_init_table,
+	.total_page_num = TX_TOTAL_PAGE_NUM,
+	.page_num_hi = TX_PAGE_NUM_HI_PQ,
+	.page_num_lo = TX_PAGE_NUM_LO_PQ,
+	.page_num_norm = TX_PAGE_NUM_NORM_PQ,
 };
-- 
2.7.4
