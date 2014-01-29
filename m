Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:56292 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbaA2HBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 02:01:18 -0500
Received: by mail-ee0-f49.google.com with SMTP id d17so663270eek.22
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jan 2014 23:01:17 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/5] mac80211: minor CSA fixes
Date: Wed, 29 Jan 2014 07:56:16 +0100
Message-Id: <1390978581-13273-1-git-send-email-michal.kazior@tieto.com> (sfid-20140129_080203_857917_9C52C933)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

These are some patches from my multi-interface
patchset. It's probably a good idea to apply them
regardless of current multi-interface
implementation acceptance.

I've updated the patches according to feedback on
the mailing list.

The odd one here seems to be sdata->radar_required
fix although it is related to CSA.

The last one is a split from the original CSA
locking patch. I've skipped the part that adds
local->mtx locking to CSA. It only makes sense
with my current multi-interface CSA. Since the
plan is to make CSA more chanctx oriented it
actually might be better to use chanctx instead of
mtx for CSA locking purposes.

Michal Kazior (5):
  mac80211: batch CSA bss info notification
  mac80211: fix possible memory leak on AP CSA failure
  mac80211: move csa_active setting in STA CSA
  mac80211: fix sdata->radar_required locking
  mac80211: add missing CSA locking

 net/mac80211/cfg.c   | 30 ++++++++++++++++++++----------
 net/mac80211/chan.c  |  2 ++
 net/mac80211/ibss.c  | 11 ++++++-----
 net/mac80211/iface.c |  2 ++
 net/mac80211/mesh.c  |  7 +++++--
 net/mac80211/mlme.c  |  2 +-
 6 files changed, 36 insertions(+), 18 deletions(-)

-- 
1.8.5.3

