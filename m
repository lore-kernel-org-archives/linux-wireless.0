Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965906AbcBCSkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 01/28] rtl8xxxu: Minor cleanup to rtl8xxxu_download_firmware()
Date: Wed,  3 Feb 2016 13:39:35 -0500
Message-Id: <1454524802-26763-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194817_198810_05CD3F99)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 6aed923..6b39e4d 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2100,7 +2100,8 @@ static int rtl8xxxu_download_firmware(struct rtl8xxxu_priv *priv)
 
 	/* 8051 enable */
 	val16 = rtl8xxxu_read16(priv, REG_SYS_FUNC);
-	rtl8xxxu_write16(priv, REG_SYS_FUNC, val16 | SYS_FUNC_CPU_ENABLE);
+	val16 |= SYS_FUNC_CPU_ENABLE;
+	rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
 
 	/* MCU firmware download enable */
 	val8 = rtl8xxxu_read8(priv, REG_MCU_FW_DL);
-- 
2.5.0

