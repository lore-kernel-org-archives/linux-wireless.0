Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41520 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752558AbcKRVoa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 16:44:30 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 3/7] rtl8xxxu: Fix rtl8723bu driver reload issue
Date: Fri, 18 Nov 2016 16:44:24 -0500
Message-Id: <1479505468-29383-4-git-send-email-Jes.Sorensen@redhat.com> (sfid-20161118_224435_233137_5138C858)
In-Reply-To: <1479505468-29383-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1479505468-29383-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The generic disable_rf() function clears bits 22 and 23 in
REG_RX_WAIT_CCA, however we did not re-enable them again in
rtl8723b_enable_rf()

This resolves the problem for me with 8723bu devices not working again
after reloading the driver.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
index 6c086b5..02b8ddd 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
@@ -1498,6 +1498,10 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
 	u32 val32;
 	u8 val8;
 
+	val32 = rtl8xxxu_read32(priv, REG_RX_WAIT_CCA);
+	val32 |= (BIT(22) | BIT(23));
+	rtl8xxxu_write32(priv, REG_RX_WAIT_CCA, val32);
+
 	/*
 	 * No indication anywhere as to what 0x0790 does. The 2 antenna
 	 * vendor code preserves bits 6-7 here.
-- 
2.7.4
