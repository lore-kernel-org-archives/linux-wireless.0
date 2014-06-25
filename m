Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34546 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbaFYKn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 06:43:58 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so7723522wib.17
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 03:43:57 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: luca@coelho.fi, johannes@sipsolutions.net,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v11 0/5] cfg/mac80211: implement multi-vif csa
Date: Wed, 25 Jun 2014 12:35:05 +0200
Message-Id: <1403692510-27873-1-git-send-email-michal.kazior@tieto.com> (sfid-20140625_124401_856501_E69C72E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The patchset implements multi-interface
reservations and multi-interface channel
switching.

There are still some cases that aren't handled
well (at least degradation of number of channels
due to interface combinations that I'm aware of).


v11:
 * rebase to latest mac80211-next/master
   (eb6a61549f530f1cc435512df3799f656094ba83)
 * lots of fixes (see notes in [1/5])


Michal Kazior (5):
  mac80211: implement multi-vif in-place reservations
  mac80211: make check_combinations() aware of chanctx reservation
  mac80211: use chanctx reservation for AP CSA
  mac80211: use chanctx reservation for STA CSA
  cfg80211: remove channel_switch combination check

 include/net/cfg80211.h     |   7 +-
 include/net/mac80211.h     |   8 +-
 net/mac80211/cfg.c         |  82 +++--
 net/mac80211/chan.c        | 861 +++++++++++++++++++++++++++++++++++++--------
 net/mac80211/ieee80211_i.h |  31 +-
 net/mac80211/mlme.c        |  99 ++++--
 net/mac80211/util.c        |  44 ++-
 net/wireless/nl80211.c     |  11 -
 8 files changed, 906 insertions(+), 237 deletions(-)

-- 
1.8.5.3

