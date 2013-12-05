Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:43649 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419Ab3LEPZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 10:25:47 -0500
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	yeohchunyeow@gmail.com
Cc: yeohchunyeow@cozybit.com, andrei.otcheretianski@intel.com
Subject: [PATCH v8 0/5] CSA beacon count changes
Date: Thu,  5 Dec 2013 17:25:38 +0200
Message-Id: <1386257143-29840-1-git-send-email-luciano.coelho@intel.com> (sfid-20131205_162550_618904_718CBB99)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In v8:

* removed bogus sdata_unlock from ieee80211_csa_finalize();

In v7:

* (hopefully) a fix for the kfree_rcu() oops (thanks Chun-Yeow);
* removed stray extra space at the top of cfg.c (thanks Johannes);
* removed the TODO action frame comment for mesh and IBSS (thanks Simon);

Chun-Yeow, it would be great if you could retest this, at least once
with count > 1 and once with count <= 1.

Simon, would you have the time to test the IBSS case as well? I'd
really appreciate that! :)

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
 net/mac80211/cfg.c         | 119 +++++++++++++++++++++++++++++++++++----------
 net/mac80211/ibss.c        |  78 +++++++----------------------
 net/mac80211/ieee80211_i.h |  11 +++--
 net/mac80211/mesh.c        |  81 +++++++-----------------------
 net/mac80211/tx.c          |  19 +++-----
 net/mac80211/util.c        |   1 -
 7 files changed, 150 insertions(+), 169 deletions(-)

-- 
1.8.4.3

