Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56853 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755584AbbDNPEJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 11:04:09 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC/RFT 06/11] wlcore: enable IEEE80211_HW_SUPPORT_FAST_XMIT
Date: Tue, 14 Apr 2015 17:03:44 +0200
Message-Id: <1429023829-3991-7-git-send-email-johannes@sipsolutions.net> (sfid-20150414_170427_065725_0A6DDF1F)
In-Reply-To: <1429023829-3991-1-git-send-email-johannes@sipsolutions.net>
References: <1429023829-3991-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The driver can clearly enable fast-xmit since it does rate
control in the device and thus must do duration calculation
there as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 1e136993580f..34cef10aefc5 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6077,7 +6077,8 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 		IEEE80211_HW_AMPDU_AGGREGATION |
 		IEEE80211_HW_TX_AMPDU_SETUP_IN_HW |
 		IEEE80211_HW_QUEUE_CONTROL |
-		IEEE80211_HW_CHANCTX_STA_CSA;
+		IEEE80211_HW_CHANCTX_STA_CSA |
+		IEEE80211_HW_SUPPORT_FAST_XMIT;
 
 	wl->hw->wiphy->cipher_suites = cipher_suites;
 	wl->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
-- 
2.1.4

