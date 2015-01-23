Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52834 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbbAWI7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 03:59:38 -0500
Received: by mail-pa0-f53.google.com with SMTP id kx10so4588770pab.12
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2015 00:59:37 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net, linville@tuxdriver.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] rtl8192cu: fix the mesh beaconing
Date: Fri, 23 Jan 2015 16:59:24 +0800
Message-Id: <1422003564-22414-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20150123_095941_462681_1D88744E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch "rtlwifi: add support to send beacon frame" allows
the beaconing of rtl8192cu. But mesh beaconing is not
working. Fix this.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 5513217..e5a7c4f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1509,6 +1509,7 @@ void rtl92cu_set_beacon_related_registers(struct ieee80211_hw *hw)
 	/* TODO: Modify later (Find the right parameters)
 	 * NOTE: Fix test chip's bug (about contention windows's randomness) */
 	if ((mac->opmode == NL80211_IFTYPE_ADHOC) ||
+	    (mac->opmode == NL80211_IFTYPE_MESH_POINT) ||
 	    (mac->opmode == NL80211_IFTYPE_AP)) {
 		rtl_write_byte(rtlpriv, REG_RXTSF_OFFSET_CCK, 0x50);
 		rtl_write_byte(rtlpriv, REG_RXTSF_OFFSET_OFDM, 0x50);
-- 
2.2.2

