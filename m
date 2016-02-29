Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbcB2WFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:55 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 064/113] rtl8xxxu: Set RX boundary for 8723bu
Date: Mon, 29 Feb 2016 17:05:02 -0500
Message-Id: <1456783551-28315-65-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230850_393889_1525F9EE)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Set the correct TRXFF boundary for 8723bu.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 3a7fd2c..835eca8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6182,7 +6182,10 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	/*
 	 * Set RX page boundary
 	 */
-	rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x27ff);
+	if (priv->rtlchip == 0x8723b)
+		rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x3f7f);
+	else
+		rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x27ff);
 	/*
 	 * Transfer page size is always 128
 	 */
-- 
2.5.0

