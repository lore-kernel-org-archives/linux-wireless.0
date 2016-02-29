Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbcB2WF5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:57 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 077/113] rtl8xxxu: Use REG_RFE_CTRL_ANTA_SRC rather than hard coded value
Date: Mon, 29 Feb 2016 17:05:15 -0500
Message-Id: <1456783551-28315-78-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230809_329123_72817523)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Another case where we should use the register name rather than the
hard coded value when accessing it.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 25a8ca5b..18458db 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2950,10 +2950,10 @@ static void rtl8723bu_phy_init_antenna_selection(struct rtl8xxxu_priv *priv)
 	val32 |= (BIT(0) | BIT(1));
 	rtl8xxxu_write32(priv, REG_RFE_BUFFER, val32);
 
-	val32 = rtl8xxxu_read32(priv, 0x0930);
+	val32 = rtl8xxxu_read32(priv, REG_RFE_CTRL_ANTA_SRC);
 	val32 &= 0xffffff00;
 	val32 |= 0x77;
-	rtl8xxxu_write32(priv, 0x0930, val32);
+	rtl8xxxu_write32(priv, REG_RFE_CTRL_ANTA_SRC, val32);
 
 	val32 = rtl8xxxu_read32(priv, REG_PWR_DATA);
 	val32 |= PWR_DATA_EEPRPAD_RFE_CTRL_EN;
-- 
2.5.0

