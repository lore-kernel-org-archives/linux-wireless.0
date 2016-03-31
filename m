Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932980AbcCaVIt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 17:08:49 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 09/10] rtl8xxxu: Use correct H2C calls for 8192eu
Date: Thu, 31 Mar 2016 17:08:41 -0400
Message-Id: <1459458522-28686-10-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160331_230858_132475_8BDC944F)
In-Reply-To: <1459458522-28686-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1459458522-28686-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The 8192eu uses the same H2C API as the 8723bu. Call the correct
functions for update_rate_mask() and report_connect().

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 201f6cf..f2e32a7 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -8525,8 +8525,8 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.enable_rf = rtl8723b_enable_rf,
 	.disable_rf = rtl8723b_disable_rf,
 	.set_tx_power = rtl8723b_set_tx_power,
-	.update_rate_mask = rtl8723au_update_rate_mask,
-	.report_connect = rtl8723au_report_connect,
+	.update_rate_mask = rtl8723bu_update_rate_mask,
+	.report_connect = rtl8723bu_report_connect,
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
-- 
2.5.5

