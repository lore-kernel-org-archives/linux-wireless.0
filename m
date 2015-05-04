Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45320 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbbEDLCP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 07:02:15 -0400
Message-ID: <1430737329.2013.21.camel@sipsolutions.net> (sfid-20150504_130222_132441_5352C9FD)
Subject: pull-request: mac80211 2015-05-04
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 04 May 2015 13:02:09 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

As I was sick last week this dragged out for a bit, but given we have
-rc2 out I figured I'd send you something sooner rather than later.

Let me know if there are any issues.

johannes


The following changes since commit 388f997620cb57372c494a194e9698b28cc179b8:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2015-04-17 16:31:08 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2015-05-04

for you to fetch changes up to ff419b3f95ab7a97c5f72876b53f12a249dacc2a:

  mac80211: fix 90 kernel-doc warnings (2015-05-04 12:56:13 +0200)

----------------------------------------------------------------
We have only a few fixes right now:
 * a fix for an issue with hash collision handling in the
   rhashtable conversion
 * a merge issue - rhashtable removed default shrinking
   just before mac80211 was converted, so enable it now
 * remove an invalid WARN that can trigger with legitimate
   userspace behaviour
 * add a struct member missing from kernel-doc that caused
   a lot of warnings

----------------------------------------------------------------
Johannes Berg (3):
      mac80211: don't warn when stopping VLAN with stations
      mac80211: fix rhashtable conversion
      mac80211: enable hash table shrinking

Randy Dunlap (1):
      mac80211: fix 90 kernel-doc warnings

 include/net/mac80211.h  |  2 ++
 net/mac80211/iface.c    | 12 +++++++-----
 net/mac80211/sta_info.c | 19 ++++++++++++++++++-
 3 files changed, 27 insertions(+), 6 deletions(-)


