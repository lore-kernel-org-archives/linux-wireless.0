Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:42983 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaCRN7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 09:59:06 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so5498841eek.9
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 06:59:04 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 00/21] cfg80211/mac80211: multi-vif csa
Date: Tue, 18 Mar 2014 14:53:03 +0100
Message-Id: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com> (sfid-20140318_145923_928583_9701DB2D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm aware this is rather huge. I'm hoping I can
get some early feedback before all other patches
I'm depending on are finally merged into
mac80211-next.

Considering current dependency hell of all related
the patchsets I'm duplicating some of my patches
I've posted on the mailing list here. Hopefully
this is sane enough for reviewing purposes.

The patchset alone is based on:
 * mac80211-next/master
 * VLAN chanctx copy refactor
 * Luca's intf combination patches
 * Luca's chanctx reservation patches

I've skipped the 'cfg80211_stop_iface()' since it
depends on a patch from Johannes that hasn't been
merged yet either.

As some probably suspect I've tested this mostly
with ath10k and iwl/mvm. I've been able to
successfully switch multi-BSS AP and perform
AP-follows-STA.

There's a WARN_ON related to chanctx recalc, but
being aware Zhao has some patches around recalc
stuff I decided to ignore it for now.


Michal Kazior (21):
  mac80211: add support for radar detection for reservations
  cfg80211: allow drivers to iterate over matching combinations
  mac80211: add max channel calculation utility function
  mac80211: prevent chanctx overcommit
  mac80211: track assigned vifs in chanctx
  mac80211: track reserved vifs in chanctx
  mac80211: improve find_chanctx() for reservations
  mac80211: improve chanctx reservation lookup
  mac80211: split ieee80211_new_chanctx()
  mac80211: split ieee80211_free_chanctx()
  mac80211: fix racy usage of chanctx->refcount
  mac80211: compute chanctx refcount on-the-fly
  mac80211: implement multi-vif in-place reservations
  mac80211: fix CSA tx queue locking
  mac80211: split CSA finalize function
  mac80211: make check_combinations() aware of chanctx reservation
  mac80211: use chanctx reservation for AP CSA
  mac80211: use chanctx reservation for STA CSA
  mac80211: ignore cqm during csa
  mac80211: remove old unused channel switching code
  cfg80211: remove channel_switch combination check

 include/net/cfg80211.h     |  27 ++
 include/net/mac80211.h     |  11 +-
 net/mac80211/cfg.c         | 212 +++++++++++----
 net/mac80211/chan.c        | 663 +++++++++++++++++++++++++++++++--------------
 net/mac80211/ieee80211_i.h |  25 +-
 net/mac80211/iface.c       |   9 +
 net/mac80211/mlme.c        | 117 +++++---
 net/mac80211/util.c        |  80 +++++-
 net/wireless/nl80211.c     |  11 -
 net/wireless/util.c        |  44 ++-
 10 files changed, 867 insertions(+), 332 deletions(-)

-- 
1.8.5.3

