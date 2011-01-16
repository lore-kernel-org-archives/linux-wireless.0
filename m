Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36091 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1APFme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 00:42:34 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so4134866wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Jan 2011 21:42:34 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 07/10] wl12xx: AP-mode - support HW based link PS monitoring
Date: Sun, 16 Jan 2011 07:42:11 +0200
Message-Id: <1295156534-4178-8-git-send-email-arik@wizery.com>
In-Reply-To: <1295156534-4178-1-git-send-email-arik@wizery.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When operating in AP mode the wl1271 hardware filters our null-data
packets as well as management packets. This makes it impossible for
mac80211 to monitor the PS mode by using the PM bit of incoming frames.

Disable mac80211 automatic link PS-mode handling by supporting
IEEE80211_HW_AP_LINK_PS in HW flags.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 6318224..77c8974 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3147,7 +3147,8 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 		IEEE80211_HW_SUPPORTS_UAPSD |
 		IEEE80211_HW_HAS_RATE_CONTROL |
 		IEEE80211_HW_CONNECTION_MONITOR |
-		IEEE80211_HW_SUPPORTS_CQM_RSSI;
+		IEEE80211_HW_SUPPORTS_CQM_RSSI |
+		IEEE80211_HW_AP_LINK_PS;
 
 	wl->hw->wiphy->cipher_suites = cipher_suites;
 	wl->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
-- 
1.7.1

