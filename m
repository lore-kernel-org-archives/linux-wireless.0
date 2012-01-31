Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55610 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab2AaPvS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 10:51:18 -0500
Received: by wics10 with SMTP id s10so83344wic.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 07:51:17 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] wl12xx: Set IEEE80211_TX_RC_SHORT_GI if short GI was used on
Date: Tue, 31 Jan 2012 17:54:41 +0200
Message-Id: <1328025283-22888-2-git-send-email-eliad@wizery.com> (sfid-20120131_165123_970088_2402BEA7)
In-Reply-To: <1328025283-22888-1-git-send-email-eliad@wizery.com>
References: <1328025283-22888-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

New FW reports usage of short GI as a rate class index. Check for
this rate and set the IEEE80211_TX_RC_SHORT_GI if used.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
depends on the "wl12xx: update fw api" patchset

 drivers/net/wireless/wl12xx/conf.h |    5 +++--
 drivers/net/wireless/wl12xx/main.c |    2 ++
 drivers/net/wireless/wl12xx/tx.c   |    8 ++++++--
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index a152713..a179510 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -66,7 +66,8 @@ enum {
 };
 
 enum {
-	CONF_HW_RXTX_RATE_MCS7 = 0,
+	CONF_HW_RXTX_RATE_MCS7_SGI = 0,
+	CONF_HW_RXTX_RATE_MCS7,
 	CONF_HW_RXTX_RATE_MCS6,
 	CONF_HW_RXTX_RATE_MCS5,
 	CONF_HW_RXTX_RATE_MCS4,
@@ -92,7 +93,7 @@ enum {
 };
 
 /* Rates between and including these are MCS rates */
-#define CONF_HW_RXTX_RATE_MCS_MIN CONF_HW_RXTX_RATE_MCS7
+#define CONF_HW_RXTX_RATE_MCS_MIN CONF_HW_RXTX_RATE_MCS7_SGI
 #define CONF_HW_RXTX_RATE_MCS_MAX CONF_HW_RXTX_RATE_MCS0
 
 enum {
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index ea4e2c4..d67acc3 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4620,6 +4620,7 @@ static struct ieee80211_channel wl1271_channels[] = {
 /* mapping to indexes for wl1271_rates */
 static const u8 wl1271_rate_to_idx_2ghz[] = {
 	/* MCS rates are used only with 11n */
+	7,                            /* CONF_HW_RXTX_RATE_MCS7_SGI */
 	7,                            /* CONF_HW_RXTX_RATE_MCS7 */
 	6,                            /* CONF_HW_RXTX_RATE_MCS6 */
 	5,                            /* CONF_HW_RXTX_RATE_MCS5 */
@@ -4741,6 +4742,7 @@ static struct ieee80211_channel wl1271_channels_5ghz[] = {
 /* mapping to indexes for wl1271_rates_5ghz */
 static const u8 wl1271_rate_to_idx_5ghz[] = {
 	/* MCS rates are used only with 11n */
+	7,                            /* CONF_HW_RXTX_RATE_MCS7_SGI */
 	7,                            /* CONF_HW_RXTX_RATE_MCS7 */
 	6,                            /* CONF_HW_RXTX_RATE_MCS6 */
 	5,                            /* CONF_HW_RXTX_RATE_MCS5 */
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index f95112f..ee313e7 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -766,10 +766,14 @@ out:
 
 static u8 wl1271_tx_get_rate_flags(u8 rate_class_index)
 {
+	u8 flags = 0;
+
 	if (rate_class_index >= CONF_HW_RXTX_RATE_MCS_MIN &&
 	    rate_class_index <= CONF_HW_RXTX_RATE_MCS_MAX)
-		return IEEE80211_TX_RC_MCS;
-	return 0;
+		flags |= IEEE80211_TX_RC_MCS;
+	if (rate_class_index == CONF_HW_RXTX_RATE_MCS7_SGI)
+		flags |= IEEE80211_TX_RC_SHORT_GI;
+	return flags;
 }
 
 static void wl1271_tx_complete_packet(struct wl1271 *wl,
-- 
1.7.6.401.g6a319

