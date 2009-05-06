Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53476 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbZEFAD4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 20:03:56 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 05 May 2009 17:03:57 -0700
Date: Tue, 5 May 2009 17:04:11 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <stable@kernel.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Fix FIF_BCN_PRBRESP_PROMISC handling
Message-ID: <20090506000410.GC3436@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a port of commit
91ed19f5f66a7fe544f0ec385e981f43491d1d5a
for 2.6.29.

Without this after scanning your device will set
the association ID to something bogus and what is
being reported is multicast/broadcast frame are not
being received. For details see this bug report:

https://bugzilla.redhat.com/show_bug.cgi?id=498502

>From the original commit:

So that a new created IBSS network
doesn't break on the first scan.

It seems to Sujith and me that this
stupid code unnecessary, too.

So remove it...

Reported-by: David Woodhouse <dwmw2@infradead.org>
Tested-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Jouni Malinen <Jouni.Malinen@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 3c04044..1cc826b 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -2300,11 +2300,6 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
 	rfilt = ath_calcrxfilter(sc);
 	ath9k_hw_setrxfilter(sc->sc_ah, rfilt);
 
-	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
-			ath9k_hw_write_associd(sc->sc_ah, ath_bcast_mac, 0);
-	}
-
 	DPRINTF(sc, ATH_DBG_CONFIG, "Set HW RX filter: 0x%x\n", sc->rx.rxfilter);
 }
 
-- 
1.6.2.2.446.gfbdc0


