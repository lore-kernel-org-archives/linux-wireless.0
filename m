Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:60189 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752444AbaFMNaW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 09:30:22 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net, michal.kazior@tieto.com
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Fri, 13 Jun 2014 16:30:03 +0300
Message-Id: <1402666207-2257-1-git-send-email-luca@coelho.fi> (sfid-20140613_153031_973468_9BAD1371)
Subject: [PATCH v2 0/4] mac80211: some queue stop/wake patches
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

This replaces the last 3 patches from me that Emmanuel sent out and
includes my RFC option 2 v2 patch.

Luciano Coelho (4):
  mac80211: don't stop all queues when flushing
  mac80211: introduce refcount for queue_stop_reasons
  mac80211: add functions to stop and wake all queues assigned to a vif
  mac80211: stop only the queues assigned to the vif during channel
    switch

 net/mac80211/agg-tx.c      |   8 ++-
 net/mac80211/cfg.c         |  49 +++++-------------
 net/mac80211/ieee80211_i.h |  22 +++++++--
 net/mac80211/iface.c       |   9 ++--
 net/mac80211/main.c        |   3 +-
 net/mac80211/mlme.c        |  35 +++++++------
 net/mac80211/offchannel.c  |   6 ++-
 net/mac80211/pm.c          |   6 ++-
 net/mac80211/tx.c          |   3 +-
 net/mac80211/util.c        | 121 ++++++++++++++++++++++++++++++++-------------
 10 files changed, 160 insertions(+), 102 deletions(-)

-- 
2.0.0.rc2

