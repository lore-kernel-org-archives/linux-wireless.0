Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51596 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbbJMI7u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 04:59:50 -0400
Message-ID: <1444726787.1961.7.camel@sipsolutions.net> (sfid-20151013_110001_345454_7C8F8626)
Subject: pull-request: mac80211 2015-10-13
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 13 Oct 2015 10:59:47 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

There are just two small fixes, but I didn't really want to wait since
I have nothing else pending.

Let me know if there's any problem.

johannes

The following changes since commit babc305e21ea3811d98b67437299360904ac1b6a:

  mac80211: reset CQM history upon reconfiguration (2015-09-22 15:22:50 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2015-10-13

for you to fetch changes up to 4633dfc32c0019bed2996de9bbdbe7f3b518a44e:

  mac80211: Fix hwflags debugfs file format (2015-10-13 10:30:56 +0200)

----------------------------------------------------------------
Like last time, we have two small fixes:
 * fast-xmit was not doing powersave filter clearing correctly,
   disable fast-xmit while any such operations are still pending
 * a debugfs file was broken due to some infrastructure changes

----------------------------------------------------------------
Felix Fietkau (1):
      mac80211: fix handling of PS filtering with fast-xmit

Mohammed Shafi Shajakhan (1):
      mac80211: Fix hwflags debugfs file format

 net/mac80211/debugfs.c | 2 +-
 net/mac80211/status.c  | 1 +
 net/mac80211/tx.c      | 7 +++++--
 3 files changed, 7 insertions(+), 3 deletions(-)
