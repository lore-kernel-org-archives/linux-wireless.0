Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42112 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbYIKT1Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 15:27:16 -0400
Subject: Re: [PATCH v2 18/18] mac80211 hwsim: verify sta pointers
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1221092221.3804.64.camel@johannes.berg> (sfid-20080911_021750_311355_0C7FD146)
References: <20080910220145.707263000@sipsolutions.net>
	 <20080910220428.687397000@sipsolutions.net>
	 (sfid-20080911_001645_613218_891667FD)  <1221092221.3804.64.camel@johannes.berg>
	 (sfid-20080911_021750_311355_0C7FD146)
Content-Type: text/plain
Date: Thu, 11 Sep 2008 21:26:39 +0200
Message-Id: <1221161199.6986.61.camel@johannes.berg> (sfid-20080911_212719_937682_A327F78D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oh, I forgot the hunk below, I can resend after I reboot...

---
 drivers/net/wireless/mac80211_hwsim.c |    1 +
 1 file changed, 1 insertion(+)

--- everything.orig/drivers/net/wireless/mac80211_hwsim.c	2008-09-11 21:21:15.000000000 +0200
+++ everything/drivers/net/wireless/mac80211_hwsim.c	2008-09-11 21:21:29.000000000 +0200
@@ -553,6 +553,7 @@ static int __init init_mac80211_hwsim(vo
 
 		/* ask mac80211 to reserve space for magic */
 		hw->vif_data_size = sizeof(struct hwsim_vif_priv);
+		hw->sta_data_size = sizeof(struct hwsim_sta_priv);
 
 		memcpy(data->channels, hwsim_channels, sizeof(hwsim_channels));
 		memcpy(data->rates, hwsim_rates, sizeof(hwsim_rates));


