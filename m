Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:46103 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964776AbaEQQnH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 12:43:07 -0400
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: b.a.t.m.a.n@lists.open-mesh.org, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@meshcoding.com>
Subject: [PATCHv3 0/6] Export the expected throughput towards a peer
Date: Sat, 17 May 2014 18:41:42 +0200
Message-Id: <1400344906-27984-1-git-send-email-antonio@meshcoding.com> (sfid-20140517_184319_057162_D09E882F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes since v2:
- fix throughput computation in minstrel
- squash minstrel patches

Changes since v1:
- add expected throughput nl80211 attribute to the GET_STATION reply
  message
- the unit of the exported value has been changed to kbps
- the way the exported value was computed in minstrel and minstrel_ht has been
  changed after having really understood what minstrel is doing (thanks
  Johannes!)
- the number of arguments of the RC api have been reduced
- allow the API result to be 0 if the underlying layer does not know what to
  report
- squash ex patch 2/3/4
- use wiphy_to_rdev() where needed


Antonio Quartulli (4):
  cfg80211: export expected throughput through get_station()
  cfg80211: export expected throughput via nl80211 (GET_STATION)
  mac80211: export the expected throughput
  cfg80211: implement cfg80211_get_station cfg80211 API

 include/net/cfg80211.h             | 75 ++++++++++++++++++++++++--------------
 include/net/mac80211.h             |  7 ++++
 include/uapi/linux/nl80211.h       |  3 ++
 net/mac80211/cfg.c                 | 19 ++++++++++
 net/mac80211/driver-ops.h          | 13 +++++++
 net/mac80211/rc80211_minstrel.c    | 12 ++++++
 net/mac80211/rc80211_minstrel_ht.c | 17 +++++++++
 net/mac80211/trace.h               | 32 ++++++++++++++++
 net/wireless/nl80211.c             |  4 ++
 net/wireless/util.c                | 18 +++++++++
 10 files changed, 172 insertions(+), 28 deletions(-)

-- 
1.8.5.5

