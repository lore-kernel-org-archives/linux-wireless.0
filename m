Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([5.9.2.179]:44933 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbbJTLwD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 07:52:03 -0400
From: Bruno Randolf <br1@einfach.org>
To: Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org
Cc: Bruno Randolf <br1@einfach.org>
Subject: [PATCH 1/2] rtl8xxxu: Enable monitor mode by handling filters
Date: Tue, 20 Oct 2015 12:51:48 +0100
Message-Id: <1445341909-28053-1-git-send-email-br1@einfach.org> (sfid-20151020_135211_059674_381C44A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Monitor mode is enabled by handling the filter flags we get from mac80211 in
rtl8xxxu_configure_filter() and writing them to the RCR register.

By handling these filters correctly we can also stop setting the BSSID filters
in the association event.

Also remove initial setting of the RCR register from rtl8723a_mac_init_table.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 58 +++++++++++++++++++-----
 1 file changed, 46 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 11fcfda..3b5a885 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -143,7 +143,7 @@ static struct rtl8xxxu_reg8val rtl8723a_mac_init_table[] = {
 	{0x515, 0x10}, {0x516, 0x0a}, {0x517, 0x10}, {0x51a, 0x16},
 	{0x524, 0x0f}, {0x525, 0x4f}, {0x546, 0x40}, {0x547, 0x00},
 	{0x550, 0x10}, {0x551, 0x10}, {0x559, 0x02}, {0x55a, 0x02},
-	{0x55d, 0xff}, {0x605, 0x30}, {0x608, 0x0e}, {0x609, 0x2a},
+	{0x55d, 0xff}, {0x605, 0x30},
 	{0x652, 0x20}, {0x63c, 0x0a}, {0x63d, 0x0a}, {0x63e, 0x0e},
 	{0x63f, 0x0e}, {0x66e, 0x05}, {0x700, 0x21}, {0x701, 0x43},
 	{0x702, 0x65}, {0x703, 0x87}, {0x708, 0x21}, {0x709, 0x43},
@@ -4143,7 +4143,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	 * Configure initial WMAC settings
 	 */
 	val32 = RCR_ACCEPT_PHYS_MATCH | RCR_ACCEPT_MCAST | RCR_ACCEPT_BCAST |
-		/* RCR_CHECK_BSSID_MATCH | RCR_CHECK_BSSID_BEACON | */
 		RCR_ACCEPT_MGMT_FRAME | RCR_HTC_LOC_CTRL |
 		RCR_APPEND_PHYSTAT | RCR_APPEND_ICV | RCR_APPEND_MIC;
 	rtl8xxxu_write32(priv, REG_RCR, val32);
@@ -4476,10 +4475,6 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 			rtl8xxxu_update_rate_mask(priv, ramask, sgi);
 
-			val32 = rtl8xxxu_read32(priv, REG_RCR);
-			val32 |= RCR_CHECK_BSSID_MATCH | RCR_CHECK_BSSID_BEACON;
-			rtl8xxxu_write32(priv, REG_RCR, val32);
-
 			/* Enable RX of data frames */
 			rtl8xxxu_write16(priv, REG_RXFLTMAP2, 0xffff);
 
@@ -4493,11 +4488,6 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
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
@@ -5272,11 +5262,55 @@ static void rtl8xxxu_configure_filter(struct ieee80211_hw *hw,
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
1.9.1

