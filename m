Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:36067 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3EMCo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 May 2013 22:44:29 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH V3.10] rtlwifi: rtl8188ee: Fix warning when building on big-endian systems
Date: Sun, 12 May 2013 21:43:46 -0500
Message-Id: <1368413026-17106-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130513_044432_897432_49CE4B79)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In http://lkml.indiana.edu/hypermail/linux/kernel/1305.1/index.html,
Geert Uytterhoeven reports a new warning when building 3.10-rc1 in
this driver. This is caused by using a "#if" test to see if __LITTLE_ENDIAN
is set, which fails for all big-endian systems. Change to "ifdef".

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

As noted above, please add to 3.10.

Larry
---
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.h b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.h
index d3a02e7..21ca33a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.h
@@ -550,7 +550,7 @@ do {								\
 	 rxmcs == DESC92C_RATE11M)
 
 struct phy_rx_agc_info_t {
-	#if __LITTLE_ENDIAN
+	#ifdef __LITTLE_ENDIAN
 		u8	gain:7, trsw:1;
 	#else
 		u8	trsw:1, gain:7;
@@ -574,7 +574,7 @@ struct phy_status_rpt {
 	u8	stream_target_csi[2];
 	u8	sig_evm;
 	u8	rsvd_3;
-#if __LITTLE_ENDIAN
+#ifdef __LITTLE_ENDIAN
 	u8	antsel_rx_keep_2:1;	/*ex_intf_flg:1;*/
 	u8	sgi_en:1;
 	u8	rxsc:2;
-- 
1.8.1.4

