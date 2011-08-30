Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50877 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab1H3GeG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 02:34:06 -0400
Received: by wwf5 with SMTP id 5so6473521wwf.1
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 23:34:05 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2] wl12xx: set mac80211 flags for A-MPDU aggregation support
Date: Tue, 30 Aug 2011 09:34:01 +0300
Message-Id: <1314686041-25489-1-git-send-email-arik@wizery.com> (sfid-20110830_083409_752380_0E1BEB9F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We set the mac80211 flag for A-MPDU support and also indicate that
Tx-agg session setup is performed in HW.

This patch depends on
"mac80211: add flag to indicate HW only Tx-agg setup support"

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
drivers/net/wireless/wl12xx/main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index bde8402..3553777 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4483,7 +4483,9 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 		IEEE80211_HW_SUPPORTS_CQM_RSSI |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		IEEE80211_HW_SPECTRUM_MGMT |
-		IEEE80211_HW_AP_LINK_PS;
+		IEEE80211_HW_AP_LINK_PS |
+		IEEE80211_HW_AMPDU_AGGREGATION |
+		IEEE80211_HW_TX_AMPDU_SETUP_IN_HW;
 
 	wl->hw->wiphy->cipher_suites = cipher_suites;
 	wl->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
-- 
1.7.4.1

