Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933812AbcBCSkE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Bruno Randolf <br1@einfach.org>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 21/28] rtl8xxxu: Enable data frame reception in rtl8xxxu_start
Date: Wed,  3 Feb 2016 13:39:55 -0500
Message-Id: <1454524802-26763-22-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194605_527823_DC6DF1DA)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bruno Randolf <br1@einfach.org>

mac80211 documentation says, the ieee80211_ops.start callback "must turn on
frame reception (for possibly enabled monitor interfaces.)". If not a single
monitor interface does not receive data frames.

Similarly we should not change the data reception based on the association
state.

Signed-off-by: Bruno Randolf <br1@einfach.org>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 9f89f62..1b7ff74 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -4521,9 +4521,6 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 			rtl8xxxu_update_rate_mask(priv, ramask, sgi);
 
-			/* Enable RX of data frames */
-			rtl8xxxu_write16(priv, REG_RXFLTMAP2, 0xffff);
-
 			rtl8xxxu_write8(priv, REG_BCN_MAX_ERR, 0xff);
 
 			rtl8723a_stop_tx_beacon(priv);
@@ -4538,8 +4535,6 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			val8 |= BEACON_DISABLE_TSF_UPDATE;
 			rtl8xxxu_write8(priv, REG_BEACON_CTRL, val8);
 
-			/* Disable RX of data frames */
-			rtl8xxxu_write16(priv, REG_RXFLTMAP2, 0x0000);
 			h2c.joinbss.data = H2C_JOIN_BSS_DISCONNECT;
 		}
 		h2c.joinbss.cmd = H2C_JOIN_BSS_REPORT;
@@ -5542,12 +5537,9 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
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
2.5.0

