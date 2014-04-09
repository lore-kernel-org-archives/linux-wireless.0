Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:36594 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbaDINRR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 09:17:17 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so1865042eek.20
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 06:17:16 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luca@coelho.fi,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 0/4] mac80211/cfg80211: CSA fixes/cleanups
Date: Wed,  9 Apr 2014 15:10:58 +0200
Message-Id: <1397049062-24177-1-git-send-email-michal.kazior@tieto.com> (sfid-20140409_151731_917906_103647C0)
In-Reply-To: <1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
References: <1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The patchset fixes CSA tx queue locking and
introduces interface teardown upon CSA failure
during finalization.

v2:
 * get rid of idempotency

v3:
 * fixes (see each commit)

v4:
 * commit message fixes
 * remove WARN_ON as discussed

Michal Kazior (4):
  mac80211: fix CSA tx queue locking
  mac80211: split CSA finalize function
  cfg80211: export interface stopping function
  mac80211: disconnect iface if CSA unexpectedly fails

 include/net/cfg80211.h     |  15 +++++
 include/net/mac80211.h     |   4 +-
 net/mac80211/cfg.c         | 144 +++++++++++++++++++++++++++++++++------------
 net/mac80211/ieee80211_i.h |   2 +
 net/mac80211/iface.c       |   7 +++
 net/mac80211/mlme.c        |  37 +++++++++---
 net/wireless/ap.c          |   4 +-
 net/wireless/core.c        |  43 +++++++++++---
 net/wireless/core.h        |   7 +++
 net/wireless/mesh.c        |   4 +-
 net/wireless/trace.h       |  15 +++++
 net/wireless/util.c        |   3 +
 12 files changed, 228 insertions(+), 57 deletions(-)

-- 
1.8.5.3

