Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34283 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933275AbcKMLi7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 13 Nov 2016 06:38:59 -0500
Received: by mail-pf0-f194.google.com with SMTP id y68so4640820pfb.1
        for <linux-wireless@vger.kernel.org>; Sun, 13 Nov 2016 03:38:59 -0800 (PST)
Date: Sun, 13 Nov 2016 21:17:09 +1000
From: Barry Day <briselec@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8xxxu: Fix failure to reconnect to AP
Message-ID: <20161113111705.GA2393@box64.home.org> (sfid-20161113_123904_945751_87999819)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rtl8192e and rtl8723 fail to reconnect to an AP after being
disconnected. Ths patch fixes that without affecting the rtl8192cu.
I don't have a rtl8723 to test but it has been tested on a rtl8192eu.
After going through the orginal realtek code for the rtl8723, I am
confident the patch is applicable to both.

Signed-off-by: Barry Day <briselec@gmail.com>
---
 rtl8xxxu_core.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/rtl8xxxu_core.c b/rtl8xxxu_core.c
index 04141e5..6ac10d2 100644
--- a/rtl8xxxu_core.c
+++ b/rtl8xxxu_core.c
@@ -4372,17 +4372,25 @@ void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
 void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
 				  u8 macid, bool connect)
 {
+	u8 val8;
 	struct h2c_cmd h2c;
 
 	memset(&h2c, 0, sizeof(struct h2c_cmd));
 
 	h2c.media_status_rpt.cmd = H2C_8723B_MEDIA_STATUS_RPT;
-	if (connect)
+	if (connect) {
 		h2c.media_status_rpt.parm |= BIT(0);
-	else
-		h2c.media_status_rpt.parm &= ~BIT(0);
+		rtl8xxxu_gen2_h2c_cmd(priv, &h2c,
+					sizeof(h2c.media_status_rpt));
+	} else {
+		val8 = rtl8xxxu_read8(priv, REG_BEACON_CTRL);
+		val8 &= ~BEACON_FUNCTION_ENABLE;
+
+		rtl8xxxu_write8(priv, REG_BEACON_CTRL, val8);
+		rtl8xxxu_write16(priv, REG_RXFLTMAP2, 0x00);
+		rtl8xxxu_write8(priv, REG_DUAL_TSF_RST, (BIT(0) | BIT(1)));
+	}
 
-	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.media_status_rpt));
 }
 
 void rtl8xxxu_gen1_init_aggregation(struct rtl8xxxu_priv *priv)
@@ -4515,6 +4523,8 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 				sgi = 1;
 			rcu_read_unlock();
 
+			rtl8xxxu_write16(priv, REG_RXFLTMAP2, 0xffff);
+
 			priv->fops->update_rate_mask(priv, ramask, sgi);
 
 			rtl8xxxu_write8(priv, REG_BCN_MAX_ERR, 0xff);
-- 
2.9.2
