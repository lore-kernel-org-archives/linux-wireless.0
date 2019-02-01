Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DAB7C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 11:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35AB221904
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 11:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbfBALRB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 06:17:01 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:38864 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbfBALRA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 06:17:00 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gpWob-0000Um-QF; Fri, 01 Feb 2019 12:16:58 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2019-02-01
Date:   Fri,  1 Feb 2019 12:16:50 +0100
Message-Id: <20190201111651.10203-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

Here's my next pull request for net-next. I wanted to include more,
notably the multi-BSSID work that's going on now (multi-BSSID lets
a single AP with a single beacon have multiple networks, rather than
requiring a beacon for each), but we're still finding small issues
and bugs in it, so I haven't included it. As always, I'll send it
when it's ready :-)

As noted below, this contains the NLA_POLICY_NESTED{,_ARRAY} changes
I showed you earlier, no new users have been added to net-next as
of today when I merged your tree to mine (to get the net changes to
not have conflicts over this in wireless code.)

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit fa6821cbf1d9724284ef0906c9a01a5fbf13a35c:

  r8169: improve WoL handling (2019-01-31 12:50:42 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2019-02-01

for you to fetch changes up to 7d4194633b29342d93501b53accebf638da134ad:

  mac80211: fix missing/malformed documentation (2019-02-01 12:11:13 +0100)

----------------------------------------------------------------
New features for the wifi stack:
 * airtime fairness scheduling in mac80211, so we can share
 * more authentication offloads to userspace - this is for
   SAE which is part of WPA3 and is hard to do in firmware
 * documentation fixes
 * various mesh improvements
 * various other small improvements/cleanups

This also contains the NLA_POLICY_NESTED{,_ARRAY} change we
discussed, which affects everyone but there's no other user
yet.

----------------------------------------------------------------
Felix Fietkau (1):
      mac80211: minstrel_ht: add flag to indicate missing/inaccurate tx A-MPDU length

Gustavo A. R. Silva (1):
      cfg80211: mark expected switch fall-throughs

Johannes Berg (5):
      mac80211: remove unused variable
      Merge remote-tracking branch 'net-next/master' into mac80211-next
      netlink: reduce NLA_POLICY_NESTED{,_ARRAY} arguments
      cfg80211: add missing documentation that kernel-doc warns about
      mac80211: fix missing/malformed documentation

Julan Hsu (4):
      nl80211/mac80211: mesh: add hop count to mpath info
      nl80211/mac80211: mesh: add mesh path change count to mpath info
      mac80211: mesh: use average bitrate for link metric calculation
      mac80211: mesh: only switch path when new metric is at least 10% better

Liangwei Dong (1):
      nl80211: Allow set/del pmksa operations for AP

Matteo Croce (1):
      cfg80211: fix typo

Sergey Matyukevich (1):
      mac80211: allow overriding HT STBC capabilities

Srinivas Dasari (1):
      cfg80211: Authentication offload to user space in AP mode

Sriram R (1):
      cfg80211: Notify all User Hints To self managed wiphys

Toke Høiland-Jørgensen (5):
      mac80211: Add TXQ scheduling API
      cfg80211: Add airtime statistics and settings
      mac80211: Add airtime accounting and scheduling to TXQs
      mac80211: Expose ieee80211_schedule_txq() function
      mac80211: Fix documentation strings for airtime-related variables

Veerendranath Jakkam (1):
      cfg80211: Allow drivers to advertise supported AKM suites

YueHaibing (2):
      virt_wifi: remove duplicated include from virt_wifi.c
      virt_wifi: remove set but not used variable 'w_priv'

 Documentation/driver-api/80211/mac80211.rst |   3 +
 drivers/net/wireless/virt_wifi.c            |   7 --
 include/net/cfg80211.h                      |  55 ++++++++-
 include/net/mac80211.h                      | 183 ++++++++++++++++++++++++++--
 include/net/netlink.h                       |   8 +-
 include/uapi/linux/nl80211.h                |  44 ++++++-
 net/mac80211/agg-tx.c                       |   2 +-
 net/mac80211/cfg.c                          |  14 ++-
 net/mac80211/debugfs.c                      |   4 +
 net/mac80211/debugfs_sta.c                  |  68 ++++++++++-
 net/mac80211/driver-ops.h                   |   7 ++
 net/mac80211/ht.c                           |   8 ++
 net/mac80211/ieee80211_i.h                  |  11 ++
 net/mac80211/main.c                         |  11 ++
 net/mac80211/mesh.h                         |   2 +
 net/mac80211/mesh_hwmp.c                    |  29 ++++-
 net/mac80211/rc80211_minstrel_ht.c          |  25 +++-
 net/mac80211/rc80211_minstrel_ht_debugfs.c  |   7 +-
 net/mac80211/sta_info.c                     |  46 ++++++-
 net/mac80211/sta_info.h                     |  38 ++++++
 net/mac80211/status.c                       |   6 +
 net/mac80211/tx.c                           | 154 ++++++++++++++++++++++-
 net/wireless/nl80211.c                      |  86 ++++++++++---
 net/wireless/reg.c                          |   4 +-
 net/wireless/wext-compat.c                  |   2 +
 25 files changed, 749 insertions(+), 75 deletions(-)

