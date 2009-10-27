Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:47018 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbZJ0Pgj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 11:36:39 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH v2 3/3] wl1251: enable power save
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Date: Tue, 27 Oct 2009 17:36:25 +0200
Message-ID: <20091027153625.27827.78442.stgit@tikku>
In-Reply-To: <20091027153608.27827.70629.stgit@tikku>
References: <20091027153608.27827.70629.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

wl1251 supports power save and it can be enabled now.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index ec01e9d..60a337a 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1311,7 +1311,8 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 	wl->hw->channel_change_time = 10000;
 
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_NOISE_DBM;
+		IEEE80211_HW_NOISE_DBM |
+		IEEE80211_HW_SUPPORTS_PS;
 
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	wl->hw->wiphy->max_scan_ssids = 1;

