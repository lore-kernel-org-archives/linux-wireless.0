Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:58928 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbaBRNhE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 08:37:04 -0500
Received: by mail-pd0-f176.google.com with SMTP id w10so16197110pde.7
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 05:37:04 -0800 (PST)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 4/7] rndis_wlan: replace function ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}
Date: Tue, 18 Feb 2014 21:36:00 +0800
Message-Id: <739118d37ea1665be929e90dc656a02f32ba7d7b.1392728354.git.gamerh2o@gmail.com> (sfid-20140218_143710_885146_D7CF8A40)
In-Reply-To: <cover.1392728354.git.gamerh2o@gmail.com>
References: <cover.1392728354.git.gamerh2o@gmail.com>
In-Reply-To: <cover.1392728354.git.gamerh2o@gmail.com>
References: <cover.1392728354.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan} with more
generic ieee80211_{channel_to_frequency, frequency_to_channel}.

File <net/cfg80211.h> has already been included. It's safe to use
IEEE80211_BAND_2GHZ here.

This change is a preparation for the removal of function
ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}.

Cc: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 drivers/net/wireless/rndis_wlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 2e89a86..39d22a1 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1290,7 +1290,8 @@ static int set_channel(struct usbnet *usbdev, int channel)
 	if (is_associated(usbdev))
 		return 0;
 
-	dsconfig = ieee80211_dsss_chan_to_freq(channel) * 1000;
+	dsconfig = 1000 *
+		ieee80211_channel_to_frequency(channel, IEEE80211_BAND_2GHZ);
 
 	len = sizeof(config);
 	ret = rndis_query_oid(usbdev,
-- 
1.8.5.3

