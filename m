Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:62051 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932748AbaDINfv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 09:35:51 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so1885791eek.23
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 06:35:50 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luca@coelho.fi,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 00/13] cfg80211/mac80211: implement multi-vif chanctx reservations
Date: Wed,  9 Apr 2014 15:29:21 +0200
Message-Id: <1397050174-26121-1-git-send-email-michal.kazior@tieto.com> (sfid-20140409_153554_997332_F38AF357)
In-Reply-To: <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
References: <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is part of my multi-vif csa work. These
patches have been included in my recent big RFC.
I'm trying to split it up a bit.

The patchset incrementally improves chanctx
reservations in order to support multi-vif
reservations and in-place multi-vif reservations
(typically for single-channel hardware, but
multi-channel benefits from this too).

Some of the patches (the refcounting) were also
posted a while ago as a separate small RFC.

This is rebased on mac80211-next/master (the one
rebased today) and my CSA fixes/cleanups now.

v2:
 * add changelog for refcounting patches
 * fixes for issues pointed out by Eliad

v3:
 * fix commit messages

v4:
 * remove unnecessary braces
 * fixes to the in-place reservation code ordering


Michal Kazior (13):
  cfg80211: allow drivers to iterate over matching combinations
  mac80211: add max channel calculation utility function
  mac80211: prevent chanctx overcommit
  mac80211: add support for radar detection for reservations
  mac80211: track assigned vifs in chanctx
  mac80211: track reserved vifs in chanctx
  mac80211: improve find_chanctx() for reservations
  mac80211: improve chanctx reservation lookup
  mac80211: split ieee80211_new_chanctx()
  mac80211: split ieee80211_free_chanctx()
  mac80211: fix racy usage of chanctx->refcount
  mac80211: compute chanctx refcount on-the-fly
  mac80211: implement multi-vif in-place reservations

 include/net/cfg80211.h     |  27 ++
 include/net/mac80211.h     |   7 -
 net/mac80211/cfg.c         |  19 +-
 net/mac80211/chan.c        | 598 ++++++++++++++++++++++++++++++++++-----------
 net/mac80211/ieee80211_i.h |  18 +-
 net/mac80211/iface.c       |   2 +
 net/mac80211/mlme.c        |   2 +-
 net/mac80211/util.c        |  42 ++++
 net/wireless/util.c        |  44 +++-
 9 files changed, 592 insertions(+), 167 deletions(-)

-- 
1.8.5.3

