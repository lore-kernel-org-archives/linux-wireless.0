Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:47309 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbaBRNgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 08:36:35 -0500
Received: by mail-pd0-f171.google.com with SMTP id g10so16175012pdj.16
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 05:36:34 -0800 (PST)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/7] airo: replace function ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}
Date: Tue, 18 Feb 2014 21:35:57 +0800
Message-Id: <742c546a3d3e149d833b4202c91965b4eb621bd6.1392728354.git.gamerh2o@gmail.com> (sfid-20140218_143641_640246_D0D22C2D)
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

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 drivers/net/wireless/airo.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index edf4b57..2e6cb64 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -49,7 +49,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
-#include <linux/ieee80211.h>
+#include <net/cfg80211.h>
 #include <net/iw_handler.h>
 
 #include "airo.h"
@@ -5797,7 +5797,7 @@ static int airo_set_freq(struct net_device *dev,
 
 		/* Hack to fall through... */
 		fwrq->e = 0;
-		fwrq->m = ieee80211_freq_to_dsss_chan(f);
+		fwrq->m = ieee80211_frequency_to_channel(f);
 	}
 	/* Setting by channel number */
 	if((fwrq->m > 1000) || (fwrq->e > 0))
@@ -5841,7 +5841,8 @@ static int airo_get_freq(struct net_device *dev,
 
 	ch = le16_to_cpu(status_rid.channel);
 	if((ch > 0) && (ch < 15)) {
-		fwrq->m = ieee80211_dsss_chan_to_freq(ch) * 100000;
+		fwrq->m = 100000 *
+			ieee80211_channel_to_frequency(ch, IEEE80211_BAND_2GHZ);
 		fwrq->e = 1;
 	} else {
 		fwrq->m = ch;
@@ -6898,7 +6899,8 @@ static int airo_get_range(struct net_device *dev,
 	k = 0;
 	for(i = 0; i < 14; i++) {
 		range->freq[k].i = i + 1; /* List index */
-		range->freq[k].m = ieee80211_dsss_chan_to_freq(i + 1) * 100000;
+		range->freq[k].m = 100000 *
+		     ieee80211_channel_to_frequency(i + 1, IEEE80211_BAND_2GHZ);
 		range->freq[k++].e = 1;	/* Values in MHz -> * 10^5 * 10 */
 	}
 	range->num_frequency = k;
@@ -7297,7 +7299,8 @@ static inline char *airo_translate_scan(struct net_device *dev,
 	/* Add frequency */
 	iwe.cmd = SIOCGIWFREQ;
 	iwe.u.freq.m = le16_to_cpu(bss->dsChannel);
-	iwe.u.freq.m = ieee80211_dsss_chan_to_freq(iwe.u.freq.m) * 100000;
+	iwe.u.freq.m = 100000 *
+	      ieee80211_channel_to_frequency(iwe.u.freq.m, IEEE80211_BAND_2GHZ);
 	iwe.u.freq.e = 1;
 	current_ev = iwe_stream_add_event(info, current_ev, end_buf,
 					  &iwe, IW_EV_FREQ_LEN);
-- 
1.8.5.3

