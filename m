Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54762 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755404AbcHSVrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 17:47:24 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 13/20] rtl8xxxu: Convert flags in rtl8xxxu_fileops to bitflags
Date: Fri, 19 Aug 2016 17:46:35 -0400
Message-Id: <1471643202-26250-14-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160819_234739_920388_3B94BAFA)
In-Reply-To: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This leaves space for a few more flags within the same space.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index c8d7075..c5b6846 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1340,8 +1340,8 @@ struct rtl8xxxu_fileops {
 	int rx_agg_buf_size;
 	char tx_desc_size;
 	char rx_desc_size;
-	char has_s0s1;
-	char has_tx_report;
+	u8 has_s0s1:1;
+	u8 has_tx_report:1;
 	u32 adda_1t_init;
 	u32 adda_1t_path_on;
 	u32 adda_2t_path_on_a;
-- 
2.7.4
