Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:58764 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaAMRnG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 12:43:06 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	yeohchunyeow@gmail.com
Cc: yeohchunyeow@cozybit.com
Subject: [PATCH v11 0/3] CSA beacon count changes
Date: Mon, 13 Jan 2014 19:42:57 +0200
Message-Id: <1389634980-12584-1-git-send-email-luca@coelho.fi> (sfid-20140113_184311_104052_C65AF447)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Now rebased on top of the latest mac80211-next tree.

In v11:

* skip 2 patches that were already applied;
* rebased and resolved the mesh conflicts;
* s/ibss_debug/mcsa_debug/ in mesh.c (thanks Chun-Yeow);

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
Luca.

Luciano Coelho (3):
  mac80211: refactor ieee80211_mesh_process_chanswitch()
  mac80211: align ieee80211_mesh_csa_beacon() with
    ieee80211_assign_beacon()
  mac80211: only set CSA beacon when at least one beacon must be
    transmitted

 include/net/mac80211.h     |  10 ++--
 net/mac80211/cfg.c         | 118 +++++++++++++++++++++++++++++++++------------
 net/mac80211/ibss.c        |   6 ---
 net/mac80211/ieee80211_i.h |   9 ++--
 net/mac80211/mesh.c        |  87 +++++++++------------------------
 net/mac80211/tx.c          |  19 +++-----
 6 files changed, 130 insertions(+), 119 deletions(-)

-- 
1.8.5.2

