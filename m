Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35394 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbcEUQul (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 May 2016 12:50:41 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	James Feeney <james@nurealm.net>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH] rtlwifi: Fix scheduling while atomic error from commit 49f86ec21c01
Date: Sat, 21 May 2016 11:50:35 -0500
Message-Id: <1463849435-2293-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160521_185104_188556_35BF298C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 49f86ec21c01 ("rtlwifi: Change long delays to sleeps") was correct
for most cases; however, driver rtl8192ce calls the affected routines while
in atomic context. The kernel bug output is as follows:

BUG: scheduling while atomic: wpa_supplicant/627/0x00000002
[...]
  [<ffffffff815c2b39>] __schedule+0x899/0xad0
  [<ffffffff815c2dac>] schedule+0x3c/0x90
  [<ffffffff815c5bb2>] schedule_hrtimeout_range_clock+0xa2/0x120
  [<ffffffff810e8b80>] ? hrtimer_init+0x120/0x120
  [<ffffffff815c5ba6>] ? schedule_hrtimeout_range_clock+0x96/0x120
  [<ffffffff815c5c43>] schedule_hrtimeout_range+0x13/0x20
  [<ffffffff815c568f>] usleep_range+0x4f/0x70
  [<ffffffffa0667218>] rtl_rfreg_delay+0x38/0x50 [rtlwifi]
  [<ffffffffa06dd0e7>] rtl92c_phy_config_rf_with_headerfile+0xc7/0xe0 [rtl8192ce]

To fix this bug, three of the changes from delay to sleep are reverted.
Unfortunately, one of the changes involves a delay of 50 msec. The calling
code will be modified so that this long delay can be avoided; however,
this change is being pushed now to fix the problem in kernel 4.6.0.

Fixes: 49f86ec21c01 ("rtlwifi: Change long delays to sleeps")
Reported-by: James Feeney <james@nurealm.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: James Feeney <james@nurealm.net>
Cc: Stable <stable@vger.kernel.org> [4.6+]
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 0f48048..3a0faa8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -54,7 +54,7 @@ EXPORT_SYMBOL(channel5g_80m);
 void rtl_addr_delay(u32 addr)
 {
 	if (addr == 0xfe)
-		msleep(50);
+		mdelay(50);
 	else if (addr == 0xfd)
 		msleep(5);
 	else if (addr == 0xfc)
@@ -75,7 +75,7 @@ void rtl_rfreg_delay(struct ieee80211_hw *hw, enum radio_path rfpath, u32 addr,
 		rtl_addr_delay(addr);
 	} else {
 		rtl_set_rfreg(hw, rfpath, addr, mask, data);
-		usleep_range(1, 2);
+		udelay(1);
 	}
 }
 EXPORT_SYMBOL(rtl_rfreg_delay);
@@ -86,7 +86,7 @@ void rtl_bb_delay(struct ieee80211_hw *hw, u32 addr, u32 data)
 		rtl_addr_delay(addr);
 	} else {
 		rtl_set_bbreg(hw, addr, MASKDWORD, data);
-		usleep_range(1, 2);
+		udelay(1);
 	}
 }
 EXPORT_SYMBOL(rtl_bb_delay);
-- 
2.1.4

