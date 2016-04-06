Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37455 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338AbcDFNUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 09:20:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2016-04-06
Date: Wed,  6 Apr 2016 15:19:58 +0200
Message-Id: <1459948799-22032-1-git-send-email-johannes@sipsolutions.net> (sfid-20160406_152028_433537_EAD57A9D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

First set of fixes for 4.6. Nothing really stands out.

Let me know if there's any problem.

Thanks,
johannes



The following changes since commit 05cf8077e54b20dddb756eaa26f3aeb5c38dd3cf:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2016-04-01 20:03:33 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2016-04-06

for you to fetch changes up to b4201cc4fc6e1c57d6d306b1f787865043d60129:

  mac80211: fix "warning: ‘target_metric’ may be used uninitialized" (2016-04-06 15:10:25 +0200)

----------------------------------------------------------------
For the current RC series, we have the following fixes:
 * TDLS fixes from Arik and Ilan
 * rhashtable fixes from Ben and myself
 * documentation fixes from Luis
 * U-APSD fixes from Emmanuel
 * a TXQ fix from Felix
 * and a compiler warning suppression from Jeff

----------------------------------------------------------------
Arik Nemtsov (3):
      mac80211: TDLS: always downgrade invalid chandefs
      mac80211: TDLS: change BW calculation for WIDER_BW peers
      mac80211: recalc min_def chanctx even when chandef is identical

Ben Greear (1):
      mac80211: ensure no limits on station rhashtable

Emmanuel Grumbach (2):
      mac80211: don't send deferred frames outside the SP
      mac80211: close the SP when we enqueue frames during the SP

Felix Fietkau (1):
      mac80211: fix AP buffered multicast frames with queue control and txq

Ilan Peer (1):
      mac80211: Fix BW upgrade for TDLS peers

Jeff Mahoney (1):
      mac80211: fix "warning: ‘target_metric’ may be used uninitialized"

Johannes Berg (1):
      mac80211: properly deal with station hashtable insert errors

Luis de Bethencourt (2):
      mac80211: add doc for RX_FLAG_DUP_VALIDATED flag
      mac80211: remove description of dropped member

 include/net/mac80211.h     |  2 ++
 net/mac80211/chan.c        |  4 +++-
 net/mac80211/ieee80211_i.h |  4 ++++
 net/mac80211/mesh_hwmp.c   |  2 +-
 net/mac80211/sta_info.c    | 14 +++++++++-----
 net/mac80211/sta_info.h    |  1 -
 net/mac80211/tdls.c        | 43 +++++++++++++++++++++++++++++++++++--------
 net/mac80211/tx.c          | 13 +++++++++----
 net/mac80211/vht.c         | 30 +++++++++++++++++++++++++-----
 9 files changed, 88 insertions(+), 25 deletions(-)
