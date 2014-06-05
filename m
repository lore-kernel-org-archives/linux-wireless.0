Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:62382 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaFEM3Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 08:29:25 -0400
Received: by mail-we0-f173.google.com with SMTP id u57so1018830wes.32
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2014 05:29:24 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 0/2] mac80211: fix csa counters
Date: Thu,  5 Jun 2014 14:21:35 +0200
Message-Id: <1401970897-21389-1-git-send-email-michal.kazior@tieto.com> (sfid-20140605_142929_087424_52CF452C)
In-Reply-To: <1401345535-22991-1-git-send-email-michal.kazior@tieto.com>
References: <1401345535-22991-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I was seeing strange WARN_ON splat loops and
crashes while I was testing my multi-vif CSA.

CSA counters weren't properly reset and on some
failpaths this caused a mess. There were also
possible SMP inconsitencies/races.


v2:
 * dropped the atomic counter patch
 * fix patch 1

v3:
 * change sizeof(*x) -> sizeof(x[0]) [Johannes]
 * rebase to 1238bbdc6c2cee366eea5ce5d56170b7fdd6ffd7

Michal Kazior (2):
  mac80211: move csa counters from sdata to beacon/presp
  mac80211: use csa counter offsets instead of csa_active

 net/mac80211/cfg.c         |  67 ++++++++++++++++++---------
 net/mac80211/ibss.c        |   2 +-
 net/mac80211/ieee80211_i.h |  16 +++++--
 net/mac80211/mesh.c        |   2 +-
 net/mac80211/tx.c          | 113 +++++++++++++++++++++++++--------------------
 5 files changed, 122 insertions(+), 78 deletions(-)

-- 
1.8.5.3

