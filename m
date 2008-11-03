Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32003 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbYKCWnH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 17:43:07 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2008 14:43:07 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] ath9k: enable RXing of beacons on STA/IBSS
Date: Mon, 3 Nov 2008 14:43:01 -0800
Message-ID: <1225752181-1343-4-git-send-email-lrodriguez@atheros.com> (sfid-20081103_234313_883697_5CDC5044)
In-Reply-To: <1225752181-1343-3-git-send-email-lrodriguez@atheros.com>
References: <1225752181-1343-1-git-send-email-lrodriguez@atheros.com>
 <1225752181-1343-2-git-send-email-lrodriguez@atheros.com>
 <1225752181-1343-3-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This enables beacons to come through on STA/IBSS.
It should fix sporadic connection issues. Right now
mac80211 expect beacons so give it beacons.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/recv.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 2ecb0a0..2d72ac1 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -296,9 +296,8 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 		rfilt &= ~ATH9K_RX_FILTER_UCAST;
 	}
 
-	if (((sc->sc_ah->ah_opmode == ATH9K_M_STA) &&
-	     (sc->rx_filter & FIF_BCN_PRBRESP_PROMISC)) ||
-	    (sc->sc_ah->ah_opmode == ATH9K_M_IBSS))
+	if (sc->sc_ah->ah_opmode == ATH9K_M_STA ||
+			sc->sc_ah->ah_opmode == ATH9K_M_IBSS)
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
 	/* If in HOSTAP mode, want to enable reception of PSPOLL frames
-- 
1.5.6.rc2.15.g457bb.dirty

