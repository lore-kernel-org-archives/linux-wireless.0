Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 14/26] rtl8xxxu: Correctly mask what was read from REG_CCK0_AFE_SETTING
Date: Thu, 14 Apr 2016 14:58:55 -0400
Message-Id: <1460660347-26299-15-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_212529_599610_C338D3E6)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The old code incorrectly wiped out bits 0-23 by mistake when setting
the RX path for 1T parts.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index c355d27..d0330a8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3814,7 +3814,7 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_write32(priv, REG_FPGA1_TX_INFO, val32);
 
 		val32 = rtl8xxxu_read32(priv, REG_CCK0_AFE_SETTING);
-		val32 &= 0xff000000;
+		val32 &= 0x00ffffff;
 		val32 |= 0x45000000;
 		rtl8xxxu_write32(priv, REG_CCK0_AFE_SETTING, val32);
 
-- 
2.5.5

