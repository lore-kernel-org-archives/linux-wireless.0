Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:48805 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758403AbZACNoy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 08:44:54 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Gabor Juhos <juhosg@openwrt.org>,
	Imre Kaloz <kaloz@openwrt.org>
Subject: [RFC 12/12] ath9k: fix null pointer dereference in ani monitor code
Date: Sat,  3 Jan 2009 14:44:22 +0100
Message-Id: <1230990262-22923-13-git-send-email-juhosg@openwrt.org> (sfid-20090103_144504_024978_0C46D8E1)
In-Reply-To: <1230990262-22923-1-git-send-email-juhosg@openwrt.org>
References: <1230990262-22923-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In 'ath9k_ani_reset' the 'ahp->ah_curani' will be initialized only
if 'DO_ANI(ah)' true. In 'ath9k_hw_ani_monitor' we are using 'ahp->ah_curani'
unconditionally, and it will cause a NULL pointer dereference on AR9100.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/ani.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ani.c b/drivers/net/wireless/ath9k/ani.c
index 251e2d9..ffa6a93 100644
--- a/drivers/net/wireless/ath9k/ani.c
+++ b/drivers/net/wireless/ath9k/ani.c
@@ -555,6 +555,9 @@ void ath9k_hw_ani_monitor(struct ath_hal *ah,
 	struct ar5416AniState *aniState;
 	int32_t listenTime;
 
+	if (!DO_ANI(ah))
+		return;
+
 	aniState = ahp->ah_curani;
 	ahp->ah_stats.ast_nodestats = *stats;
 
@@ -614,9 +617,6 @@ void ath9k_hw_ani_monitor(struct ath_hal *ah,
 		aniState->cckPhyErrCount = cckPhyErrCnt;
 	}
 
-	if (!DO_ANI(ah))
-		return;
-
 	if (aniState->listenTime > 5 * ahp->ah_aniPeriod) {
 		if (aniState->ofdmPhyErrCount <= aniState->listenTime *
 		    aniState->ofdmTrigLow / 1000 &&
-- 
1.5.3.2

