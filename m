Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:57692 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbaCaKD2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 06:03:28 -0400
Received: by mail-wg0-f46.google.com with SMTP id b13so5708146wgh.5
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 03:03:27 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 0/4] mac80211/cfg80211: CSA fixes/cleanups
Date: Mon, 31 Mar 2014 11:57:17 +0200
Message-Id: <1396259841-6359-1-git-send-email-michal.kazior@tieto.com> (sfid-20140331_120332_110796_5B80A593)
In-Reply-To: <1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
References: <1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
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

