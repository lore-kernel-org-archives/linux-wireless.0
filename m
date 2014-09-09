Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:63351 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaIIU6B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 16:58:01 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org, Kbuild test robot <kbuild-all@01.org>
Subject: [PATCH] rtlwifi: btcoexist: Fix "always true" warning from commit ed364abffd6e
Date: Tue,  9 Sep 2014 15:57:46 -0500
Message-Id: <1410296266-14327-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140909_225814_654733_95CB37D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 0-DAY kernel build testing backend reports the following warning:
drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c:516 halbtc_bitmask_write_1byte()
warn: always true condition '(bit_mask != 4294967295) => (0-255 != u32max)'

This problem was introduced in commit ed364abffd6e19bec67b7ccda8237213b8b37640,
and arises because the caller of halbtc_bitmask_write_1byte() is using a
u8 rather than a u32 for the data.

Reported-by: Kbuild test robot <kbuild-all@01.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kbuild test robot <kbuild-all@01.org>
---
 drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c | 2 +-
 drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
index 3119e8b..0620b22 100644
--- a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -497,7 +497,7 @@ static u32 halbtc_read_4byte(void *bt_context, u32 reg_addr)
 	return	rtl_read_dword(rtlpriv, reg_addr);
 }
 
-static void halbtc_write_1byte(void *bt_context, u32 reg_addr, u8 data)
+static void halbtc_write_1byte(void *bt_context, u32 reg_addr, u32 data)
 {
 	struct btc_coexist *btcoexist = (struct btc_coexist *)bt_context;
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h
index eae1937..0d185e6 100644
--- a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -359,7 +359,7 @@ typedef u16 (*bfp_btc_r2)(void *btc_context, u32 reg_addr);
 
 typedef u32 (*bfp_btc_r4)(void *btc_context, u32 reg_addr);
 
-typedef void (*bfp_btc_w1)(void *btc_context, u32 reg_addr, u8 data);
+typedef void (*bfp_btc_w1)(void *btc_context, u32 reg_addr, u32 data);
 
 typedef void (*bfp_btc_w1_bit_mak)(void *btc_context, u32 reg_addr,
 				   u8 bit_mask, u8 data1b);
-- 
1.8.4.5

