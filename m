Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34386 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750836AbdLKJwl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 04:52:41 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2017-12-11
Date: Mon, 11 Dec 2017 10:52:35 +0100
Message-Id: <20171211095236.10172-1-johannes@sipsolutions.net> (sfid-20171211_105255_968920_1D3256CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Three fixes, two related to build issues with the new regdb stuff,
and one for some patch overlap problem that caused locking to be
missing which in turn caused lots of warnings.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit ccab371f746abca05a599d074cb3b95a549ef590:

  Merge branch 'sfp-phylink-fixes' (2017-12-01 15:18:42 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2017-12-11

for you to fetch changes up to 0afe9d4ab9d40c281bdcdd118661fe8e4bdcef18:

  mac80211: fix locking in ieee80211_sta_tear_down_BA_sessions (2017-12-11 10:50:00 +0100)

----------------------------------------------------------------
Three fixes:
 * for certificate C file generation, don't use hexdump as it's
   not always installed by default, use pure posix instead (od/sed)
 * for certificate C file generation, don't write the file if
   anything fails, so the build abort will not cause a bad build
   upon a second attempt
 * fix locking in ieee80211_sta_tear_down_BA_sessions() which had
   been causing lots of locking warnings

----------------------------------------------------------------
Johannes Berg (3):
      wireless: replace usage of hexdump with od/sed
      wireless: don't write C files on failures
      mac80211: fix locking in ieee80211_sta_tear_down_BA_sessions

 net/mac80211/ht.c     |  5 ++---
 net/wireless/Makefile | 48 ++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 40 insertions(+), 13 deletions(-)
