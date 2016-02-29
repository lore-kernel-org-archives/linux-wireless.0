Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbcB2WFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:54 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 039/113] rtl8xxxu: Do LC calibration before IQK calibration
Date: Mon, 29 Feb 2016 17:04:37 -0500
Message-Id: <1456783551-28315-40-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230626_683505_E270ED50)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This matches the flow of the vendor driver for newer hardware, and
doesn't seem to cause issues for the older parts.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index c990a09..a8385c7 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5803,6 +5803,8 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 
 	rtl8xxxu_write16(priv, REG_FAST_EDCA_CTRL, 0);
 
+	rtl8723a_phy_lc_calibrate(priv);
+
 	priv->fops->phy_iq_calibrate(priv);
 
 	/*
@@ -5810,8 +5812,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	 */
 	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_T_METER, 0x60);
 
-	rtl8723a_phy_lc_calibrate(priv);
-
 	/* Init BT hw config. */
 	rtl8xxxu_init_bt(priv);
 
-- 
2.5.0

