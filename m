Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbcB2WFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:53 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 014/113] rtl8xxxu: Use 1024 byte writes for writing 8723bu firmware
Date: Mon, 29 Feb 2016 17:04:12 -0500
Message-Id: <1456783551-28315-15-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231117_236342_83D7DE93)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The 8723bu, like the 8192eu, can also handle 1024 byte block writes.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index b6068da..66a0c17 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6191,7 +6191,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.load_firmware = rtl8723bu_load_firmware,
 	.power_on = rtl8723au_power_on,
 	.llt_init = rtl8xxxu_auto_llt_table,
-	.writeN_block_size = 128,
+	.writeN_block_size = 1024,
 };
 
 #ifdef CONFIG_RTL8XXXU_UNTESTED
-- 
2.5.0

