Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49614 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab2AaJyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 04:54:16 -0500
Received: by mail-wi0-f174.google.com with SMTP id s10so4215776wic.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 01:54:16 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 09/10] wl12xx: enable/disable BET with AUTO_PS/ACTIVE
Date: Tue, 31 Jan 2012 11:57:24 +0200
Message-Id: <1328003845-3926-10-git-send-email-eliad@wizery.com> (sfid-20120131_105424_205170_7669B12A)
In-Reply-To: <1328003845-3926-1-git-send-email-eliad@wizery.com>
References: <1328003845-3926-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

While the FW with dynamic PS controls BET when going to PSM and back
internally within the FW, there's still a need to enable it from the driver
at least once (so enable on every entry to AUTO_PS)
and disable it once we explicitly go back to STATION_ACTIVE_MODE.
BET isn't relevant for 5GHz

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/ps.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index 5074c2a..d7a91d3 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -181,6 +181,13 @@ int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			return ret;
 
 		set_bit(WLVIF_FLAG_PSM, &wlvif->flags);
+
+		/* enable beacon early termination. Not relevant for 5GHz */
+		if (wlvif->band == IEEE80211_BAND_2GHZ) {
+			ret = wl1271_acx_bet_enable(wl, wlvif, true);
+			if (ret < 0)
+				return ret;
+		}
 		break;
 	case STATION_ACTIVE_MODE:
 		wl1271_debug(DEBUG_PSM, "leaving psm");
-- 
1.7.6.401.g6a319

