Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbcD1TTR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2016 15:19:17 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 06/11] rtl8xxxu: Rename rtl8723a_stop_tx_beacon() to rtl8xxxu_stop_tx_beacon()
Date: Thu, 28 Apr 2016 15:19:10 -0400
Message-Id: <1461871155-11826-7-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160428_211933_649285_D511963B)
In-Reply-To: <1461871155-11826-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1461871155-11826-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

There is nothing 8723au specific about this function, so rename it to
reflect this.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index f035d15..34f94bb 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1029,8 +1029,7 @@ void rtl8xxxu_gen1_disable_rf(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write8(priv, REG_SPS0_CTRL, sps0);
 }
 
-
-static void rtl8723a_stop_tx_beacon(struct rtl8xxxu_priv *priv)
+static void rtl8xxxu_stop_tx_beacon(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
 
@@ -4440,7 +4439,7 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 			rtl8xxxu_write8(priv, REG_BCN_MAX_ERR, 0xff);
 
-			rtl8723a_stop_tx_beacon(priv);
+			rtl8xxxu_stop_tx_beacon(priv);
 
 			/* joinbss sequence */
 			rtl8xxxu_write16(priv, REG_BCN_PSR_RPT,
@@ -5276,7 +5275,7 @@ static int rtl8xxxu_add_interface(struct ieee80211_hw *hw,
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
-		rtl8723a_stop_tx_beacon(priv);
+		rtl8xxxu_stop_tx_beacon(priv);
 
 		val8 = rtl8xxxu_read8(priv, REG_BEACON_CTRL);
 		val8 |= BEACON_ATIM | BEACON_FUNCTION_ENABLE |
-- 
2.5.5

