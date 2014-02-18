Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:56898 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbaBRNgu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 08:36:50 -0500
Received: by mail-pa0-f49.google.com with SMTP id hz1so16550975pad.8
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 05:36:49 -0800 (PST)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>,
	Simon Kelley <simon@thekelleys.org.uk>
Subject: [PATCH 2/7] atmel: replace function ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}
Date: Tue, 18 Feb 2014 21:35:58 +0800
Message-Id: <932b911b4d6dd9f111bd50806e5ec84a7e5fae1a.1392728354.git.gamerh2o@gmail.com> (sfid-20140218_143654_333002_8F9A124D)
In-Reply-To: <cover.1392728354.git.gamerh2o@gmail.com>
References: <cover.1392728354.git.gamerh2o@gmail.com>
In-Reply-To: <cover.1392728354.git.gamerh2o@gmail.com>
References: <cover.1392728354.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan} with more
generic ieee80211_{channel_to_frequency, frequency_to_channel}.

Include <net/cfg80211.h> for the defination of IEEE80211_BAND_2GHZ.
Because <net/cfg80211.h> includes <linux/ieee80211.h>, so we can
replace <linux/ieee80211.h> with <net/cfg80211.h>.

This change is a preparation for the removal of function
ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}.

Cc: Simon Kelley <simon@thekelleys.org.uk>
Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 drivers/net/wireless/atmel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index bf93ea8..1fe41af 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -67,7 +67,7 @@
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
 #include <linux/jiffies.h>
-#include <linux/ieee80211.h>
+#include <net/cfg80211.h>
 #include "atmel.h"
 
 #define DRIVER_MAJOR 0
@@ -2273,7 +2273,7 @@ static int atmel_set_freq(struct net_device *dev,
 
 		/* Hack to fall through... */
 		fwrq->e = 0;
-		fwrq->m = ieee80211_freq_to_dsss_chan(f);
+		fwrq->m = ieee80211_frequency_to_channel(f);
 	}
 	/* Setting by channel number */
 	if ((fwrq->m > 1000) || (fwrq->e > 0))
@@ -2434,8 +2434,8 @@ static int atmel_get_range(struct net_device *dev,
 			range->freq[k].i = i; /* List index */
 
 			/* Values in MHz -> * 10^5 * 10 */
-			range->freq[k].m = (ieee80211_dsss_chan_to_freq(i) *
-					    100000);
+			range->freq[k].m = 100000 *
+			 ieee80211_channel_to_frequency(i, IEEE80211_BAND_2GHZ);
 			range->freq[k++].e = 1;
 		}
 		range->num_frequency = k;
-- 
1.8.5.3

