Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:14616 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbaAULLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 06:11:08 -0500
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@meshcoding.com>
Subject: [RFC 0/5] Export Minstrel best API information via get_station()
Date: Tue, 21 Jan 2014 12:09:46 +0100
Message-Id: <1390302591-3352-1-git-send-email-antonio@meshcoding.com> (sfid-20140121_121110_964228_C6A6B498)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello list,

we (as batman-adv developers) are currently working on a new version of the
our routing protocol which is going to use some Minstrel internal information
to compute the metric.
In particular I am interested in the currently selected bitrate (which Minstrel
selected because it "maximises the throughput") and it's probability of success.

To achieve so I am proposing here a change to the get_station API.
This change is supposed to export the needed information only if the current
driver is using the Minstrel (or Minstrel HT) RC algorithm.

Patch 1 introduced the change in get_station()
Patch 2 add a new rate_control API used to query the RC algorithm and retrieve
        the information. Then it fills the sinfo object.
Patch 3 and 4 are implementing this rate_control API in minstrel and minstrel_ht
Patch 5 exports the get_station API in order to allow other modules to use it.


I already had a discussion with Johannes about this patch being not generic
enough and really focussed on Minstrel only.

However this change will just
introduce a new exported capability in the station_info object: if the driver
does not support it (e.g. it does not use Minstrel) then we simply won't have
this information (like we already do with other capabilities).


Cheers,

p.s. I may need to add some more kerneldoc


Antonio Quartulli (5):
  cfg80211: export minstrel best rate information through get_station()
  mac80211: export minstrel best rate information in set_sta_info()
  mac80211: minstrel - implement get_minstrel_best_rate() API
  mac80211: minstrel_ht - implement get_minstrel_best_rate() API
  cfg80211: implement cfg80211_get_station

 include/net/cfg80211.h             | 28 ++++++++++++++++++++++++++++
 include/net/mac80211.h             | 15 +++++++++++++++
 net/mac80211/cfg.c                 | 15 +++++++++++++++
 net/mac80211/rc80211_minstrel.c    | 12 ++++++++++++
 net/mac80211/rc80211_minstrel_ht.c | 30 ++++++++++++++++++++++++++++++
 net/wireless/nl80211.c             | 22 ++++++++++++++++++++++
 6 files changed, 122 insertions(+)

-- 
1.8.5.3

