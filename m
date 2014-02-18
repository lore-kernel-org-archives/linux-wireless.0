Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:61580 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbaBRNg5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 08:36:57 -0500
Received: by mail-pb0-f54.google.com with SMTP id uo5so16786611pbc.13
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 05:36:56 -0800 (PST)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 3/7] wl3501_cs: replace function ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}
Date: Tue, 18 Feb 2014 21:35:59 +0800
Message-Id: <cb7033ca6638a9c3e4e87025e9e6a5f8edde25f5.1392728354.git.gamerh2o@gmail.com> (sfid-20140218_143701_058994_DB8BF968)
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

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 drivers/net/wireless/wl3501_cs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index d24d4a9..5c33744 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -42,7 +42,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/wireless.h>
-#include <linux/ieee80211.h>
+#include <net/cfg80211.h>
 #include <linux/etherdevice.h>
 
 #include <net/iw_handler.h>
@@ -1454,7 +1454,8 @@ static int wl3501_get_freq(struct net_device *dev, struct iw_request_info *info,
 {
 	struct wl3501_card *this = netdev_priv(dev);
 
-	wrqu->freq.m = ieee80211_dsss_chan_to_freq(this->chan) * 100000;
+	wrqu->freq.m = 100000 *
+		ieee80211_channel_to_frequency(this->chan, IEEE80211_BAND_2GHZ);
 	wrqu->freq.e = 1;
 	return 0;
 }
-- 
1.8.5.3

