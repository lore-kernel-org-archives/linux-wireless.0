Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [143.182.124.21] ([143.182.124.21]:21409 "EHLO mga03.intel.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753572AbaCLOhg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2014 10:37:36 -0400
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com
Subject: [PATCH v8 0/4] 
Date: Wed, 12 Mar 2014 16:37:17 +0200
Message-Id: <1394635041-2561-1-git-send-email-luciano.coelho@intel.com> (sfid-20140312_153741_125130_5C9A8479)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a bunch of rebase screw-ups and split the copy ap vlan function,
according to Michal's comments.

Also, I forgot to say in the previous version, this series depends on
Michal's "mac80211: protect AP VLAN list with local->mtx" patch.

--
Luca.

Luciano Coelho (4):
  mac80211: split ieee80211_vif_change_channel in two
  mac80211: refactor ieee80211_assign/unassign_vif_chanctx into one
  mac80211: implement chanctx reservation
  mac80211: allow reservation of a running chanctx

 include/net/mac80211.h     |   7 +
 net/mac80211/chan.c        | 366 +++++++++++++++++++++++++++++++++------------
 net/mac80211/ieee80211_i.h |  13 ++
 3 files changed, 293 insertions(+), 93 deletions(-)

-- 
1.9.0

