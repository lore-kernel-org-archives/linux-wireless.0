Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:50264 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaAOMJ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 07:09:29 -0500
Received: by mail-ee0-f47.google.com with SMTP id d49so57503eek.6
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 04:09:24 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 0/9] mac80211: multi-interface CSA
Date: Wed, 15 Jan 2014 13:04:45 +0100
Message-Id: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com> (sfid-20140115_130935_643340_9DEFE9A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchet bases of my recently posted cfg80211
multi-interface CSA patchset.

Probably some patches in this patchset can be
cherry-picked regardless if the multi-interface
CSA itself is accepted or not.

I'm planning on posting properly split patchsets
after getting some feedback on the mac80211 part.

For anyone interested in getting the whole thing
easily (cfg80211 is not yet fixed there as per
Johaness' comments):

	https://github.com/kazikcz/linux/tree/multi-interface-csa-review-2014-01-15-1
	https://github.com/kazikcz/hostap/tree/multi-interface-csa-review-2014-01-15-1

I've tested it a bit and it seems to work with
ath9k and ath10k (with some local patches).


Michal Kazior (9):
  mac80211: fix possible memory leak on AP CSA failure
  mac80211: treat IBSS CSA finish failure seriously
  mac80211: move csa_active setting in STA CSA
  mac80211: fix sdata->radar_required locking
  mac80211: improve CSA locking
  mac80211: track CSA globally
  Revert "cfg80211: disable CSA for all drivers"
  ath9k: prepare for multi-interface CSA support
  mac80211: implement multi-interface CSA

 drivers/net/wireless/ath/ath9k/ath9k.h  |   4 +-
 drivers/net/wireless/ath/ath9k/beacon.c |  29 ++-
 drivers/net/wireless/ath/ath9k/main.c   |  12 +-
 drivers/net/wireless/ath/ath9k/xmit.c   |   2 +-
 net/mac80211/cfg.c                      | 419 ++++++++++++++++++++++++++------
 net/mac80211/chan.c                     | 117 ++++++---
 net/mac80211/ibss.c                     |  42 +++-
 net/mac80211/ieee80211_i.h              |  24 +-
 net/mac80211/iface.c                    |  39 ++-
 net/mac80211/mesh.c                     |  16 +-
 net/mac80211/mlme.c                     |  37 ++-
 net/mac80211/scan.c                     |   5 +
 net/mac80211/tx.c                       |  10 +-
 net/mac80211/util.c                     |  18 ++
 net/wireless/core.c                     |   6 -
 15 files changed, 606 insertions(+), 174 deletions(-)

-- 
1.8.4.rc3

