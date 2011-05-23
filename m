Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42698 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab1EWBym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 21:54:42 -0400
Date: Sun, 22 May 2011 20:54:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/7 V2] rtl8192cu: Fix warnings from gcc 4.6.0
Message-ID: <4dd9be60.W4zb2+AA1nSw8fr0%Larry.Finger@lwfinger.net> (sfid-20110523_035445_688190_487B5C62)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc 4.6.0 warnings for rtl8192cu:

  CC [M]  drivers/net/wireless/rtlwifi/rtl8192cu/mac.o
drivers/net/wireless/rtlwifi/rtl8192cu/mac.c: In function ‘rtl92c_translate_rx_signal_stuff’:
drivers/net/wireless/rtlwifi/rtl8192cu/mac.c:1116:6: warning: variable ‘psaddr’ set but not used [-Wunused-but-set-variable]

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -1113,7 +1113,6 @@ void rtl92c_translate_rx_signal_stuff(st
 	struct ieee80211_hdr *hdr;
 	u8 *tmp_buf;
 	u8 *praddr;
-	u8 *psaddr;
 	__le16 fc;
 	u16 type, cpu_fc;
 	bool packet_matchbssid, packet_toself, packet_beacon;
@@ -1124,7 +1123,6 @@ void rtl92c_translate_rx_signal_stuff(st
 	cpu_fc = le16_to_cpu(fc);
 	type = WLAN_FC_GET_TYPE(fc);
 	praddr = hdr->addr1;
-	psaddr = hdr->addr2;
 	packet_matchbssid =
 	    ((IEEE80211_FTYPE_CTL != type) &&
 	     (!compare_ether_addr(mac->bssid,
