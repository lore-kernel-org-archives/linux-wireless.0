Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12015 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab2GKTcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 15:32:36 -0400
Date: Wed, 11 Jul 2012 14:32:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Remove extra argument from queue setup routine
Message-ID: <4ffdd4d1.Iwl3XOvFMQ8PM7Bc%Larry.Finger@lwfinger.net> (sfid-20120711_213240_810221_79CF31CD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unused argument hw from call to rtl_tid_to_ac().

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

More 3.6 material.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/base.c
@@ -167,7 +167,7 @@ static const u8 tid_to_ac[] = {
 	0, /* IEEE80211_AC_VO */
 };
 
-u8 rtl_tid_to_ac(struct ieee80211_hw *hw, u8 tid)
+u8 rtl_tid_to_ac(u8 tid)
 {
 	return tid_to_ac[tid];
 }
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/base.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/base.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/base.h
@@ -138,7 +138,7 @@ int rtl_send_smps_action(struct ieee8021
 		enum ieee80211_smps_mode smps);
 u8 *rtl_find_ie(u8 *data, unsigned int len, u8 ie);
 void rtl_recognize_peer(struct ieee80211_hw *hw, u8 *data, unsigned int len);
-u8 rtl_tid_to_ac(struct ieee80211_hw *hw, u8 tid);
+u8 rtl_tid_to_ac(u8 tid);
 extern struct attribute_group rtl_attribute_group;
 int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
 			 bool isht, u8 desc_rate, bool first_ampdu);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
@@ -480,7 +480,7 @@ static void _rtl_pci_tx_chk_waitq(struct
 
 	/* we juse use em for BE/BK/VI/VO */
 	for (tid = 7; tid >= 0; tid--) {
-		u8 hw_queue = ac_to_hwq[rtl_tid_to_ac(hw, tid)];
+		u8 hw_queue = ac_to_hwq[rtl_tid_to_ac(tid)];
 		struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[hw_queue];
 		while (!mac->act_scanning &&
 		       rtlpriv->psc.rfpwr_state == ERFON) {
