Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:33588 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3JURWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:22:55 -0400
Received: by mail-wg0-f54.google.com with SMTP id c11so7053431wgh.9
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:22:54 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: [PATCH 05/14] ipw2x00: consolidate no-ibss and passive scan to no-ir
Date: Mon, 21 Oct 2013 19:22:29 +0200
Message-Id: <1382376158-25586-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_192257_800139_4589F10E)
In-Reply-To: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ipw2x00/ipw2100.c |  8 +++-----
 drivers/net/wireless/ipw2x00/ipw2200.c | 16 ++++++----------
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index f8ab193..0344d52 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -1928,12 +1928,10 @@ static int ipw2100_wdev_init(struct net_device *dev)
 			bg_band->channels[i].center_freq = geo->bg[i].freq;
 			bg_band->channels[i].hw_value = geo->bg[i].channel;
 			bg_band->channels[i].max_power = geo->bg[i].max_power;
-			if (geo->bg[i].flags & LIBIPW_CH_PASSIVE_ONLY)
+			if (geo->bg[i].flags & (LIBIPW_CH_PASSIVE_ONLY |
+						LIBIPW_CH_NO_IBSS))
 				bg_band->channels[i].flags |=
-					IEEE80211_CHAN_PASSIVE_SCAN;
-			if (geo->bg[i].flags & LIBIPW_CH_NO_IBSS)
-				bg_band->channels[i].flags |=
-					IEEE80211_CHAN_NO_IBSS;
+					IEEE80211_CHAN_NO_IR;
 			if (geo->bg[i].flags & LIBIPW_CH_RADAR_DETECT)
 				bg_band->channels[i].flags |=
 					IEEE80211_CHAN_RADAR;
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index f394af7..1e88b9d 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -11470,12 +11470,10 @@ static int ipw_wdev_init(struct net_device *dev)
 			bg_band->channels[i].center_freq = geo->bg[i].freq;
 			bg_band->channels[i].hw_value = geo->bg[i].channel;
 			bg_band->channels[i].max_power = geo->bg[i].max_power;
-			if (geo->bg[i].flags & LIBIPW_CH_PASSIVE_ONLY)
+			if (geo->bg[i].flags & (LIBIPW_CH_PASSIVE_ONLY |
+						LIBIPW_CH_NO_IBSS))
 				bg_band->channels[i].flags |=
-					IEEE80211_CHAN_PASSIVE_SCAN;
-			if (geo->bg[i].flags & LIBIPW_CH_NO_IBSS)
-				bg_band->channels[i].flags |=
-					IEEE80211_CHAN_NO_IBSS;
+					IEEE80211_CHAN_NO_IR;
 			if (geo->bg[i].flags & LIBIPW_CH_RADAR_DETECT)
 				bg_band->channels[i].flags |=
 					IEEE80211_CHAN_RADAR;
@@ -11509,12 +11507,10 @@ static int ipw_wdev_init(struct net_device *dev)
 			a_band->channels[i].center_freq = geo->a[i].freq;
 			a_band->channels[i].hw_value = geo->a[i].channel;
 			a_band->channels[i].max_power = geo->a[i].max_power;
-			if (geo->a[i].flags & LIBIPW_CH_PASSIVE_ONLY)
-				a_band->channels[i].flags |=
-					IEEE80211_CHAN_PASSIVE_SCAN;
-			if (geo->a[i].flags & LIBIPW_CH_NO_IBSS)
+			if (geo->a[i].flags & (LIBIPW_CH_PASSIVE_ONLY |
+					       LIBIPW_CH_NO_IBSS))
 				a_band->channels[i].flags |=
-					IEEE80211_CHAN_NO_IBSS;
+					IEEE80211_CHAN_NO_IR;
 			if (geo->a[i].flags & LIBIPW_CH_RADAR_DETECT)
 				a_band->channels[i].flags |=
 					IEEE80211_CHAN_RADAR;
-- 
1.8.4.rc3

