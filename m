Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757317AbcDGSTf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 14:19:35 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 16/18] rtl8xxxu: Use proper register name for REG_PAD_CTRL1
Date: Thu,  7 Apr 2016 14:19:31 -0400
Message-Id: <1460053173-8494-17-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160407_201952_105325_E68442C3)
In-Reply-To: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Fixup another case where the hard coded register value was used
instead of the name.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 5a2eb0a..604deb4 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3550,9 +3550,9 @@ static void rtl8723bu_phy_init_antenna_selection(struct rtl8xxxu_priv *priv)
 {
 	u32 val32;
 
-	val32 = rtl8xxxu_read32(priv, 0x64);
+	val32 = rtl8xxxu_read32(priv, REG_PAD_CTRL1);
 	val32 &= ~(BIT(20) | BIT(24));
-	rtl8xxxu_write32(priv, 0x64, val32);
+	rtl8xxxu_write32(priv, REG_PAD_CTRL1, val32);
 
 	val32 = rtl8xxxu_read32(priv, REG_GPIO_MUXCFG);
 	val32 &= ~BIT(4);
-- 
2.5.5

