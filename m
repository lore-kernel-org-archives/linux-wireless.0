Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:38203 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbYKCAgz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 19:36:55 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 02 Nov 2008 16:36:55 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] ath5k: enable RXing beacons
Date: Sun, 2 Nov 2008 16:36:52 -0800
Message-ID: <1225672612-15106-1-git-send-email-lrodriguez@atheros.com> (sfid-20081103_013659_445382_440453E6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prior to this we would rely only on probe responses
from the AP to keep associated. We now receive beacons
on ath5k. This should fix sporadic disassociations.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath5k/base.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index f5f46fe..5505f45 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2948,6 +2948,8 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 			AR5K_RX_FILTER_PROBEREQ | AR5K_RX_FILTER_PROM;
 	if (sc->opmode != NL80211_IFTYPE_STATION)
 		rfilt |= AR5K_RX_FILTER_PROBEREQ;
+	if (sc->opmode == NL80211_IFTYPE_STATION)
+		rfilt |= AR5K_RX_FILTER_BEACON;
 	if (sc->opmode != NL80211_IFTYPE_AP &&
 		sc->opmode != NL80211_IFTYPE_MESH_POINT &&
 		test_bit(ATH_STAT_PROMISC, sc->status))
-- 
1.5.6.rc2.15.g457bb.dirty

