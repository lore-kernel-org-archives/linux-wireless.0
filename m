Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:46878 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbZHLOwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 10:52:42 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 3/3] wl1251: enable power save
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Date: Wed, 12 Aug 2009 17:52:18 +0300
Message-ID: <20090812145217.23691.16291.stgit@tikku>
In-Reply-To: <20090812145200.23691.17281.stgit@tikku>
References: <20090812145200.23691.17281.stgit@tikku>
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
index 7148934..72e2dc9 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1310,7 +1310,8 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 	wl->hw->channel_change_time = 10000;
 
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_NOISE_DBM;
+		IEEE80211_HW_NOISE_DBM |
+		IEEE80211_HW_SUPPORTS_PS;
 
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	wl->hw->wiphy->max_scan_ssids = 1;

