Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35166 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaCaMKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 08:10:19 -0400
Received: by mail-wg0-f42.google.com with SMTP id y10so5681522wgg.25
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 05:10:18 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 0/5] cfg80211/mac80211: implement multi-vif csa
Date: Mon, 31 Mar 2014 14:04:14 +0200
Message-Id: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com> (sfid-20140331_141030_257036_75774C55)
In-Reply-To: <1395409941-26303-1-git-send-email-michal.kazior@tieto.com>
References: <1395409941-26303-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is another part of my recent RFC. This is
just the channel switching part.

This is based on my patchset implementing
multi-vif chanctx reservations.

This effectively enables multi-vif CSA for
STA/AP/IBSS/mesh.


v2:
 * add radar_detect fix patch (wasn't present in
   the big RFC)

v3:
 * remove radar_detect fix patch (it was
   cherry-picked)
 * squash removal of ieee80211_vif_change_channel() [Johannes]
 * cleanups [Johannes]
 * add resilience for calling ieee80211_csa_finish() and
   ieee80211_chswitch_done() more than once (the
   problem was originally discussed in `ath10k: dont call csa_finish
   more than once`)


Michal Kazior (5):
  mac80211: make check_combinations() aware of chanctx reservation
  mac80211: use chanctx reservation for AP CSA
  mac80211: use chanctx reservation for STA CSA
  mac80211: ignore cqm during csa
  cfg80211: remove channel_switch combination check

 net/mac80211/cfg.c         |  82 ++++++++++++++++++++++++------------
 net/mac80211/chan.c        |  79 ++++++----------------------------
 net/mac80211/ieee80211_i.h |   5 ---
 net/mac80211/mlme.c        | 103 ++++++++++++++++++++++++++++++---------------
 net/mac80211/util.c        |  39 ++++++++++++++++-
 net/wireless/nl80211.c     |  11 -----
 6 files changed, 176 insertions(+), 143 deletions(-)

-- 
1.8.5.3

