Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25614 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbaCLNGM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2014 09:06:12 -0400
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com
Subject: [PATCH v7 0/4] mac802111: channel context reservation
Date: Wed, 12 Mar 2014 15:06:05 +0200
Message-Id: <1394629569-13798-1-git-send-email-luciano.coelho@intel.com> (sfid-20140312_140618_529465_F179D615)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

New version with some comments from an offline review with Johannes
plus a few comments by Michal and Eliad.  I removed the history from
here, since it's all in the patches anyway.

There's a new patch here to combine the assign and unassign functions
to avoid having problems with a NULL conf while the vif is still
running.

--
Luca.

Luciano Coelho (4):
  mac80211: split ieee80211_vif_change_channel in two
  mac80211: refactor ieee80211_assign/unassign_vif_chanctx into one
  mac80211: implement chanctx reservation
  mac80211: allow reservation of a running chanctx

 include/net/mac80211.h     |   7 ++
 net/mac80211/chan.c        | 298 +++++++++++++++++++++++++++++++++++----------
 net/mac80211/ieee80211_i.h |  13 ++
 3 files changed, 256 insertions(+), 62 deletions(-)

-- 
1.9.0

