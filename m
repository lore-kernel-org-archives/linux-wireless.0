Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30759 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355Ab0IRBGY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 21:06:24 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 18:06:18 -0700
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>, <andy.shevchenko@gmail.com>,
	<randy.dunlap@oracle.com>
Subject: [PATCH] staging: ath6kl: Fixing a compile error
Date: Fri, 17 Sep 2010 18:06:19 -0700
Message-ID: <1284771979-13249-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixing a typo that came in as part of commit
fa1ae16c97d25bb57ed9e1971b9e814da6a290bd.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 drivers/staging/ath6kl/wmi/wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ath6kl/wmi/wmi.c b/drivers/staging/ath6kl/wmi/wmi.c
index 9811ce7..23ae5d2 100644
--- a/drivers/staging/ath6kl/wmi/wmi.c
+++ b/drivers/staging/ath6kl/wmi/wmi.c
@@ -1458,7 +1458,7 @@ wmi_bssInfo_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 
 	A_DPRINTF(DBG_WMI2, (DBGFMT "bssInfo event - ch %u, rssi %02x, "
 		"bssid \"%pM\"\n", DBGARG, bih->channel,
-		(unsigned char) bih->rssi, i&bih->bssid[0]));
+		(unsigned char) bih->rssi, &bih->bssid[0]));
 
     if(wps_enable && (bih->frameType == PROBERESP_FTYPE) ) {
         wmi_node_return(wmip, bss);
-- 
1.6.3.3

