Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:33734 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaCUNxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 09:53:30 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so1849227eek.13
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 06:53:29 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 00/13] cfg80211/mac80211: implement multi-vif chanctx reservations
Date: Fri, 21 Mar 2014 14:47:18 +0100
Message-Id: <1395409651-26120-1-git-send-email-michal.kazior@tieto.com> (sfid-20140321_145334_643184_8F845942)
In-Reply-To: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
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

This is based on Luca's combination and
reservation patches and my CSA fixes/cleanups.


v2:
 * add changelog for refcounting patches
 * fixes for issues pointed out by Eliad


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
 net/mac80211/chan.c        | 597 ++++++++++++++++++++++++++++++++++-----------
 net/mac80211/ieee80211_i.h |  18 +-
 net/mac80211/iface.c       |   2 +
 net/mac80211/mlme.c        |   2 +-
 net/mac80211/util.c        |  43 ++++
 net/wireless/util.c        |  44 +++-
 9 files changed, 592 insertions(+), 167 deletions(-)

-- 
1.8.5.3

