Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:34521 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3LMLyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 06:54:40 -0500
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	yeohchunyeow@gmail.com
Cc: yeohchunyeow@cozybit.com
Subject: [PATCH v9 0/5] CSA Beacon Count changes
Date: Fri, 13 Dec 2013 13:54:30 +0200
Message-Id: <1386935675-24548-1-git-send-email-luciano.coelho@intel.com> (sfid-20131213_125448_115508_2F2C8E1D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

More changes, hopefully the last ones for this series. ;)

I have hacked wpa_supplicant to support CSA in IBSS, so I could test
it too.  I created some ma80211_hwsim testcases on top of this.  The
tests now pass, though I get some semi-random WARNs [1] when using 3
stations.  It seems to be a race condition and it doesn't seem to be
related to this series, so I think we should address it separately
(Simon, hint! ;).

I have also created some basic BSS CSA test cases for mac80211_hwsim.
The tests pass, except when I try count < 2, which is expected, since
we did not implement the CSA action frame in BSS mode.

I'll upstream the BSS CSA test cases soon.  The IBSS test cases still
need to be cleaned up (actually they're worthless without the IBSS CSA
support in wpa_supplicant, which needs to be cleaned up).  If someone
is interested in this, let me know and I can send them
"without-warranty of any kind". ;)

Please review and test!

In v9:

* fix lock in ieee80211_ibss_finish_csa();
* remove double check for sdata_running() (thanks Simon);
* check cfg80211_chandef_identical before calling
  ieee80211_channel_switch() to avoid disconnecting;

In v8:

* removed bogus sdata_unlock from ieee80211_csa_finalize();

In v7:

* (hopefully) a fix for the kfree_rcu() oops (thanks Chun-Yeow);
* removed stray extra space at the top of cfg.c (thanks Johannes);
* removed the TODO action frame comment for mesh and IBSS (thanks Simon);

--
Cheers,
Luca.

Luciano Coelho (5):
  mac80211: refactor ieee80211_ibss_process_chanswitch()
  mac80211: align ieee80211_ibss_csa_beacon() with
    ieee80211_csa_beacon()
  mac80211: refactor ieee80211_mesh_process_chanswitch()
  mac80211: align ieee80211_mesh_csa_beacon() with
    ieee80211_csa_beacon()
  mac80211: only set CSA beacon when at least one beacon must be
    transmitted

 include/net/mac80211.h     |  10 ++--
 net/mac80211/cfg.c         | 121 ++++++++++++++++++++++++++++++++++-----------
 net/mac80211/ibss.c        |  72 +++++++--------------------
 net/mac80211/ieee80211_i.h |  11 +++--
 net/mac80211/mesh.c        |  86 +++++++++-----------------------
 net/mac80211/tx.c          |  19 +++----
 net/mac80211/util.c        |   1 -
 7 files changed, 153 insertions(+), 167 deletions(-)

-- 
1.8.5.1

