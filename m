Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:34003 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752370AbZIZTaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 15:30:17 -0400
Date: Sat, 26 Sep 2009 22:30:15 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211_hwsim: Fix initial beacon timer configuration
Message-ID: <20090926193015.GA27296@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211_hwsim does not start transmitting Beacon frames when hostapd
is started for the first time and restarting hostapd fixes this. The
issue is caused by the config() handler not being able to start
beacon_timer when beacon interval is not yet known and
bss_info_changed() handler not starting the timer. This can be fixed by
making the bss_info_changed() update the timer.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 drivers/net/wireless/mac80211_hwsim.c |    3 +++
 1 file changed, 3 insertions(+)

--- uml.orig/drivers/net/wireless/mac80211_hwsim.c	2009-09-26 21:36:08.000000000 +0300
+++ uml/drivers/net/wireless/mac80211_hwsim.c	2009-09-26 22:21:58.000000000 +0300
@@ -639,6 +639,9 @@ static void mac80211_hwsim_bss_info_chan
 		data->beacon_int = 1024 * info->beacon_int / 1000 * HZ / 1000;
 		if (WARN_ON(!data->beacon_int))
 			data->beacon_int = 1;
+		if (data->started)
+			mod_timer(&data->beacon_timer,
+				  jiffies + data->beacon_int);
 	}
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {

-- 
Jouni Malinen                                            PGP id EFC895FA
