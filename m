Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36320 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964837AbbC0PWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2015 11:22:54 -0400
Received: by padcy3 with SMTP id cy3so98529805pad.3
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2015 08:22:54 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net, ap420073@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Add encryption argument in rtl_is_special_data for checking DHCP packet.
Date: Sat, 28 Mar 2015 00:22:39 +0900
Message-Id: <1427469759-21549-1-git-send-email-ap420073@gmail.com> (sfid-20150327_162258_288718_66BE7292)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtl8192cu can't connect to AP after physical reconnect.
according to dmesg, that problem's cause was DHCP timeout.

rtl_is_special_data function checks packet type for adjusting rate.
when that function is called from _rtl_rc_get_highest_rix, it can not
calculate offset correctly. so i add argument is_encn in rtl_is_special_data.
is_enc variable mean that iv header is added in skb parameter.

i test only rtl8192cu chipset. because i doesn't have other rtlwifi chipsets.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/base.c | 7 +++++--
 drivers/net/wireless/rtlwifi/base.h | 3 ++-
 drivers/net/wireless/rtlwifi/pci.c  | 2 +-
 drivers/net/wireless/rtlwifi/rc.c   | 5 +++--
 4 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index 074f716..01f56c7 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -1315,7 +1315,8 @@ static void setup_arp_tx(struct rtl_priv *rtlpriv, struct rtl_ps_ctl *ppsc)
 }
 
 /*should call before software enc*/
-u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
+u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx,
+		       bool is_enc)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
@@ -1344,7 +1345,9 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 		break;
 	}
 
-	offset = mac_hdr_len + SNAP_SIZE + encrypt_header_len;
+	offset = mac_hdr_len + SNAP_SIZE;
+	if (is_enc)
+		offset += encrypt_header_len;
 	ether_type = be16_to_cpup((__be16 *)(skb->data + offset));
 
 	if (ETH_P_IP == ether_type) {
diff --git a/drivers/net/wireless/rtlwifi/base.h b/drivers/net/wireless/rtlwifi/base.h
index ff9a4bf..74233d6 100644
--- a/drivers/net/wireless/rtlwifi/base.h
+++ b/drivers/net/wireless/rtlwifi/base.h
@@ -120,7 +120,8 @@ bool rtl_action_proc(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx);
 int rtlwifi_rate_mapping(struct ieee80211_hw *hw, bool isht,
 			 bool isvht, u8 desc_rate);
 bool rtl_tx_mgmt_proc(struct ieee80211_hw *hw, struct sk_buff *skb);
-u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx);
+u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx,
+		       bool is_enc);
 
 void rtl_beacon_statistic(struct ieee80211_hw *hw, struct sk_buff *skb);
 int rtl_tx_agg_start(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 8c45cf4..f46c9d7 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -887,7 +887,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 				unicast = true;
 				rtlpriv->stats.rxbytesunicast += skb->len;
 			}
-			rtl_is_special_data(hw, skb, false);
+			rtl_is_special_data(hw, skb, false, true);
 
 			if (ieee80211_is_data(fc)) {
 				rtlpriv->cfg->ops->led_control(hw, LED_CTL_RX);
diff --git a/drivers/net/wireless/rtlwifi/rc.c b/drivers/net/wireless/rtlwifi/rc.c
index 7863bd2..74c14ce 100644
--- a/drivers/net/wireless/rtlwifi/rc.c
+++ b/drivers/net/wireless/rtlwifi/rc.c
@@ -56,7 +56,8 @@ static u8 _rtl_rc_get_highest_rix(struct rtl_priv *rtlpriv,
 		wireless_mode = sta_entry->wireless_mode;
 	}
 
-	if (rtl_is_special_data(rtlpriv->mac80211.hw, skb, true) || not_data) {
+	if (rtl_is_special_data(rtlpriv->mac80211.hw, skb, true, false) ||
+	    not_data) {
 		return 0;
 	} else {
 		if (rtlhal->current_bandtype == BAND_ON_2_4G) {
@@ -201,7 +202,7 @@ static void rtl_tx_status(void *ppriv,
 	if (!priv_sta || !ieee80211_is_data(fc))
 		return;
 
-	if (rtl_is_special_data(mac->hw, skb, true))
+	if (rtl_is_special_data(mac->hw, skb, true, true))
 		return;
 
 	if (is_multicast_ether_addr(ieee80211_get_DA(hdr)) ||
-- 
1.9.1

