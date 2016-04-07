Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757302AbcDGSTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 14:19:34 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 09/18] rtl8xxxu: Handle BB init for 8192eu
Date: Thu,  7 Apr 2016 14:19:24 -0400
Message-Id: <1460053173-8494-10-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160407_202005_123627_D35B78A3)
In-Reply-To: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The 8192eu does not use REG_AFE_PLL_CTRL in it's BB init sequence, so
provide device specific handling.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index b5b157f..c3d69ff 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3649,6 +3649,11 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
 
 		rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
+	} else if (priv->rtl_chip == RTL8192E) {
+		val16 = rtl8xxxu_read16(priv, REG_SYS_FUNC);
+		val16 |= SYS_FUNC_BB_GLB_RSTN | SYS_FUNC_BBRSTB |
+			SYS_FUNC_DIO_RF;
+		rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
 	} else {
 		val8 = rtl8xxxu_read8(priv, REG_AFE_PLL_CTRL);
 		udelay(2);
-- 
2.5.5

