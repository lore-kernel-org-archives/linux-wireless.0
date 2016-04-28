Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbcD1TTR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2016 15:19:17 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 08/11] rtl8xxxu: Rename rtl8723a_disabled_to_emu() to rtl8xxxu_disabled_to_emu()
Date: Thu, 28 Apr 2016 15:19:12 -0400
Message-Id: <1461871155-11826-9-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160428_211926_857181_5FA80D01)
In-Reply-To: <1461871155-11826-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1461871155-11826-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This function is generic to most of the chips, so change the name to
reflect this.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h       | 2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c | 2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index d532933..f773c0e 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1392,7 +1392,7 @@ void rtl8xxxu_prepare_calibrate(struct rtl8xxxu_priv *priv, u8 start);
 int rtl8xxxu_flush_fifo(struct rtl8xxxu_priv *priv);
 int rtl8723a_h2c_cmd(struct rtl8xxxu_priv *priv, struct h2c_cmd *h2c, int len);
 int rtl8xxxu_active_to_lps(struct rtl8xxxu_priv *priv);
-void rtl8723a_disabled_to_emu(struct rtl8xxxu_priv *priv);
+void rtl8xxxu_disabled_to_emu(struct rtl8xxxu_priv *priv);
 int rtl8xxxu_init_llt_table(struct rtl8xxxu_priv *priv, u8 last_tx_page);
 void rtl8xxxu_gen1_phy_iq_calibrate(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_gen1_init_phy_bb(struct rtl8xxxu_priv *priv);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
index b464e22..7c347ba 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
@@ -331,7 +331,7 @@ static int rtl8723au_power_on(struct rtl8xxxu_priv *priv)
 	 */
 	rtl8xxxu_write8(priv, REG_RSV_CTRL, 0x0);
 
-	rtl8723a_disabled_to_emu(priv);
+	rtl8xxxu_disabled_to_emu(priv);
 
 	ret = rtl8723a_emu_to_active(priv);
 	if (ret)
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
index 7d06dca..a711cb8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
@@ -1406,7 +1406,7 @@ static int rtl8723bu_power_on(struct rtl8xxxu_priv *priv)
 	u32 val32;
 	int ret;
 
-	rtl8723a_disabled_to_emu(priv);
+	rtl8xxxu_disabled_to_emu(priv);
 
 	ret = rtl8723b_emu_to_active(priv);
 	if (ret)
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 9b12aed..d71a0c6 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -3607,7 +3607,7 @@ exit:
 	return ret;
 }
 
-void rtl8723a_disabled_to_emu(struct rtl8xxxu_priv *priv)
+void rtl8xxxu_disabled_to_emu(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
 
-- 
2.5.5

