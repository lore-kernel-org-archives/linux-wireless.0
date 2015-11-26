Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37759 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbbKZPjP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 10:39:15 -0500
Message-ID: <1448552352.2167.14.camel@sipsolutions.net> (sfid-20151126_163919_664516_CC0F7608)
Subject: pull-request: mac80211 2015-11-26
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 26 Nov 2015 16:39:12 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[resending with correct netdev address, not sure how that ended up in
my autocompletion address book ... sorry about that!]

Hi Dave,

Sorry for being so late. These have been pending for a while (and in
fact in linux-next too, I asked to be added there recently :) ).

Let me know if there's any problem.

Thanks,
johannes


The following changes since commit
17c790a60dad11c0193127e83ac8e183b4fed1a2:

  Merge branch 'mv88e6060-fixes' (2015-11-15 20:16:26 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
tags/mac80211-for-davem-2015-11-26

for you to fetch changes up to
5ff3ca2888940533dcd50212cf0be7049fee979c:

  mac80211: don't teardown sdata on sdata stop (2015-11-20 11:40:50
+0100)

----------------------------------------------------------------
A small set of fixes for 4.4:
 * remove NL80211_FEATURE_FULL_AP_CLIENT_STATE again, it
   was broken and needs more work, we'll enable it for 4.5
 * fix call_rcu() induced use-after-reset/free in mesh
   (that was suddenly causing issues in certain tests)
 * always request block-ack window size 64 as we found
   some APs will otherwise crash (really ...)
 * fix P2P-Device teardown sequence to avoid restarting
   with uninitialized data

----------------------------------------------------------------
Eliad Peller (1):
      mac80211: don't teardown sdata on sdata stop

Emmanuel Grumbach (1):
      mac80211: ensure we don't update tx power on a non-running sdata

Gregory Greenman (1):
      mac80211: always set the buf_size in AddBA req to 64

Johannes Berg (2):
      mac80211: don't advertise NL80211_FEATURE_FULL_AP_CLIENT_STATE
      mac80211: mesh: fix call_rcu() usage

 include/net/mac80211.h      | 6 ++++--
 net/mac80211/agg-tx.c       | 3 ++-
 net/mac80211/iface.c        | 5 +++--
 net/mac80211/main.c         | 3 +--
 net/mac80211/mesh_pathtbl.c | 8 ++++----
 5 files changed, 14 insertions(+), 11 deletions(-)
