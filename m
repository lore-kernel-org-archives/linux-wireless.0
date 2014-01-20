Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:41651 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaATOZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 09:25:38 -0500
Received: by mail-ee0-f41.google.com with SMTP id e49so3495592eek.14
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 06:25:37 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/7] mac80211: CSA related fixes
Date: Mon, 20 Jan 2014 15:21:03 +0100
Message-Id: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com> (sfid-20140120_152542_009331_C6B4E3F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This cleans up some CSA related stuff and notably
tries to fix locking issues.

Now local->mtx is used along with sdata lock to
secure vif->csa_active modification. Addition of
local->mtx makes it possible to check
vif->csa_active on all interfaces safely.

The last patch (the revert) is more of a
suggestion. 

I've decided to include the radar patch here as
well.

This patchset is required to support
multi-interface CSA in mac80211. 


Changes since RFC:

 * rebase on top of mac80211-next and adjust to
   some IBSS/mesh changes

 * fix typo in commit message of `move
   csa_active seting in STA CSA`

 * remove `track CSA globally`

 * add `deny attempts at using chanctx during CSA`
   (it takes a little bit of code from the removed
    `track CSA globally` and `implement
     multi-interface CSA`)


Michal Kazior (7):
  mac80211: fix possible memory leak on AP CSA failure
  mac80211: treat IBSS CSA finish failure seriously
  mac80211: move csa_active setting in STA CSA
  mac80211: fix sdata->radar_required locking
  mac80211: improve CSA locking
  mac80211: deny attempts at using chanctx during CSA
  Revert "cfg80211: disable CSA for all drivers"

 net/mac80211/cfg.c         | 51 +++++++++++++++++++++++++++++++++++-----------
 net/mac80211/chan.c        |  7 +++++++
 net/mac80211/ibss.c        | 20 +++++++++++++-----
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/iface.c       | 28 +++++++++++++++++++++++--
 net/mac80211/mesh.c        | 18 ++++++++++++++--
 net/mac80211/mlme.c        | 22 +++++++++++++-------
 net/mac80211/util.c        | 18 ++++++++++++++++
 net/wireless/core.c        |  6 ------
 9 files changed, 137 insertions(+), 34 deletions(-)

-- 
1.8.4.rc3

