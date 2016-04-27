Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50074 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbcD0I5o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2016 04:57:44 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2016-04-27
Date: Wed, 27 Apr 2016 10:57:26 +0200
Message-Id: <1461747447-11287-1-git-send-email-johannes@sipsolutions.net> (sfid-20160427_105802_205193_890FD9D2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

While writing some new code yesterday, I found and fixed a per-CPU memory
leak, this pull request has just a single patch addressing that.

Let me know if there's any problem.

Thanks,
johannes



The following changes since commit 8f815cdde3e550e10c2736990d791f60c2ce43eb:

  nl80211: check netlink protocol in socket release notification (2016-04-12 15:39:06 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2016-04-27

for you to fetch changes up to e6436be21e77e3659b4ff7e357ab5a8342d132d2:

  mac80211: fix statistics leak if dev_alloc_name() fails (2016-04-27 10:06:58 +0200)

----------------------------------------------------------------
Just a single fix, for a per-CPU memory leak in a
(root user triggerable) error case.

----------------------------------------------------------------
Johannes Berg (1):
      mac80211: fix statistics leak if dev_alloc_name() fails

 net/mac80211/iface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
