Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:52629 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755438Ab2ENK6N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 06:58:13 -0400
Received: by obbeh20 with SMTP id eh20so10849507obb.17
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 03:58:11 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <coelho@ti.com>, <arik@wizery.com>
Subject: [PATCH] wlcore: don't enable BET for high basic rates
Date: Mon, 14 May 2012 13:55:47 +0300
Message-Id: <1336992947-12927-1-git-send-email-victorg@ti.com> (sfid-20120514_125816_399672_A58B193C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The beacon early termination is not relevant for
high basic rates, which doesn't contribute
anything to the PS and only adds unnecessary FW
work.

Enable BET only if the basic rate is less than 9
Mbps.

Signed-off-by: Ziv Riesel <zivriesel@ti.com>
Signed-off-by: Victor Goldenshtein <victorg@ti.com>
Signed-off-by: Igal Chernobelsky <igalc@ti.com>
---
 drivers/net/wireless/ti/wlcore/ps.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index 756eee2..87c84d1 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -185,8 +185,12 @@ int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 		set_bit(WLVIF_FLAG_IN_PS, &wlvif->flags);
 
-		/* enable beacon early termination. Not relevant for 5GHz */
-		if (wlvif->band == IEEE80211_BAND_2GHZ) {
+		/*
+		 * enable beacon early termination.
+		 * Not relevant for 5GHz and for high rates.
+		 */
+		if ((wlvif->band == IEEE80211_BAND_2GHZ) &&
+		    (wlvif->basic_rate < CONF_HW_BIT_RATE_9MBPS)) {
 			ret = wl1271_acx_bet_enable(wl, wlvif, true);
 			if (ret < 0)
 				return ret;
@@ -196,7 +200,8 @@ int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		wl1271_debug(DEBUG_PSM, "leaving psm");
 
 		/* disable beacon early termination */
-		if (wlvif->band == IEEE80211_BAND_2GHZ) {
+		if ((wlvif->band == IEEE80211_BAND_2GHZ) &&
+		    (wlvif->basic_rate < CONF_HW_BIT_RATE_9MBPS)) {
 			ret = wl1271_acx_bet_enable(wl, wlvif, false);
 			if (ret < 0)
 				return ret;
-- 
1.7.5.4

