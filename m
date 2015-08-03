Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:35502 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbbHCSyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 14:54:24 -0400
Received: by obbop1 with SMTP id op1so106256493obb.2
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2015 11:54:23 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, pkshih <pkshih@realtek.com>,
	shaofu <shaofu@realtek.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH NEXT 4/7] rtlwifi: Force disable key to wait until TX acked.
Date: Mon,  3 Aug 2015 13:53:49 -0500
Message-Id: <1438628032-5865-5-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150803_205428_016319_A2BDABEF)
In-Reply-To: <1438628032-5865-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1438628032-5865-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: pkshih <pkshih@realtek.com>

When connected, the drivers will use EAPOL to do PTK rekey. When msg 3/4 is
received, the supplicant will send msg 4/4 and install new key immediately.
However, the driver must make sure that msg 4/4 is sent before it installs
the new key. A new routine is created to ensure that msg 4/4 has been sent.

This patch modifies rtlwifi to support the new logic. Subsequent patches
will implement it in the drivers.

Signed-off-by: pkshih <pkshih@realtek.com>
Signed-off-by: shaofu <shaofu@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/base.c  | 183 ++++++++++++++++++++++++++++-------
 drivers/net/wireless/rtlwifi/base.h  |   7 ++
 drivers/net/wireless/rtlwifi/core.c  |   3 +
 drivers/net/wireless/rtlwifi/debug.h |   1 +
 drivers/net/wireless/rtlwifi/wifi.h  |   9 ++
 5 files changed, 168 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index 0517a4f..01a6ed4 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -1105,6 +1105,9 @@ void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 	if (txrate)
 		tcb_desc->hw_rate = txrate->hw_value;
 
+	if (rtl_is_tx_report_skb(hw, skb))
+		tcb_desc->use_spe_rpt = 1;
+
 	if (ieee80211_is_data(fc)) {
 		/*
 		 *we set data rate INX 0
@@ -1312,45 +1315,69 @@ static void setup_arp_tx(struct rtl_priv *rtlpriv, struct rtl_ps_ctl *ppsc)
 	ppsc->last_delaylps_stamp_jiffies = jiffies;
 }
 
-/*should call before software enc*/
-u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx,
-		       bool is_enc)
+static const u8 *rtl_skb_ether_type_ptr(struct ieee80211_hw *hw,
+					struct sk_buff *skb,
+					bool with_encrypt_header)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	u8 mac_hdr_len = ieee80211_get_hdrlen_from_skb(skb);
+	u8 encrypt_header_len = 0;
+
+	if (with_encrypt_header && mac->link_state >= MAC80211_LINKED) {
+		switch (rtlpriv->sec.pairwise_enc_algorithm) {
+		case WEP40_ENCRYPTION:
+		case WEP104_ENCRYPTION:
+			encrypt_header_len = 4;/*WEP_IV_LEN*/
+			break;
+		case TKIP_ENCRYPTION:
+			encrypt_header_len = 8;/*TKIP_IV_LEN*/
+			break;
+		case AESCCMP_ENCRYPTION:
+			encrypt_header_len = 8;/*CCMP_HDR_LEN;*/
+			break;
+		default:
+			RT_TRACE(rtlpriv, (COMP_SEND | COMP_RECV),
+				 DBG_LOUD, "encrypt not set!\n");
+			break;
+		}
+	}
+
+	return skb->data + mac_hdr_len + SNAP_SIZE + encrypt_header_len;
+}
+
+/* This function is called by 3 routines:
+ * 1.RX
+ * 2.rtl_tx_status
+ * 3._rtl_rc_get_highest_rix
+ *
+ * 1 and 2 have encryption header
+ * 3 does not
+ *
+ * data in 2 and 3 are same.
+ *
+ * if we return false to _rtl_rc_get_highest_rix(), this will cause the rate
+ * to be too high when EAPOL. After a while, the connection will fail
+ */
+
+u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb,
+			u8 is_tx, bool with_encrypt_header)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	__le16 fc = rtl_get_fc(skb);
 	u16 ether_type;
-	u8 mac_hdr_len = ieee80211_get_hdrlen_from_skb(skb);
-	u8 encrypt_header_len = 0;
-	u8 offset;
+	const u8 *ether_type_ptr;
 	const struct iphdr *ip;
 
 	if (!ieee80211_is_data(fc))
 		goto end;
 
