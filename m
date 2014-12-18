Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41647 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbaLROK1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 09:10:27 -0500
Message-ID: <1418911822.6134.13.camel@sipsolutions.net> (sfid-20141218_151030_949509_599488C3)
Subject: pull-request: mac80211 2014-12-18
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 18 Dec 2014 15:10:22 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Also from me a first pull request - we have a number of really old
issues that happened to crop up now with new work (or just more testing)
in the right areas as well as some small bugs newly introduced in 3.19.

Let me know if there are any problems.

Thanks,
johannes


The following changes since commit 5fbea33740aeb948422d7b7e8aafbeac362264b2:

  r8169:update rtl8168g pcie ephy parameter (2014-12-11 21:38:52 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2014-12-18

for you to fetch changes up to 28a9bc68124c319b2b3dc861e80828a8865fd1ba:

  mac80211: free management frame keys when removing station (2014-12-17 14:00:17 +0100)

----------------------------------------------------------------
This relatively large collection of fixes is all over - from things
that were broken a long time ago (the management key issue) but not
noticed yet, to small issues that were only introduced into 3.19
(like the multicast issue). At least one issue is old but can crash
the kernel based on invalid userspace requests (the nl80211 matches
array one.)

----------------------------------------------------------------
Andreas Müller (1):
      mac80211: fix multicast LED blinking and counter

Arik Nemtsov (2):
      cfg80211: avoid mem leak on driver hint set
      cfg80211: correctly check ad-hoc channels

Emmanuel Grumbach (2):
      mac80211: update the channel context after channel switch
      cfg80211: don't WARN about two consecutive Country IE hint

Jes Sorensen (1):
      mac80211: avoid using uninitialized stack data

Johannes Berg (1):
      mac80211: free management frame keys when removing station

Jouni Malinen (1):
      cfg80211: Fix 160 MHz channels with 80+80 and 160 MHz drivers

Luciano Coelho (1):
      nl80211: check matches array length before acessing it

 net/mac80211/chan.c    |  4 ++++
 net/mac80211/key.c     |  2 +-
 net/mac80211/mlme.c    |  1 +
 net/mac80211/rx.c      | 11 ++++++-----
 net/wireless/chan.c    |  9 ++++++---
 net/wireless/nl80211.c |  2 +-
 net/wireless/reg.c     | 20 +++++++++++++-------
 7 files changed, 32 insertions(+), 17 deletions(-)


