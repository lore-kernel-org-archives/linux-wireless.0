Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38168 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab2CTVtx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 17:49:53 -0400
Received: by dajr28 with SMTP id r28so570375daj.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2012 14:49:53 -0700 (PDT)
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: [PATCH] net/wireless: ipw2x00: fix a typo in wiphy struct initilization
Date: Tue, 20 Mar 2012 17:52:57 -0400
Message-Id: <1332280377-3027-1-git-send-email-stas.yakovlev@gmail.com> (sfid-20120320_224957_312054_80250198)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix comment as well.

Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
---
 drivers/net/wireless/ipw2x00/ipw2200.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 4fcdac6..2b02257 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -11507,9 +11507,9 @@ static int ipw_wdev_init(struct net_device *dev)
 			rc = -ENOMEM;
 			goto out;
 		}
-		/* translate geo->bg to a_band.channels */
+		/* translate geo->a to a_band.channels */
 		for (i = 0; i < geo->a_channels; i++) {
-			a_band->channels[i].band = IEEE80211_BAND_2GHZ;
+			a_band->channels[i].band = IEEE80211_BAND_5GHZ;
 			a_band->channels[i].center_freq = geo->a[i].freq;
 			a_band->channels[i].hw_value = geo->a[i].channel;
 			a_band->channels[i].max_power = geo->a[i].max_power;
-- 
1.7.2.5

