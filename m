Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32775 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbYJNEIW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 00:08:22 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Oct 2008 21:08:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>,
	<mickflemm@gmail.com>, <jirislaby@gmail.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] ath5k: correct ath5k signal quality
Date: Mon, 13 Oct 2008 14:08:10 -0700
Message-ID: <1223932090-9274-4-git-send-email-lrodriguez@atheros.com> (sfid-20081014_060826_100883_250D8CEA)
In-Reply-To: <1223932090-9274-3-git-send-email-lrodriguez@atheros.com>
References: <1223932090-9274-1-git-send-email-lrodriguez@atheros.com>
 <1223932090-9274-2-git-send-email-lrodriguez@atheros.com>
 <1223932090-9274-3-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adjusts ath5k's signal quality reporting taking into
consideration received beacons at an RSSI of 35 should indicate
you can use of 54 Mbps on a single stream card (all ath5k cards)
reliably.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath5k/base.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 1a24a22..c7f46e9 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1798,7 +1798,17 @@ accept:
 
 		rxs.noise = sc->ah->ah_noise_floor;
 		rxs.signal = rxs.noise + rs.rs_rssi;
-		rxs.qual = rs.rs_rssi * 100 / 64;
+
+		/* An rssi of 35 indicates you should be able use
+		 * 54 Mbps reliably. A more elaborate scheme can be used
+		 * here but it requires a map of SNR/throughput for each
+		 * possible mode used */
+		rxs.qual = rs.rs_rssi * 100 / 35;
+
+		/* rssi can be more than 35 though, anything above that
+		 * should be considered at 100% */
+		if (rxs.qual > 100)
+			rxs.qual = 100;
 
 		rxs.antenna = rs.rs_antenna;
 		rxs.rate_idx = ath5k_hw_to_driver_rix(sc, rs.rs_rate);
-- 
1.5.6.rc2.15.g457bb.dirty

