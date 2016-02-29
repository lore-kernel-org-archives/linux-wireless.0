Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbcB2WF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:56 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 075/113] rtl8xxxu: 8723bu: REG_BT_COEX_TABLE4 is only 8 bits
Date: Mon, 29 Feb 2016 17:05:13 -0500
Message-Id: <1456783551-28315-76-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232953_399585_9AD67716)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The BT_COEX_TABLE register list contains 3 32 bit registers and one 8
bit register. Hence, use rtl8xxxu_write8() when writing the 8 bit
register.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index b4660c6..690e31d 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5954,7 +5954,7 @@ static void rtl8723bu_init_bt(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x55555555);
 	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0x5a5a5a5a);
 	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
-	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE4, 0x00000003);
+	rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
 
 	memset(&h2c, 0, sizeof(struct h2c_cmd));
 	h2c.ignore_wlan.cmd = H2C_8723B_BT_IGNORE_WLANACT;
-- 
2.5.0

