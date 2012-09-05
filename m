Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43977 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab2IERXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 13:23:51 -0400
Received: by wicr5 with SMTP id r5so5700208wic.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Sep 2012 10:23:50 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/2] make roaming a bit faster 
Date: Wed,  5 Sep 2012 20:23:55 +0300
Message-Id: <1346865837-32265-1-git-send-email-eliad@wizery.com> (sfid-20120905_192355_427159_296B8511)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The use of synchronize_rcu during roaming adds
a significant delay. try minimizing it by replacing
these calls with other alternatives.

Eliad Peller (2):
  mac80211: use synchronize_net() on key destroying
  mac80211: use call_rcu() on sta deletion

 net/mac80211/iface.c    |    5 ++
 net/mac80211/key.c      |    2 +-
 net/mac80211/sta_info.c |  117 ++++++++++++++++++++++++++---------------------
 net/mac80211/sta_info.h |    2 +
 4 files changed, 73 insertions(+), 53 deletions(-)

-- 
1.7.6.401.g6a319

