Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 07/26] rtl8xxxu: Do not try to set REG_LEDCFG2 on 8192eu
Date: Thu, 14 Apr 2016 14:58:48 -0400
Message-Id: <1460660347-26299-8-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_212530_257320_1ACD0CAA)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Presumably 8192eu devices do not have leds, so do not enable them.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index ed8c594..99cf4aa 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7880,9 +7880,11 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	priv->fops->set_tx_power(priv, 1, false);
 
 	/* Let the 8051 take control of antenna setting */
-	val8 = rtl8xxxu_read8(priv, REG_LEDCFG2);
-	val8 |= LEDCFG2_DPDT_SELECT;
-	rtl8xxxu_write8(priv, REG_LEDCFG2, val8);
+	if (priv->rtl_chip != RTL8192E) {
+		val8 = rtl8xxxu_read8(priv, REG_LEDCFG2);
+		val8 |= LEDCFG2_DPDT_SELECT;
+		rtl8xxxu_write8(priv, REG_LEDCFG2, val8);
+	}
 
 	rtl8xxxu_write8(priv, REG_HWSEQ_CTRL, 0xff);
 
-- 
2.5.5

