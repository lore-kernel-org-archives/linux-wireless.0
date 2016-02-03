Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36550 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbcBCCQX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 21:16:23 -0500
Date: Wed, 3 Feb 2016 11:16:17 +0900
From: Byeoungwook Kim <quddnr145@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: kvalo@codeaurora.org, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] rtlwifi: Fix reusable codes in core.c
Message-ID: <20160203021617.GA13759@gmail.com> (sfid-20160203_031642_831706_521618D9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtl_*_delay() functions were reused same codes about addr variable.
So i have converted to rtl_addr_delay() from code about addr variable.

Signed-off-by: Byeoungwook Kim <quddnr145@gmail.com>
Reviewed-by: Julian Calaby <julian.calaby@gmail.com>
---
V2 split in separate patchs.
 drivers/net/wireless/realtek/rtlwifi/core.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 05f432c..c1193d1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -63,18 +63,8 @@ EXPORT_SYMBOL(rtl_addr_delay);
 void rtl_rfreg_delay(struct ieee80211_hw *hw, enum radio_path rfpath, u32 addr,
 		     u32 mask, u32 data)
 {
-	if (addr == 0xfe) {
-		mdelay(50);
-	} else if (addr == 0xfd) {
-		mdelay(5);
-	} else if (addr == 0xfc) {
-		mdelay(1);
-	} else if (addr == 0xfb) {
-		udelay(50);
-	} else if (addr == 0xfa) {
-		udelay(5);
-	} else if (addr == 0xf9) {
-		udelay(1);
+	if (addr >= 0xf9 && addr <= 0xfe) {
+		rtl_addr_delay(addr);
 	} else {
 		rtl_set_rfreg(hw, rfpath, addr, mask, data);
 		udelay(1);
@@ -84,18 +74,8 @@ EXPORT_SYMBOL(rtl_rfreg_delay);
 
 void rtl_bb_delay(struct ieee80211_hw *hw, u32 addr, u32 data)
 {
-	if (addr == 0xfe) {
-		mdelay(50);
-	} else if (addr == 0xfd) {
-		mdelay(5);
-	} else if (addr == 0xfc) {
-		mdelay(1);
-	} else if (addr == 0xfb) {
-		udelay(50);
-	} else if (addr == 0xfa) {
-		udelay(5);
-	} else if (addr == 0xf9) {
-		udelay(1);
+	if (addr >= 0xf9 && addr <= 0xfe) {
+		rtl_addr_delay(addr);
 	} else {
 		rtl_set_bbreg(hw, addr, MASKDWORD, data);
 		udelay(1);
-- 
2.5.0

