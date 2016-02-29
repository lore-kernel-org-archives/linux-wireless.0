Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbcB2WF5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:57 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 087/113] rtl8xxxu: Set the correct thermal meter register for 8723bu
Date: Mon, 29 Feb 2016 17:05:25 -0500
Message-Id: <1456783551-28315-88-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230800_216523_9F6C4F83)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Older chips use RF register 0x24 to set the thermal meter. Newer chips
use register 0x42.

This change makes sure to set the correct thermal meter register
depending on the chip.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index cca3b92..6825351 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6502,7 +6502,11 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	/*
 	 * This should enable thermal meter
 	 */
-	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_T_METER, 0x60);
+	if (priv->fops->has_s0s1)
+		rtl8xxxu_write_rfreg(priv,
+				     RF_A, RF6052_REG_T_METER_8723B, 0x37cf8);
+	else
+		rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_T_METER, 0x60);
 
 	/* Init BT hw config. */
 	if (priv->fops->init_bt)
-- 
2.5.0

