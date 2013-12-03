Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:52945 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab3LCNs2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 08:48:28 -0500
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	yeohchunyeow@gmail.com
Cc: yeohchunyeow@cozybit.com
Subject: [PATCH v6 0/5] CSA beacon count changes
Date: Tue,  3 Dec 2013 15:48:17 +0200
Message-Id: <1386078502-19845-1-git-send-email-luciano.coelho@intel.com> (sfid-20131203_144834_719578_5B295563)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is a new version of my patchset.  Now it's rebased on the latest
mac80211-next, so all the locking changes are included.  I hope the
warnings observed with mesh and IBSS go away now that the locks are
working properly.

Simon and Chun-Yeow, it would be great if you could re-test this
updated version and let me know how it goes.

Thanks!

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
 net/mac80211/cfg.c         | 120 +++++++++++++++++++++++++++++++++++----------
 net/mac80211/ibss.c        |  78 +++++++----------------------
 net/mac80211/ieee80211_i.h |  11 +++--
 net/mac80211/mesh.c        |  78 ++++++-----------------------
 net/mac80211/tx.c          |  19 +++----
 net/mac80211/util.c        |   1 -
 7 files changed, 148 insertions(+), 169 deletions(-)

-- 
1.8.4.2

