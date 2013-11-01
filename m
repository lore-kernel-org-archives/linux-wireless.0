Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:37719 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab3KATkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 15:40:17 -0400
Received: by mail-ee0-f49.google.com with SMTP id e52so2174810eek.22
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 12:40:16 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath9k: DFS radar use correct width enum
Date: Fri,  1 Nov 2013 20:39:49 +0100
Message-Id: <1383334789-12022-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131101_204022_718520_3D26FB29)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use correct width enums when setup
radar_detect_widths for DFS.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index eac8f6d..beeb8d4 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -776,8 +776,8 @@ static const struct ieee80211_iface_combination if_comb[] = {
 		.max_interfaces = 1,
 		.num_different_channels = 1,
 		.beacon_int_infra_match = true,
-		.radar_detect_widths =	BIT(NL80211_CHAN_NO_HT) |
-					BIT(NL80211_CHAN_HT20),
+		.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT) |
+					BIT(NL80211_CHAN_WIDTH_20),
 	}
 };
 
-- 
1.7.9.5

