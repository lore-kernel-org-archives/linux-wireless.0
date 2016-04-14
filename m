Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbcDNUhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 16:37:23 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Colin Ian King <colin.king@canonical.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 02/16] rtl8xxxu: fix uninitialized return value in ret
Date: Thu, 14 Apr 2016 16:37:07 -0400
Message-Id: <1460666241-5365-3-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_223736_330980_6B37D653)
In-Reply-To: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

several functions are not initializing a return status in ret
resulting in garbage to be returned instead of 0 for success.
Currently, the calls to these functions are not checking the
return, however, it seems prudent to return the correct status
in case they are to be checked at a later date.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 037b64f..b88cf16 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6370,7 +6370,7 @@ static void rtl8xxxu_set_ampdu_min_space(struct rtl8xxxu_priv *priv, u8 density)
 static int rtl8xxxu_active_to_emu(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
-	int count, ret;
+	int count, ret = 0;
 
 	/* Start of rtl8723AU_card_enable_flow */
 	/* Act to Cardemu sequence*/
@@ -6420,7 +6420,7 @@ static int rtl8723bu_active_to_emu(struct rtl8xxxu_priv *priv)
 	u8 val8;
 	u16 val16;
 	u32 val32;
-	int count, ret;
+	int count, ret = 0;
 
 	/* Turn off RF */
 	rtl8xxxu_write8(priv, REG_RF_CTRL, 0);
@@ -6477,7 +6477,7 @@ static int rtl8xxxu_active_to_lps(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
 	u8 val32;
-	int count, ret;
+	int count, ret = 0;
 
 	rtl8xxxu_write8(priv, REG_TXPAUSE, 0xff);
 
-- 
2.5.5

