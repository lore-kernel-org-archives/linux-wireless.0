Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:63830 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbaBRNhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 08:37:09 -0500
Received: by mail-pd0-f177.google.com with SMTP id x10so16148235pdj.22
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 05:37:08 -0800 (PST)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/7] zd1201: replace function ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}
Date: Tue, 18 Feb 2014 21:36:01 +0800
Message-Id: <53f9c47a038d51d1f0447ddbd384da7692a78d68.1392728354.git.gamerh2o@gmail.com> (sfid-20140218_143714_465171_8208AA7E)
In-Reply-To: <cover.1392728354.git.gamerh2o@gmail.com>
References: <cover.1392728354.git.gamerh2o@gmail.com>
In-Reply-To: <cover.1392728354.git.gamerh2o@gmail.com>
References: <cover.1392728354.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan} with more
generic ieee80211_{channel_to_frequency, frequency_to_channel}.

Function ieee80211_frequency_to_channel() will return 0 if frequency
is not correctly provided, so no need to set channel to 0 explicitly.

Include <net/cfg80211.h> for the defination of IEEE80211_BAND_2GHZ.
Because <net/cfg80211.h> includes <linux/ieee80211.h>, so we can
replace <linux/ieee80211.h> with <net/cfg80211.h>.

This change is a preparation for the removal of function
ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 drivers/net/wireless/zd1201.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/zd1201.c b/drivers/net/wireless/zd1201.c
index d39c417..6f5c793 100644
--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -18,7 +18,7 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/wireless.h>
-#include <linux/ieee80211.h>
+#include <net/cfg80211.h>
 #include <net/iw_handler.h>
 #include <linux/string.h>
 #include <linux/if_arp.h>
@@ -914,11 +914,8 @@ static int zd1201_set_freq(struct net_device *dev,
 
 	if (freq->e == 0)
 		channel = freq->m;
-	else {
-		channel = ieee80211_freq_to_dsss_chan(freq->m);
-		if (channel < 0)
-			channel = 0;
-	}
+	else
+		channel = ieee80211_frequency_to_channel(freq->m);
 
 	err = zd1201_setconfig16(zd, ZD1201_RID_CNFOWNCHANNEL, channel);
 	if (err)
-- 
1.8.5.3

