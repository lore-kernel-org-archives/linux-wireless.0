Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:51455 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab1EPMgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 08:36:08 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p4GCa8t0007396
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 16 May 2011 07:36:08 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep33.itg.ti.com (8.13.7/8.13.7) with ESMTP id p4GCa8xx000043
	for <linux-wireless@vger.kernel.org>; Mon, 16 May 2011 07:36:08 -0500 (CDT)
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: Luciano Coelho <coelho@ti.com>
Subject: [PATCH] wl12xx: Enable beacon early termination in 2.4G band only
Date: Mon, 16 May 2011 15:35:30 +0300
Message-ID: <1305549330-28478-1-git-send-email-shahar_levi@ti.com> (sfid-20110516_143612_637714_80EF534D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Beacon early termination have minor effect in 5G band and also
mask channel switch IE Beacons.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/event.c |    7 +++++--
 drivers/net/wireless/wl12xx/ps.c    |    8 +++++---
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index ae69330..848d336 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -133,8 +133,11 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 		if (ret < 0)
 			break;
 
-		/* enable beacon early termination */
-		ret = wl1271_acx_bet_enable(wl, true);
+		/* bet have minor effect in 5G band and mask channel switch IE*/
+		if (wl->band == IEEE80211_BAND_2GHZ)
+			/* enable beacon early termination */
+			ret = wl1271_acx_bet_enable(wl, true);
+
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index b59b677..c106dc9 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -169,9 +169,11 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
 		wl1271_debug(DEBUG_PSM, "leaving psm");
 
 		/* disable beacon early termination */
-		ret = wl1271_acx_bet_enable(wl, false);
-		if (ret < 0)
-			return ret;
+		if (wl->band == IEEE80211_BAND_2GHZ) {
+			ret = wl1271_acx_bet_enable(wl, false);
+			if (ret < 0)
+				return ret;
+		}
 
 		/* disable beacon filtering */
 		ret = wl1271_acx_beacon_filter_opt(wl, false);
-- 
1.7.0.4

