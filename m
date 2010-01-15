Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:39730 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab0AOB1Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 20:27:25 -0500
Message-ID: <4B4FC46B.6000705@openwrt.org>
Date: Fri, 15 Jan 2010 02:27:07 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/3] mac80211: force use_short_slot=true for 5GHz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Normally 5GHz does not have a concept of long vs short slot time,
however the slot time that it ends up using is the same as for 2.4 GHZ
and use_short_slot == true
Because of that, it makes more sense to force use_short_slot = true
whenever 5 GHz is being used, so that this particular check does not
have to be in every single driver that uses this flag.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -670,6 +670,8 @@ static u32 ieee80211_handle_bss_capabili
 	}

 	use_short_slot = !!(capab & WLAN_CAPABILITY_SHORT_SLOT_TIME);
+	if (sdata->local->hw.conf.channel->band == IEEE80211_BAND_5GHZ)
+		use_short_slot = true;

 	if (use_protection != bss_conf->use_cts_prot) {
 		bss_conf->use_cts_prot = use_protection;
