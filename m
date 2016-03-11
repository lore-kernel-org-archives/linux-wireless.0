Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163AbcCKT5f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 14:57:35 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 5/7] rtl8xxxu: 8192eu uses txdesc40
Date: Fri, 11 Mar 2016 14:57:32 -0500
Message-Id: <1457726254-28178-6-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160311_205743_703587_0C50CEC0)
In-Reply-To: <1457726254-28178-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1457726254-28178-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

8192eu uses the new TX descriptor format

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 484d08f..ad280cf 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -8530,7 +8530,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
-	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc32),
+	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc40),
 	.has_s0s1 = 1,
 	.adda_1t_init = 0x0fc01616,
 	.adda_1t_path_on = 0x0fc01616,
-- 
2.5.0

