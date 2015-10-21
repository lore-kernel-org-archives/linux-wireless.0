Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([5.9.2.179]:53635 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbbJUV3F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 17:29:05 -0400
From: Bruno Randolf <br1@einfach.org>
To: Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org
Cc: Bruno Randolf <br1@einfach.org>
Subject: [PATCH] rtl8xxxu: Enable data frame reception in rtl8xxxu_start
Date: Wed, 21 Oct 2015 22:28:52 +0100
Message-Id: <1445462932-23679-1-git-send-email-br1@einfach.org> (sfid-20151021_232911_754182_7DE0EB62)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 documentation says, the ieee80211_ops.start callback "must turn on
frame reception (for possibly enabled monitor interfaces.)". If not a single
monitor interface does not receive data frames.

Similarly we should not change the data reception based on the association
state.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 0399b1e..ae490e7 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -4475,9 +4475,6 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 			rtl8xxxu_update_rate_mask(priv, ramask, sgi);
 
-			/* Enable RX of data frames */
-			rtl8xxxu_write16(priv, REG_RXFLTMAP2, 0xffff);
-
 			rtl8xxxu_write8(priv, REG_BCN_MAX_ERR, 0xff);
 
 			rtl8723a_stop_tx_beacon(priv);
@@ -4492,8 +4489,6 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			val8 |= BEACON_DISABLE_TSF_UPDATE;
 			rtl8xxxu_write8(priv, REG_BEACON_CTRL, val8);
 
-			/* Disable RX of data frames */
-			rtl8xxxu_write16(priv, REG_RXFLTMAP2, 0x0000);
 			h2c.joinbss.data = H2C_JOIN_BSS_DISCONNECT;
 		}
 		h2c.joinbss.cmd = H2C_JOIN_BSS_REPORT;
@@ -5495,12 +5490,9 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 	}
 exit:
 	/*
-	 * Disable all data frames
-	 */
-	rtl8xxxu_write16(priv, REG_RXFLTMAP2, 0x0000);
-	/*
-	 * Accept all mgmt frames
+	 * Accept all data and mgmt frames
 	 */
+	rtl8xxxu_write16(priv, REG_RXFLTMAP2, 0xffff);
 	rtl8xxxu_write16(priv, REG_RXFLTMAP0, 0xffff);
 
 	rtl8xxxu_write32(priv, REG_OFDM0_XA_AGC_CORE1, 0x6954341e);
-- 
1.9.1

