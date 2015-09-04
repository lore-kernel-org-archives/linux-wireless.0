Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48977 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758517AbbIDOiB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2015 10:38:01 -0400
Message-ID: <1441377476.1971.14.camel@sipsolutions.net> (sfid-20150904_163811_124987_F0D91096)
Subject: pull-request: mac80211 2015-09-04
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Date: Fri, 04 Sep 2015 16:37:56 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

First pull request for this cycle, and the fix for the pointer issue is
the first patch in it :) Since nobody really has devices with enough
streams where this matters, it was pretty harmless though.

Other than that, there are a few fixes all over - let me know if you
see any issues.

johannes

The following changes since commit dd5cdb48edfd34401799056a9acf61078d773f90:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2015-09-03 08:08:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2015-09-04

for you to fetch changes up to ef9be10c8c999e00b239eec24cf01952a308f8e7:

  mac80211: reject software RSSI CQM with beacon filtering (2015-09-04 15:23:22 +0200)

----------------------------------------------------------------
For the first round of fixes, we have this:
 * fix for the sizeof() pointer type issue
 * a fix for regulatory getting into a restore loop
 * a fix for rfkill global 'all' state, it needs to be stored
   everywhere to apply correctly to new rfkill instances
 * properly refuse CQM RSSI when it cannot actually be used
 * protect HT TDLS traffic properly in non-HT networks
 * don't incorrectly advertise 80 MHz support when not allowed

----------------------------------------------------------------
Arik Nemtsov (1):
      mac80211: avoid VHT usage with no 80MHz chans allowed

Avri Altman (1):
      mac80211: protect non-HT BSS when HT TDLS traffic exists

Johannes Berg (1):
      mac80211: reject software RSSI CQM with beacon filtering

João Paulo Rechi Vita (1):
      rfkill: Copy "all" global state to other types

Maciej S. Szmigiero (1):
      cfg80211: regulatory: restore proper user alpha2

Thierry Reding (1):
      mac80211: Do not use sizeof() on pointer type

 include/net/mac80211.h |  4 ++-
 net/mac80211/cfg.c     |  4 +++
 net/mac80211/mlme.c    | 16 ++++++++++++
 net/mac80211/rate.c    |  2 +-
 net/mac80211/tdls.c    | 70 +++++++++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/vht.c     | 15 +++++++++++
 net/rfkill/core.c      | 10 +++++++-
 net/wireless/reg.c     |  2 +-
 8 files changed, 116 insertions(+), 7 deletions(-)
