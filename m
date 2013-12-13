Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:45649 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3LMTN7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 14:13:59 -0500
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	yeohchunyeow@gmail.com
Cc: yeohchunyeow@cozybit.com
Subject: [PATCH v10 0/5] CSA beacon count changes
Date: Fri, 13 Dec 2013 21:13:49 +0200
Message-Id: <1386962034-7141-1-git-send-email-luciano.coelho@intel.com> (sfid-20131213_201402_248218_84DAF0A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A couple more changes, this time only in the commit logs.

In v10:

* s/ieee80211_csa_beacon/ieee80211_assign_beacon/ in the commit
  messages (thanks Simon);
* remove stray Change-Id tags.

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
    ieee80211_assign_beacon()
  mac80211: refactor ieee80211_mesh_process_chanswitch()
  mac80211: align ieee80211_mesh_csa_beacon() with
    ieee80211_assign_beacon()
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

