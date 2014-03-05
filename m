Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:35992 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbaCELLt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 06:11:49 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com
Subject: [PATCH v5 0/3] mac802111: channel context reservation
Date: Wed,  5 Mar 2014 13:11:41 +0200
Message-Id: <1394017904-4012-1-git-send-email-luca@coelho.fi> (sfid-20140305_121155_403069_B750FE93)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Hi,

Some checkpatch warnings slipped through my fingers. :(

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
 net/mac80211/chan.c        | 214 ++++++++++++++++++++++++++++++++++++++++-----
 net/mac80211/ieee80211_i.h |  14 +++
 3 files changed, 215 insertions(+), 20 deletions(-)

-- 
1.8.5.3

