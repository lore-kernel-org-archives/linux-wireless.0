Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933813AbcBCSkE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Bruno Randolf <br1@einfach.org>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 17/28] rtl8xxxu: Enable monitor mode by handling filters
Date: Wed,  3 Feb 2016 13:39:51 -0500
Message-Id: <1454524802-26763-18-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194730_110675_6F1676A2)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bruno Randolf <br1@einfach.org>

Monitor mode is enabled by handling the filter flags we get from mac80211 in
rtl8xxxu_configure_filter() and writing them to the RCR register.

By handling the filters, we can also stop setting the BSSID filters in the
association event.

Signed-off-by: Bruno Randolf <br1@einfach.org>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 56 +++++++++++++++++++-----
 1 file changed, 45 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index ac4c211..b58a60f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -4199,7 +4199,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	 * Configure initial WMAC settings
 	 */
 	val32 = RCR_ACCEPT_PHYS_MATCH | RCR_ACCEPT_MCAST | RCR_ACCEPT_BCAST |
-		/* RCR_CHECK_BSSID_MATCH | RCR_CHECK_BSSID_BEACON | */
 		RCR_ACCEPT_MGMT_FRAME | RCR_HTC_LOC_CTRL |
 		RCR_APPEND_PHYSTAT | RCR_APPEND_ICV | RCR_APPEND_MIC;
 	rtl8xxxu_write32(priv, REG_RCR, val32);
@@ -4522,10 +4521,6 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 			rtl8xxxu_update_rate_mask(priv, ramask, sgi);
 
-			val32 = rtl8xxxu_read32(priv, REG_RCR);
-			val32 |= RCR_CHECK_BSSID_MATCH | RCR_CHECK_BSSID_BEACON;
-			rtl8xxxu_write32(priv, REG_RCR, val32);
-
 			/* Enable RX of data frames */
 			rtl8xxxu_write16(priv, REG_RXFLTMAP2, 0xffff);
 
@@ -4539,11 +4534,6 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 			h2c.joinbss.data = H2C_JOIN_BSS_CONNECT;
 		} else {
-			val32 = rtl8xxxu_read32(priv, REG_RCR);
-			val32 &= ~(RCR_CHECK_BSSID_MATCH |
-				   RCR_CHECK_BSSID_BEACON);
-			rtl8xxxu_write32(priv, REG_RCR, val32);
-
 			val8 = rtl8xxxu_read8(priv, REG_BEACON_CTRL);
 			val8 |= BEACON_DISABLE_TSF_UPDATE;
 			rtl8xxxu_write8(priv, REG_BEACON_CTRL, val8);
@@ -5318,11 +5308,55 @@ static void rtl8xxxu_configure_filter(struct ieee80211_hw *hw,
 				      unsigned int *total_flags, u64 multicast)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
+	u32 rcr = rtl8xxxu_read32(priv, REG_RCR);
 
 	dev_dbg(&priv->udev->dev, "%s: changed_flags %08x, total_flags %08x\n",
 		__func__, changed_flags, *total_flags);
 
-	*total_flags &= (FIF_ALLMULTI | FIF_CONTROL | FIF_BCN_PRBRESP_PROMISC);
+	/*
+	 * FIF_ALLMULTI ignored as all multicast frames are accepted (REG_MAR)
+	 */
+
+	if (*total_flags & FIF_FCSFAIL)
+		rcr |= RCR_ACCEPT_CRC32;
+	else
+		rcr &= ~RCR_ACCEPT_CRC32;
+
+	/*
+	 * FIF_PLCPFAIL not supported?
+	 */
+
+	if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
+		rcr &= ~RCR_CHECK_BSSID_BEACON;
+	else
+		rcr |= RCR_CHECK_BSSID_BEACON;
+
+	if (*total_flags & FIF_CONTROL)
+		rcr |= RCR_ACCEPT_CTRL_FRAME;
+	else
+		rcr &= ~RCR_ACCEPT_CTRL_FRAME;
+
+	if (*total_flags & FIF_OTHER_BSS) {
+		rcr |= RCR_ACCEPT_AP;
+		rcr &= ~RCR_CHECK_BSSID_MATCH;
+	} else {
+		rcr &= ~RCR_ACCEPT_AP;
+		rcr |= RCR_CHECK_BSSID_MATCH;
+	}
+
+	if (*total_flags & FIF_PSPOLL)
+		rcr |= RCR_ACCEPT_PM;
+	else
+		rcr &= ~RCR_ACCEPT_PM;
+
+	/*
+	 * FIF_PROBE_REQ ignored as probe requests always seem to be accepted
+	 */
+
+	rtl8xxxu_write32(priv, REG_RCR, rcr);
+
+	*total_flags &= (FIF_ALLMULTI | FIF_FCSFAIL | FIF_BCN_PRBRESP_PROMISC | \
+			 FIF_CONTROL | FIF_OTHER_BSS | FIF_PSPOLL | FIF_PROBE_REQ);
 }
 
 static int rtl8xxxu_set_rts_threshold(struct ieee80211_hw *hw, u32 rts)
-- 
2.5.0

