Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59214 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbYJRMVE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2008 08:21:04 -0400
Subject: [PATCH] mac80211: inform userspace of probe/auth/assoc timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 16 Oct 2008 21:44:44 +0200
Message-Id: <1224186284.11127.3.camel@johannes.berg> (sfid-20081018_142109_774406_FC2C5C9A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I noticed that when for some reason [1] the probe or auth times
out, wpa_supplicant doesn't realise this and only tries the next
AP when it runs into its own timeout, which is ten seconds, and
that's quite long. Fix this by making mac80211 notify userspace
that it didn't associate.

[1] my wrt350n in mixed B/G/HT mode often runs into this, maybe
it's because one of the antennas is broken off and for whatever
reason it decides to use that antenna to transmit the response
frames (auth, probe); I do see beacons fine so it's not totally
broken. Works fine in pure-G mode.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Might be worth backporting to stable?

 net/mac80211/mlme.c |    3 +++
 1 file changed, 3 insertions(+)

--- everything.orig/net/mac80211/mlme.c	2008-10-16 20:30:06.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-10-16 21:40:58.000000000 +0200
@@ -763,6 +763,7 @@ static void ieee80211_direct_probe(struc
 		printk(KERN_DEBUG "%s: direct probe to AP %s timed out\n",
 		       sdata->dev->name, print_mac(mac, ifsta->bssid));
 		ifsta->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_sta_send_apinfo(sdata, ifsta);
 		return;
 	}
 
@@ -795,6 +796,7 @@ static void ieee80211_authenticate(struc
 		       " timed out\n",
 		       sdata->dev->name, print_mac(mac, ifsta->bssid));
 		ifsta->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_sta_send_apinfo(sdata, ifsta);
 		return;
 	}
 
@@ -917,6 +919,7 @@ static void ieee80211_associate(struct i
 		       " timed out\n",
 		       sdata->dev->name, print_mac(mac, ifsta->bssid));
 		ifsta->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_sta_send_apinfo(sdata, ifsta);
 		return;
 	}
 


