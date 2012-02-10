Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40242 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab2BJAW3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 19:22:29 -0500
Received: by daed14 with SMTP id d14so1901388dae.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 16:22:28 -0800 (PST)
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: [PATCH] ipw2x00: remove ipw2100_rates_11b[]
Date: Thu,  9 Feb 2012 20:23:52 -0500
Message-Id: <1328837032-26137-1-git-send-email-stas.yakovlev@gmail.com> (sfid-20120210_012232_282377_0F8560C0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's just a duplicate of ipw2100_bg_rates[].

Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
---
 drivers/net/wireless/ipw2x00/ipw2100.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index a0e5c21..63567fb 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -309,13 +309,6 @@ static const long ipw2100_frequencies[] = {
 
 #define FREQ_COUNT	ARRAY_SIZE(ipw2100_frequencies)
 
-static const long ipw2100_rates_11b[] = {
-	1000000,
-	2000000,
-	5500000,
-	11000000
-};
-
 static struct ieee80211_rate ipw2100_bg_rates[] = {
 	{ .bitrate = 10 },
 	{ .bitrate = 20, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
@@ -323,7 +316,7 @@ static struct ieee80211_rate ipw2100_bg_rates[] = {
 	{ .bitrate = 110, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
 };
 
-#define RATE_COUNT ARRAY_SIZE(ipw2100_rates_11b)
+#define RATE_COUNT ARRAY_SIZE(ipw2100_bg_rates)
 
 /* Pre-decl until we get the code solid and then we can clean it up */
 static void ipw2100_tx_send_commands(struct ipw2100_priv *priv);
@@ -6896,7 +6889,7 @@ static int ipw2100_wx_get_range(struct net_device *dev,
 	range->num_bitrates = RATE_COUNT;
 
 	for (i = 0; i < RATE_COUNT && i < IW_MAX_BITRATES; i++) {
-		range->bitrate[i] = ipw2100_rates_11b[i];
+		range->bitrate[i] = ipw2100_bg_rates[i].bitrate * 100 * 1000;
 	}
 
 	range->min_rts = MIN_RTS_THRESHOLD;
-- 
1.7.2.5

