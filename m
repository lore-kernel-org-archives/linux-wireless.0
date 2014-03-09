Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27293 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbaCIOko (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 10:40:44 -0400
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com
Subject: [PATCH v6 0/3] mac802111: channel context reservation
Date: Sun,  9 Mar 2014 16:40:36 +0200
Message-Id: <1394376039-9644-1-git-send-email-luciano.coelho@intel.com> (sfid-20140309_154048_183739_5CD115C3)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In v6:

   * return ret in ieee80211_chanctx_is_reserved();
   * check if sdata is running in ieee80211_chanctx_is_reserved();
   * keep check for IEEE80211_CHANCTX_EXCLUSIVE in
     ieee80211_find_channel();
   * use break instead of goto out in ieee80211_chanctx_is_reserved();

In v5:

   * fix checkpatch warnings;

In v4:

   * add chanctx mode parameter to ieee80211_vif_reserve_chanctx();
   * compare the vif's previous BSS width with the reserved new width
     instead of comparing it to the chanctx's combined width;
   * remove IEEE80211_CHANCTX_RESERVED and the reserved_mode element;
   * increase refcount also for "in-place" changes;
   * stop queues also before doing an "in-place" change;
   * refactor ieee80211_use_reserved_chanctx() a bit to fit "in-place"
     better;

In v3:

   * promoted to PATCH ;)
   * applied comments by Michał (see inlined in the patches);
   * removed the "add usage of CS channel reservation for STA" patch,
     since it's independent and is not ready;

This series is based on top of mac80211-next/master, without including
my combination check changes.  When the combination check patchset
gets applied, I can either send the "merge" of the two features as a
separate patchset or I can modify this patchset accordingly (though I
prefer the former, so I can do things in small steps ;).

--
Cheers,
Luca.

Luciano Coelho (3):
  mac80211: split ieee80211_vif_change_channel in two
  mac80211: implement chanctx reservation
  mac80211: allow reservation of a running chanctx

 include/net/mac80211.h     |   7 ++
 net/mac80211/chan.c        | 216 ++++++++++++++++++++++++++++++++++++++++-----
 net/mac80211/ieee80211_i.h |  14 +++
 3 files changed, 217 insertions(+), 20 deletions(-)

-- 
1.9.0

