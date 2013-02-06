Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52004 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab3BFPBW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 10:01:22 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 0/4] Improve queue handling for off-channel operation
Date: Wed,  6 Feb 2013 09:01:09 -0600
Message-Id: <1360162873-17240-1-git-send-email-seth.forshee@canonical.com> (sfid-20130206_160125_899008_34827E09)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Here are some updates to the tx queue handling patches during
off-channel operation that were part of the larger series I sent last
week. I didn't see any reason to sit on these while I finished
implementing the powersave changes. This includes the patches to return
a status from tx operations, add an off-channel queue stop reason, and
improve error handling when going off-channel.

Changes since v1:
 * Add unlikely() to the off-channel condition in ieee80211_tx_frags()
 * Expand the queue stop reasons that will cause off-channel frames to
   be dropped to include everything except the off-channel stop reason
 * Remove changes to abort scans when sending of probe request frames
   failed

Thanks,
Seth


Seth Forshee (4):
  mac80211: Return a status for tx operations
  mac80211: Fix tx queue handling during scans
  mac80211: Improve error handling for off-channel operation
  mac80211: Add flushes before going off-channel

 net/mac80211/agg-tx.c      |    4 +-
 net/mac80211/cfg.c         |    2 +-
 net/mac80211/ht.c          |    2 +-
 net/mac80211/ieee80211_i.h |   70 ++++++++++++++++++------
 net/mac80211/mlme.c        |    6 +-
 net/mac80211/offchannel.c  |   55 +++++++++++--------
 net/mac80211/scan.c        |   16 +++++-
 net/mac80211/sta_info.c    |    2 +-
 net/mac80211/tx.c          |  130 +++++++++++++++++++++++++-------------------
 net/mac80211/util.c        |    3 +-
 10 files changed, 182 insertions(+), 108 deletions(-)

