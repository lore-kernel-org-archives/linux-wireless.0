Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40854 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750786AbcH2UZZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 16:25:25 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Mon, 29 Aug 2016 23:25:13 +0300
Message-Id: <1472502319-10847-1-git-send-email-luca@coelho.fi> (sfid-20160829_222529_811919_6EC539F1)
Subject: [PATCH v2 0/6] some mac80211/cfg80211 patches
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi Johannes,

Here are a few of the mac80211 and cfg80211 patches that we have in
our internal tree.

Thanks for pointing out the missing patch.  And please ignore the 5
patches I sent earlier today.

In v2:
   * add a cover letter ;)
   * add a patch that was missing for the MU-MIMO monitor implementation

Cheers,
Luca.

Aviya Erenfeld (2):
  mac80211: refactor monitor representation in sdata
  mac80211: add support for MU-MIMO air sniffer

Emmanuel Grumbach (1):
  cfg80211: clarify the requirements of .disconnect()

Johannes Berg (3):
  mac80211: add support for radiotap timestamp field
  mac80211: send delBA on unexpected BlockAck data frames
  mac80211: send delBA on unexpected BlockAck Request

 include/net/cfg80211.h           |  3 +-
 include/net/ieee80211_radiotap.h | 21 ++++++++++++
 include/net/mac80211.h           | 12 +++++++
 net/mac80211/agg-rx.c            |  4 ++-
 net/mac80211/cfg.c               | 31 +++++++++++++++---
 net/mac80211/driver-ops.c        |  2 +-
 net/mac80211/driver-ops.h        |  3 +-
 net/mac80211/ieee80211_i.h       |  9 ++++--
 net/mac80211/iface.c             | 21 +++++++-----
 net/mac80211/main.c              |  3 ++
 net/mac80211/rx.c                | 70 ++++++++++++++++++++++++++++++++++++++--
 net/mac80211/sta_info.h          |  3 ++
 net/mac80211/status.c            |  2 +-
 net/mac80211/tx.c                |  2 +-
 net/mac80211/util.c              |  2 +-
 15 files changed, 163 insertions(+), 25 deletions(-)

-- 
2.8.1
