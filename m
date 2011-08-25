Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47177 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab1HYJvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 05:51:19 -0400
Received: by wyg24 with SMTP id 24so1514411wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 02:51:18 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/2] wl12xx: set mac80211 flags for aggregation support
Date: Thu, 25 Aug 2011 12:51:05 +0300
Message-Id: <1314265865-20208-2-git-send-email-arik@wizery.com> (sfid-20110825_115122_669706_1E3FE0C3)
In-Reply-To: <1314265865-20208-1-git-send-email-arik@wizery.com>
References: <1314265865-20208-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We set the flag for A-MPDU support and also indicate that Tx aggregation
is performed in HW. This will prevent mac80211 from aggregating Tx
packets in software.

This patch depends on
"mac80211: add flag to indicate HW only Tx-agg support"

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7027a7e..fdeea4d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4478,7 +4478,9 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 		IEEE80211_HW_SUPPORTS_CQM_RSSI |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		IEEE80211_HW_SPECTRUM_MGMT |
-		IEEE80211_HW_AP_LINK_PS;
+		IEEE80211_HW_AP_LINK_PS |
+		IEEE80211_HW_AMPDU_AGGREGATION |
+		IEEE80211_HW_TX_AMPDU_IN_HW_ONLY;
 
 	wl->hw->wiphy->cipher_suites = cipher_suites;
 	wl->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
-- 
1.7.4.1