-	switch (rtlpriv->sec.pairwise_enc_algorithm) {
-	case WEP40_ENCRYPTION:
-	case WEP104_ENCRYPTION:
-		encrypt_header_len = 4;/*WEP_IV_LEN*/
-		break;
-	case TKIP_ENCRYPTION:
-		encrypt_header_len = 8;/*TKIP_IV_LEN*/
-		break;
-	case AESCCMP_ENCRYPTION:
-		encrypt_header_len = 8;/*CCMP_HDR_LEN;*/
-		break;
-	default:
-		break;
-	}
-
-	offset = mac_hdr_len + SNAP_SIZE;
-	if (is_enc)
-		offset += encrypt_header_len;
-	ether_type = be16_to_cpup((__be16 *)(skb->data + offset));
+	ether_type_ptr = rtl_skb_ether_type_ptr(hw, skb, with_encrypt_header);
+	ether_type = be16_to_cpup((__be16 *)ether_type_ptr);
 
 	if (ETH_P_IP == ether_type) {
-		ip = (struct iphdr *)((u8 *)skb->data + offset +
-		     PROTOC_TYPE_SIZE);
+		ip = (struct iphdr *)((u8 *)ether_type_ptr + PROTOC_TYPE_SIZE);
 		if (IPPROTO_UDP == ip->protocol) {
 			struct udphdr *udp = (struct udphdr *)((u8 *)ip +
 							       (ip->ihl << 2));
@@ -1361,37 +1388,43 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx,
 				/* 68 : UDP BOOTP client
 				 * 67 : UDP BOOTP server
 				 */
+				if (!with_encrypt_header)
+					return true;
+
 				RT_TRACE(rtlpriv, (COMP_SEND | COMP_RECV),
 					 DBG_DMESG, "dhcp %s !!\n",
 					 (is_tx) ? "Tx" : "Rx");
 
 				if (is_tx)
 					setup_arp_tx(rtlpriv, ppsc);
+
 				return true;
 			}
 		}
 	} else if (ETH_P_ARP == ether_type) {
+		if (!with_encrypt_header)
+			return true;
+
 		if (is_tx)
 			setup_arp_tx(rtlpriv, ppsc);
-
+		RT_TRACE(rtlpriv, (COMP_SEND | COMP_RECV),
+			 DBG_DMESG, "ARP %s !!\n", (is_tx) ? "Tx" : "Rx");
 		return true;
 	} else if (ETH_P_PAE == ether_type) {
+		if (!with_encrypt_header)
+			return true;
 		RT_TRACE(rtlpriv, (COMP_SEND | COMP_RECV), DBG_DMESG,
 			 "802.1X %s EAPOL pkt!!\n", (is_tx) ? "Tx" : "Rx");
 
 		if (is_tx) {
 			rtlpriv->ra.is_special_data = true;
-			rtlpriv->enter_ps = false;
-			schedule_work(&rtlpriv->works.lps_change_work);
+			rtl_lps_leave(hw);
 			ppsc->last_delaylps_stamp_jiffies = jiffies;
 		}
 
 		return true;
-	} else if (ETH_P_IPV6 == ether_type) {
-		/* TODO: Handle any IPv6 cases that need special handling.
-		 * For now, always return false
-		 */
-		goto end;
+	} else if (0x86DD == ether_type) {
+		return true;
 	}
 
 end:
@@ -1400,6 +1433,86 @@ end:
 }
 EXPORT_SYMBOL_GPL(rtl_is_special_data);
 
