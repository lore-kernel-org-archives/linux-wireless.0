Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43461 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab1BVWWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:55 -0500
Received: by mail-ww0-f44.google.com with SMTP id 39so765282wwb.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Feb 2011 14:22:55 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 5/8] wl12xx: AP-mode - support HW based link PS monitoring
Date: Wed, 23 Feb 2011 00:22:28 +0200
Message-Id: <1298413351-15462-6-git-send-email-arik@wizery.com>
In-Reply-To: <1298413351-15462-1-git-send-email-arik@wizery.com>
References: <1298413351-15462-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When operating in AP mode the wl1271 hardware filters out null-data
packets as well as management packets. This makes it impossible for
mac80211 to monitor the PS mode by using the PM bit of incoming frames.

Disable mac80211 automatic link PS-mode handling by supporting
IEEE80211_HW_AP_LINK_PS in HW flags.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 610e76b..9c44150 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3218,7 +3218,8 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
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

