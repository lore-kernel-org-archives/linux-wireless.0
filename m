Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:44999 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaEVOPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 10:15:06 -0400
Received: by mail-ee0-f48.google.com with SMTP id e49so2645582eek.7
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 07:15:05 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luca@coelho.fi,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v6 0/6] cfg/mac80211: implement multi-vif csa
Date: Thu, 22 May 2014 16:07:50 +0200
Message-Id: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com> (sfid-20140522_161513_080677_826D261E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've added a switch_vif_chanctx patch as discussed
earlier and refactored the multi-vif reservations.

I've merged that with my other multi-vif csa
patches as to not post hundreds of patchsets
separately.

This is based on my csa counter fixes. Otherwise
there are 2 or 3 conflicts.


Michal Kazior (6):
  mac80211: introduce switch_vif_chanctx op
  mac80211: implement multi-vif in-place reservations
  mac80211: make check_combinations() aware of chanctx reservation
  mac80211: use chanctx reservation for AP CSA
  mac80211: use chanctx reservation for STA CSA
  cfg80211: remove channel_switch combination check

 include/net/mac80211.h     |  36 +++-
 net/mac80211/cfg.c         |  82 ++++++---
 net/mac80211/chan.c        | 407 ++++++++++++++++++++++++++++++---------------
 net/mac80211/driver-ops.h  |  36 ++++
 net/mac80211/ieee80211_i.h |   9 +-
 net/mac80211/main.c        |   2 +
 net/mac80211/mlme.c        |  94 +++++++----
 net/mac80211/trace.h       | 111 +++++++++++++
 net/mac80211/util.c        |  39 ++++-
 net/wireless/nl80211.c     |  11 --
 10 files changed, 602 insertions(+), 225 deletions(-)

-- 
1.8.5.3

