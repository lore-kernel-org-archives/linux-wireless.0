Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway24.websitewelcome.com ([192.185.51.202]:46977 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754212AbdJJTvH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 15:51:07 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id A09055C60
        for <linux-wireless@vger.kernel.org>; Tue, 10 Oct 2017 14:30:30 -0500 (CDT)
Date: Tue, 10 Oct 2017 14:30:27 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] rtl8xxxu: mark expected switch fall-throughs
Message-ID: <20171010193027.GA23108@embeddedor.com> (sfid-20171010_215115_280650_63E9C86E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Cc: Jes Sorensen <Jes.Sorensen@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 7806a4d..e66be05 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1153,6 +1153,7 @@ void rtl8xxxu_gen1_config_channel(struct ieee80211_hw *hw)
 	switch (hw->conf.chandef.width) {
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		ht = false;
+		/* fall through */
 	case NL80211_CHAN_WIDTH_20:
 		opmode |= BW_OPMODE_20MHZ;
 		rtl8xxxu_write8(priv, REG_BW_OPMODE, opmode);
@@ -1280,6 +1281,7 @@ void rtl8xxxu_gen2_config_channel(struct ieee80211_hw *hw)
 	switch (hw->conf.chandef.width) {
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		ht = false;
+		/* fall through */
 	case NL80211_CHAN_WIDTH_20:
 		rf_mode_bw |= WMAC_TRXPTCL_CTL_BW_20;
 		subchannel = 0;
@@ -1748,9 +1750,11 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 		case 3:
 			priv->ep_tx_low_queue = 1;
 			priv->ep_tx_count++;
+			/* fall through */
 		case 2:
 			priv->ep_tx_normal_queue = 1;
 			priv->ep_tx_count++;
+			/* fall through */
 		case 1:
 			priv->ep_tx_high_queue = 1;
 			priv->ep_tx_count++;
@@ -5691,6 +5695,7 @@ static int rtl8xxxu_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+		/* fall through */
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.7.4