+bool rtl_is_tx_report_skb(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	u16 ether_type;
+	const u8 *ether_type_ptr;
+
+	ether_type_ptr = rtl_skb_ether_type_ptr(hw, skb, true);
+	ether_type = be16_to_cpup((__be16 *)ether_type_ptr);
+
+	/* EAPOL */
+	if (ETH_P_PAE == ether_type)
+		return true;
+
+	return false;
+}
+
+u16 rtl_get_tx_report_sn(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_tx_report *tx_report = &rtlpriv->tx_report;
+	u16 sn;
+
+	sn = atomic_inc_return(&tx_report->sn) & 0x0FFF;
+
+	tx_report->last_sent_sn = sn;
+	tx_report->last_sent_time = jiffies;
+
+	RT_TRACE(rtlpriv, COMP_TX_REPORT, DBG_DMESG,
+		 "Send TX-Report sn=0x%X\n", sn);
+
+	return sn;
+}
+EXPORT_SYMBOL_GPL(rtl_get_tx_report_sn);
+
+void rtl_tx_report_handler(struct ieee80211_hw *hw, u8 *tmp_buf, u8 c2h_cmd_len)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_tx_report *tx_report = &rtlpriv->tx_report;
+	u16 sn;
+
+	sn = ((tmp_buf[7] & 0x0F) << 8) | tmp_buf[6];
+
+	tx_report->last_recv_sn = sn;
+
+	RT_TRACE(rtlpriv, COMP_TX_REPORT, DBG_DMESG,
+		 "Recv TX-Report st=0x%02X sn=0x%X retry=0x%X\n",
+		 tmp_buf[0], sn, tmp_buf[2]);
+}
+EXPORT_SYMBOL_GPL(rtl_tx_report_handler);
+
+bool rtl_check_tx_report_acked(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_tx_report *tx_report = &rtlpriv->tx_report;
+
+	if (tx_report->last_sent_sn == tx_report->last_recv_sn)
+		return true;
+
+	if (time_before(tx_report->last_sent_time + 3 * HZ, jiffies)) {
+		RT_TRACE(rtlpriv, COMP_TX_REPORT, DBG_WARNING,
+			 "Check TX-Report timeout!!\n");
+		return true;	/* 3 sec. (timeout) seen as acked */
+	}
+
+	return false;
+}
+
+void rtl_wait_tx_report_acked(struct ieee80211_hw *hw, u32 wait_ms)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int i;
+
+	for (i = 0; i < wait_ms; i++) {
+		if (rtl_check_tx_report_acked(hw))
+			break;
+		usleep_range(1000, 1500);
+		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
+			 "Wait 1ms (%d/%d) to disable key.\n", i, wait_ms);
+	}
+}
+
 /*********************************************************
  *
  * functions called by core.c
diff --git a/drivers/net/wireless/rtlwifi/base.h b/drivers/net/wireless/rtlwifi/base.h
index 74233d6..05a69f7 100644
--- a/drivers/net/wireless/rtlwifi/base.h
+++ b/drivers/net/wireless/rtlwifi/base.h
@@ -123,6 +123,13 @@ bool rtl_tx_mgmt_proc(struct ieee80211_hw *hw, struct sk_buff *skb);
 u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx,
 		       bool is_enc);
 
+bool rtl_is_tx_report_skb(struct ieee80211_hw *hw, struct sk_buff *skb);
+u16 rtl_get_tx_report_sn(struct ieee80211_hw *hw);
+void rtl_tx_report_handler(struct ieee80211_hw *hw, u8 *tmp_buf,
+			   u8 c2h_cmd_len);
+bool rtl_check_tx_report_acked(struct ieee80211_hw *hw);
+void rtl_wait_tx_report_acked(struct ieee80211_hw *hw, u32 wait_ms);
+
 void rtl_beacon_statistic(struct ieee80211_hw *hw, struct sk_buff *skb);
 int rtl_tx_agg_start(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct ieee80211_sta *sta, u16 tid, u16 *ssn);
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 19729ed..086c1ad 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -1671,6 +1671,9 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		 *so don't use rtl_cam_reset_all_entry
 		 *or clear all entry here.
 		 */
+		key_idx = key->keyidx;
+
+		rtl_wait_tx_report_acked(hw, 500); /* wait 500ms for TX ack */
 		rtl_cam_delete_one_entry(hw, mac_addr, key_idx);
 		break;
 	default:
diff --git a/drivers/net/wireless/rtlwifi/debug.h b/drivers/net/wireless/rtlwifi/debug.h
index fc794b3..e23f2d5 100644
--- a/drivers/net/wireless/rtlwifi/debug.h
+++ b/drivers/net/wireless/rtlwifi/debug.h
@@ -105,6 +105,7 @@
 #define COMP_EASY_CONCURRENT	COMP_USB /* reuse of this bit is OK */
 #define COMP_BT_COEXIST			BIT(30)
 #define COMP_IQK			BIT(31)
+#define COMP_TX_REPORT			BIT_ULL(32)
 
 /*--------------------------------------------------------------
 		Define the rt_print components
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 2b770b5..ca734bb 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1860,6 +1860,13 @@ struct rtl_efuse {
 	u8 channel_plan;
 };
 
+struct rtl_tx_report {
+	atomic_t sn;
+	u16 last_sent_sn;
+	unsigned long last_sent_time;
+	u16 last_recv_sn;
+};
+
 struct rtl_ps_ctl {
 	bool pwrdomain_protect;
 	bool in_powersavemode;
@@ -2048,6 +2055,7 @@ struct rtl_tcb_desc {
 	u8 use_shortpreamble:1;
 	u8 use_driver_rate:1;
 	u8 disable_ratefallback:1;
+	u8 use_spe_rpt:1;
 
 	u8 ratr_index;
 	u8 mac_id;
@@ -2557,6 +2565,7 @@ struct rtl_priv {
 	struct rtl_dm dm;
 	struct rtl_security sec;
 	struct rtl_efuse efuse;
+	struct rtl_tx_report tx_report;
 
 	struct rtl_ps_ctl psc;
 	struct rate_adaptive ra;
-- 
2.1.4

