Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39743 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab3BRUr4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 15:47:56 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	johannes@sipsolutions.net, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2] ssb: fix unaligned access to mac address
Date: Mon, 18 Feb 2013 21:47:45 +0100
Message-Id: <1361220465-26384-1-git-send-email-hauke@hauke-m.de> (sfid-20130218_214759_601978_0570934F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac address should be aligned to u16 to prevent an unaligned access
in drivers/ssb/pci.c where it is casted to __be16.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/ssb/ssb.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index 22958d6..8b13222 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -26,9 +26,9 @@ struct ssb_sprom_core_pwr_info {
 
 struct ssb_sprom {
 	u8 revision;
-	u8 il0mac[6];		/* MAC address for 802.11b/g */
-	u8 et0mac[6];		/* MAC address for Ethernet */
-	u8 et1mac[6];		/* MAC address for 802.11a */
+	u8 il0mac[6] __aligned(sizeof(u16));	/* MAC address for 802.11b/g */
+	u8 et0mac[6] __aligned(sizeof(u16));	/* MAC address for Ethernet */
+	u8 et1mac[6] __aligned(sizeof(u16));	/* MAC address for 802.11a */
 	u8 et0phyaddr;		/* MII address for enet0 */
 	u8 et1phyaddr;		/* MII address for enet1 */
 	u8 et0mdcport;		/* MDIO for enet0 */
-- 
1.7.10.4

