Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:4033 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933203AbaJ2PC7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 11:02:59 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/2] brcmsmac: fix statistic counter update function
Date: Wed, 29 Oct 2014 16:02:50 +0100
Message-ID: <1414594971-26389-2-git-send-email-arend@broadcom.com> (sfid-20141029_160305_649876_B65DF07A)
In-Reply-To: <1414594971-26389-1-git-send-email-arend@broadcom.com>
References: <1414594971-26389-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 802.11 core statistics are retrieved from the core registers
but not stored. So the debug code was never triggered to give a
warning message on tx underruns or rx overflows. This patch fixes
this and assures the statistics are stored in the snapshot.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 1b47482..bc9be78 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -3081,7 +3081,7 @@ static bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 static void brcms_c_statsupd(struct brcms_c_info *wlc)
 {
 	int i;
-	struct macstat macstats;
+	struct macstat *macstats;
 #ifdef DEBUG
 	u16 delta;
 	u16 rxf0ovfl;
@@ -3092,31 +3092,31 @@ static void brcms_c_statsupd(struct brcms_c_info *wlc)
 	if (!wlc->pub->up)
 		return;
 
+	macstats = wlc->core->macstat_snapshot;
+
 #ifdef DEBUG
 	/* save last rx fifo 0 overflow count */
-	rxf0ovfl = wlc->core->macstat_snapshot->rxf0ovfl;
+	rxf0ovfl = macstats->rxf0ovfl;
 
 	/* save last tx fifo  underflow count */
 	for (i = 0; i < NFIFO; i++)
-		txfunfl[i] = wlc->core->macstat_snapshot->txfunfl[i];
+		txfunfl[i] = macstats->txfunfl[i];
 #endif				/* DEBUG */
 
 	/* Read mac stats from contiguous shared memory */
-	brcms_b_copyfrom_objmem(wlc->hw, M_UCODE_MACSTAT, &macstats,
-				sizeof(struct macstat), OBJADDR_SHM_SEL);
+	brcms_b_copyfrom_objmem(wlc->hw, M_UCODE_MACSTAT, macstats,
+				sizeof(*macstats), OBJADDR_SHM_SEL);
 
 #ifdef DEBUG
 	/* check for rx fifo 0 overflow */
-	delta = (u16) (wlc->core->macstat_snapshot->rxf0ovfl - rxf0ovfl);
+	delta = (u16)(macstats->rxf0ovfl - rxf0ovfl);
 	if (delta)
 		brcms_err(wlc->hw->d11core, "wl%d: %u rx fifo 0 overflows!\n",
 			  wlc->pub->unit, delta);
 
 	/* check for tx fifo underflows */
 	for (i = 0; i < NFIFO; i++) {
-		delta =
-		    (u16) (wlc->core->macstat_snapshot->txfunfl[i] -
-			      txfunfl[i]);
+		delta = macstats->txfunfl[i] - txfunfl[i];
 		if (delta)
 			brcms_err(wlc->hw->d11core,
 				  "wl%d: %u tx fifo %d underflows!\n",
-- 
1.9.1

