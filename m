Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12985 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbYIWUCA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2008 16:02:00 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2008 13:02:00 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org, \"Steven Noonan\""
	<steven@uplinklabs.net>
Subject: [PATCH] ath9k: disable MIB interrupts to fix interrupt storm
Date: Tue, 23 Sep 2008 13:01:54 -0700
Message-ID: <1222200114-8690-1-git-send-email-lrodriguez@atheros.com> (sfid-20080923_220207_775150_CF939C9A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For AR5416 enabling the MIB interrupts has proven to cause an
interrupt storm after 7 hours of run. We will make use of the
MIB interrupt once we have ANI supported added so for now
to cure this we disable the interrupt.

The interrupt storm can be seen as follows after 7 hours of run
as reported by  Steven Noonan <steven@uplinklabs.net>:

18:28:38          sum   1106.00
18:28:39          sum   1037.62
18:28:40          sum   1069.00
18:28:41          sum   1167.00
18:28:42          sum   1155.00
18:28:43          sum   1339.00
18:28:44          sum  18355.00
18:28:45          sum  17845.45
18:28:46          sum  15285.00
18:28:47          sum  17511.00
18:28:48          sum  17568.69
18:28:49          sum  17704.04
18:28:50          sum  18566.67
18:28:51          sum  18913.13

at 18:28:44 the MIB interrupt kicked off and caused huge
latency which can be seen even on a video he submitted:

http://www.youtube.com/watch?v=4GeCx1gZMpA

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This patch is intended for 2.6.27 only, we hope to just
enable ANI for 2.6.28.

 drivers/net/wireless/ath9k/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index f6c4528..8a4d4e2 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -801,9 +801,11 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	 * Enable MIB interrupts when there are hardware phy counters.
 	 * Note we only do this (at the moment) for station mode.
 	 */
+#if 0
 	if (ath9k_hw_phycounters(ah) &&
 	    ((sc->sc_opmode == ATH9K_M_STA) || (sc->sc_opmode == ATH9K_M_IBSS)))
 		sc->sc_imask |= ATH9K_INT_MIB;
+#endif
 	/*
 	 * Some hardware processes the TIM IE and fires an
 	 * interrupt when the TIM bit is set.  For hardware
-- 
1.5.6.rc2.15.g457bb.dirty

