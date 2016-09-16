Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59375 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755491AbcIPMr3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2016 08:47:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2016-09-16
Date: Fri, 16 Sep 2016 14:47:22 +0200
Message-Id: <1474030043-16094-1-git-send-email-johannes@sipsolutions.net> (sfid-20160916_144734_392704_E0B5BCB6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Sorry - I know you only just pulled my tree for the previous fixes,
but we found two more problems in the last few days; it'd be great
to get those fixes in as well.

Let me know if there's any problem.

Thanks,
johannes



The following changes since commit ad5987b47e96a0fb6d13fea250e936aed000093c:

  nl80211: validate number of probe response CSA counters (2016-09-13 20:19:27 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2016-09-16

for you to fetch changes up to 85d5313ed717ad60769491c7c072d23bc0a68e7a:

  mac80211: reject TSPEC TIDs (TSIDs) for aggregation (2016-09-15 10:08:52 +0200)

----------------------------------------------------------------
Two more fixes:
 * reject aggregation sessions for TSID/TID 8-16 that we
   can never use anyway and which could confuse drivers
 * check return value of skb_linearize()

----------------------------------------------------------------
Johannes Berg (2):
      mac80211: check skb_linearize() return value
      mac80211: reject TSPEC TIDs (TSIDs) for aggregation

 net/mac80211/agg-rx.c | 8 +++++++-
 net/mac80211/agg-tx.c | 3 +++
 net/mac80211/tx.c     | 8 ++++++--
 3 files changed, 16 insertions(+), 3 deletions(-)
