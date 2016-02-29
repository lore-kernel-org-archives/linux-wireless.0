Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbcB2WF5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:57 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 047/113] rtl8xxxu: Set the right type for ps tdma on 8723bu
Date: Mon, 29 Feb 2016 17:04:45 -0500
Message-Id: <1456783551-28315-48-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230754_737136_DC78C393)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Use the correct type when setting PS TDMA for 8723bu. This matches the
vendor driver.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 24c3157..6aa908e 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5712,7 +5712,7 @@ static void rtl8723bu_init_bt(struct rtl8xxxu_priv *priv)
 	/*
 	 * Software control, antenna at WiFi side
 	 */
-	rtl8723bu_set_ps_tdma(priv, 0x00, 0x00, 0x00, 0x00, 0x00);
+	rtl8723bu_set_ps_tdma(priv, 0x08, 0x00, 0x00, 0x00, 0x00);
 
 	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x55555555);
 	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0x5a5a5a5a);
-- 
2.5.0

