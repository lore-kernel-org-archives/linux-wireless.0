Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:55001 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbaCEOcY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 09:32:24 -0500
Received: by mail-ea0-f171.google.com with SMTP id n15so1076684ead.30
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2014 06:32:22 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/4] mac80211/cfg80211: CSA fixes/cleanups
Date: Wed,  5 Mar 2014 15:26:59 +0100
Message-Id: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com> (sfid-20140305_153248_841911_1F92678E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The patchset fixes CSA tx queue locking and
introduces interface teardown upon CSA failure
during finalization.

The patch [3/4] was previously posted as an RFC.
It has been rebased and function documentation
and commit messages were improved since then.

This is based on mac80211-next/master
(5a970df8990d173e7e4092952f2e3da1de69b27d) with
beacon_interval patch[1] applied.

[1]: http://marc.info/?l=linux-wireless&m=139385275518528&w=2


Michal Kazior (4):
  mac80211: fix CSA tx queue locking
  mac80211: split CSA finalize function
  cfg80211: export interface stopping function
  mac80211: disconnect iface if CSA unexpectedly fails

 include/net/cfg80211.h     |  15 +++++
 include/net/mac80211.h     |   4 +-
 net/mac80211/cfg.c         | 153 ++++++++++++++++++++++++++++++++++-----------
 net/mac80211/ieee80211_i.h |   2 +
 net/mac80211/iface.c       |   4 ++
 net/mac80211/mlme.c        |  27 ++++----
 net/wireless/ap.c          |   4 +-
 net/wireless/core.c        |  44 ++++++++++---
 net/wireless/core.h        |   7 +++
 net/wireless/mesh.c        |   4 +-
 net/wireless/trace.h       |  15 +++++
 net/wireless/util.c        |   5 ++
 12 files changed, 222 insertions(+), 62 deletions(-)

-- 
1.8.5.3

