Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34383 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab3BPNZx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2013 08:25:53 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] ssb: fix unaligned access to mac address
Date: Sat, 16 Feb 2013 14:25:40 +0100
Message-Id: <1361021140-19871-1-git-send-email-hauke@hauke-m.de> (sfid-20130216_142600_027602_45FAF12B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac address should be aligned to u16 to prevent an unaligned access
in drivers/ssb/pci.c where it is casted to __be16.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/ssb/ssb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index 22958d6..457e8eb 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -26,6 +26,7 @@ struct ssb_sprom_core_pwr_info {
 
 struct ssb_sprom {
 	u8 revision;
+	u8 country_code;	/* Country Code */
 	u8 il0mac[6];		/* MAC address for 802.11b/g */
 	u8 et0mac[6];		/* MAC address for Ethernet */
 	u8 et1mac[6];		/* MAC address for 802.11a */
@@ -36,7 +37,6 @@ struct ssb_sprom {
 	u16 board_rev;		/* Board revision number from SPROM. */
 	u16 board_num;		/* Board number from SPROM. */
 	u16 board_type;		/* Board type from SPROM. */
-	u8 country_code;	/* Country Code */
 	char alpha2[2];		/* Country Code as two chars like EU or US */
 	u8 leddc_on_time;	/* LED Powersave Duty Cycle On Count */
 	u8 leddc_off_time;	/* LED Powersave Duty Cycle Off Count */
-- 
1.7.10.4

