Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4411 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbZDVDov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 23:44:51 -0400
From: Bob Copeland <me@bobcopeland.com>
To: kalle.valo@nokia.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/3] wl12xx: enable station mode
Date: Tue, 21 Apr 2009 23:44:18 -0400
Message-Id: <1240371860-9001-1-git-send-email-me@bobcopeland.com> (sfid-20090422_054515_261080_CEE95616)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the interface_modes bitmask.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

Kalle, couple more minor updates here.

 drivers/net/wireless/wl12xx/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 61e51bc..2e01295 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1239,6 +1239,7 @@ static int wl12xx_init_ieee80211(struct wl12xx *wl)
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_NOISE_DBM;
 
+	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	wl->hw->wiphy->max_scan_ssids = 1;
 	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl12xx_band_2ghz;
 
-- 
1.6.0.6


