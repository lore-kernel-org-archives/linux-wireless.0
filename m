Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbcB2WGD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 067/113] rtl8xxxu: 8723bu lock phy after RF init
Date: Mon, 29 Feb 2016 17:05:05 -0500
Message-Id: <1456783551-28315-68-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232951_112666_F25D54CA)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Set PHY lock after running the RF init sequence on 8723bu.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 566eeb5..566159e 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6093,6 +6093,13 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	case 0x8723b:
 		rftable = rtl8723bu_radioa_1t_init_table;
 		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
+		/*
+		 * PHY LCK
+		 */
+		rtl8xxxu_write_rfreg(priv, RF_A, 0xb0, 0xdfbe0);
+		rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_MODE_AG, 0x8c01);
+		msleep(200);
+		rtl8xxxu_write_rfreg(priv, RF_A, 0xb0, 0xdffe0);
 		break;
 	case 0x8188c:
 		if (priv->hi_pa)
-- 
2.5.0

