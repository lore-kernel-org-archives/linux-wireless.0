Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35051 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750942AbcKVGEx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 01:04:53 -0500
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Mon, 21 Nov 2016 22:04:46 -0800
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: Remove unused 'rates_idx' variable
Message-ID: <20161122060446.GA26548@google.com> (sfid-20161122_070457_884971_B569F8D0)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit f027c2aca0cf introduced 'rates_idx' in
ieee80211_tx_status_noskb but did not use it. Compiling with W=1
gives the following warning, fix it.

mac80211/status.c: In function ‘ieee80211_tx_status_noskb’:
mac80211/status.c:636:6: warning: variable ‘rates_idx’ set but not used [-Wunused-but-set-variable]

This is a harmless warning, and is only being fixed to reduce the
noise generated with W=1.

Fixes: f027c2aca0cf ("mac80211: add ieee80211_tx_status_noskb")
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Kirtika Ruchandani <kirtika@google.com>
---
 net/mac80211/status.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index ddf71c6..f7c5ae5 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -633,10 +633,9 @@ void ieee80211_tx_status_noskb(struct ieee80211_hw *hw,
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_supported_band *sband;
 	int retry_count;
-	int rates_idx;
 	bool acked, noack_success;

-	rates_idx = ieee80211_tx_get_rates(hw, info, &retry_count);
+	ieee80211_tx_get_rates(hw, info, &retry_count);

 	sband = hw->wiphy->bands[info->band];

--
2.8.0.rc3.226.g39d4020
