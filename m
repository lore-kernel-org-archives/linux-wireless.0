Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:34308 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933093AbcBBPtB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 10:49:01 -0500
Date: Wed, 3 Feb 2016 00:48:55 +0900
From: Byeoungwook Kim <quddnr145@gmail.com>
To: kvalo@codeaurora.org
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix reusable codes in core.c
Message-ID: <20160202154855.GA8990@gmail.com> (sfid-20160202_164930_124944_407C5529)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtl_*_delay() functions were reused same codes about addr variable.
So i have converted to rtl_addr_delay() from code about addr variable.

Conditional codes in rtl_addr_delay() were improved in readability and
performance by using switch codes.

Signed-off-by: Byeoungwook Kim <quddnr145@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 48 +++++++++++------------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 4ae421e..c1193d1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -37,36 +37,34 @@
 
 void rtl_addr_delay(u32 addr)
 {
-	if (addr == 0xfe)
+	switch (addr) {
+	case 0xfe:
 		mdelay(50);
-	else if (addr == 0xfd)
+		break;
+	case 0xfd:
 		mdelay(5);
-	else if (addr == 0xfc)
+		break;
+	case 0xfc:
 		mdelay(1);
-	else if (addr == 0xfb)
+		break;
+	case 0xfb:
 		udelay(50);
-	else if (addr == 0xfa)
+		break;
+	case 0xfa:
 		udelay(5);
-	else if (addr == 0xf9)
+		break;
+	case 0xf9:
 		udelay(1);
+		break;
+	};
 }
 EXPORT_SYMBOL(rtl_addr_delay);
 
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
@@ -76,18 +74,8 @@ EXPORT_SYMBOL(rtl_rfreg_delay);
 
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

