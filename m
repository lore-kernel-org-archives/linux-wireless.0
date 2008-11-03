Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32001 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbYKCWnG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 17:43:06 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2008 14:43:06 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath5k: allow APs to receive beacons
Date: Mon, 3 Nov 2008 14:43:00 -0800
Message-ID: <1225752181-1343-3-git-send-email-lrodriguez@atheros.com> (sfid-20081103_234313_325774_9F9EF87F)
In-Reply-To: <1225752181-1343-2-git-send-email-lrodriguez@atheros.com>
References: <1225752181-1343-1-git-send-email-lrodriguez@atheros.com>
 <1225752181-1343-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow APs to receive beacons to detect when it needs
to use protection to update the NAV correctly on
11b stations.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath5k/base.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 1ed152f..b2365be 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2953,7 +2953,8 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 		test_bit(ATH_STAT_PROMISC, sc->status))
 		rfilt |= AR5K_RX_FILTER_PROM;
 	if (sc->opmode == NL80211_IFTYPE_STATION ||
-		sc->opmode == NL80211_IFTYPE_ADHOC) {
+			sc->opmode == NL80211_IFTYPE_ADHOC ||
+			sc->opmode == NL80211_IFTYPE_AP) {
 		rfilt |= AR5K_RX_FILTER_BEACON;
 	}
 	if (sc->opmode == NL80211_IFTYPE_MESH_POINT)
-- 
1.5.6.rc2.15.g457bb.dirty

