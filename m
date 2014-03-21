Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40330 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaCUNhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 09:37:15 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so1817967eei.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 06:37:13 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/4] mac80211/cfg80211: CSA fixes/cleanups
Date: Fri, 21 Mar 2014 14:31:11 +0100
Message-Id: <1395408675-26013-1-git-send-email-michal.kazior@tieto.com> (sfid-20140321_143721_711931_871DD430)
In-Reply-To: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com>
References: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The patchset fixes CSA tx queue locking and
introduces interface teardown upon CSA failure
during finalization.

I originally posted this some time ago.

First two patches have been included in my recent
RFC for general multi-vif csa changeset overview
purposes. Hopefully this isn't too confusing..

v2:
 * get rid of idempotency

Michal Kazior (4):
  mac80211: fix CSA tx queue locking
  mac80211: split CSA finalize function
  cfg80211: export interface stopping function
  mac80211: disconnect iface if CSA unexpectedly fails

 include/net/cfg80211.h     |  15 +++++
 include/net/mac80211.h     |   4 +-
 net/mac80211/cfg.c         | 148 +++++++++++++++++++++++++++++++++------------
 net/mac80211/ieee80211_i.h |   2 +
 net/mac80211/iface.c       |   7 +++
 net/mac80211/mlme.c        |  30 ++++++---
 net/wireless/ap.c          |   4 +-
 net/wireless/core.c        |  44 +++++++++++---
 net/wireless/core.h        |   7 +++
 net/wireless/mesh.c        |   4 +-
 net/wireless/trace.h       |  15 +++++
 net/wireless/util.c        |   5 ++
 12 files changed, 226 insertions(+), 59 deletions(-)

-- 
1.8.5.3

