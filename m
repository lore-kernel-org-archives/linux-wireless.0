Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:48734 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753076AbaJ1Ld5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 07:33:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: johill@sipsolutions.net
Cc: j@w1.fi, linux-wireless@vger.kernel.org
Date: Tue, 28 Oct 2014 13:33:03 +0200
Message-Id: <1414495985-26937-1-git-send-email-luca@coelho.fi> (sfid-20141028_123400_357674_AE0528C7)
Subject: [PATCH 0/2] mac80211: fix HT+ to HT- (and vice-versa) CSA
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

These two patches fix a bug that Jouni found when running his hostap
hwsim test scripts (ap_ht40_csa).  The failure was caused by two
different bugs which are fixed in this patchset.

The first bug was that we were not using the secondary channel offset
IE of beacons for the switch, but the offset of the current channel,
which cause us to use the same offset. 

The second bug was that we were trying to switch at the exact time of
the switch on the station side, which, because of the processing time,
was causing us to be too late.

Luciano Coelho (2):
  mac80211: use secondary channel offset IE also beacons during CSA
  mac80211: schedule the actual switch of the station before CSA count 0

 net/mac80211/ibss.c        |  2 +-
 net/mac80211/ieee80211_i.h |  3 +--
 net/mac80211/mesh.c        |  2 +-
 net/mac80211/mlme.c        |  5 +++--
 net/mac80211/spectmgmt.c   | 18 ++++++------------
 5 files changed, 12 insertions(+), 18 deletions(-)

-- 
2.1.1

