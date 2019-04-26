Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F0BC4321A
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 11:11:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F090206DD
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 11:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfDZLLu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 07:11:50 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56652 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfDZLLu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 07:11:50 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hJylc-0002Yu-RH; Fri, 26 Apr 2019 13:11:45 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2019-04-26
Date:   Fri, 26 Apr 2019 13:11:38 +0200
Message-Id: <20190426111139.5831-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

And another set for -next, not that big this time.
See below for a summary of the highlights.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 1f17f7742eeba73dbd5ae8bdec1a85ce5877001e:

  net: sched: flower: insert filter to ht before offloading it to hw (2019-04-07 19:33:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2019-04-26

for you to fetch changes up to 8828f81ad4a2f4e89ebe6e7793c06ed767c31d53:

  mac80211: probe unexercised mesh links (2019-04-26 13:02:11 +0200)

----------------------------------------------------------------
Various updates, notably:
 * extended key ID support (from 802.11-2016)
 * per-STA TX power control support
 * mac80211 TX performance improvements
 * HE (802.11ax) updates
 * mesh link probing support
 * enhancements of multi-BSSID support (also related to HE)
 * OWE userspace processing support

----------------------------------------------------------------
Alexander Wetzel (6):
      mac80211: Optimize tailroom_needed update checks
      nl80211/cfg80211: Extended Key ID support
      mac80211: IEEE 802.11 Extended Key ID support
      mac80211: Fix Extended Key ID auto activation
      mac80211_hwsim: Extended Key ID support
      mac80211: Set CAN_REPLACE_PTK0 for SW crypto only drivers

Ashok Raj Nagarajan (2):
      cfg80211: Add support to set tx power for a station associated
      mac80211: store tx power value from user to station

Avraham Stern (1):
      mac80211_hwsim: set p2p device interface support indication

Colin Ian King (1):
      cfg80211: remove redundant zero check on variable 'changed'

Dan Carpenter (1):
      cfg80211: don't pass pointer to pointer unnecessarily

Felix Fietkau (7):
      mac80211: mesh: drop redundant rcu_read_lock/unlock calls
      mac80211: calculate hash for fq without holding fq->lock in itxq enqueue
      mac80211: run late dequeue late tx handlers without holding fq->lock
      mac80211: set NETIF_F_LLTX when using intermediate tx queues
      mac80211: when using iTXQ, select the queue in ieee80211_subif_start_xmit
      mac80211: minstrel_ht: add support for rates with 4 spatial streams
      mac80211: minstrel_ht: automatically calculate rate duration shift

Gustavo A. R. Silva (2):
      cfg80211: Use struct_size() in kzalloc()
      nl80211: Use struct_size() in kzalloc()

Johannes Berg (2):
      nl80211: reindent some sched scan code
      mac80211: only allocate one queue when using iTXQs

Julius Niedworok (1):
      mac80211: debugfs option to force TX status frames

Liad Kaufman (1):
      ieee80211: update HE IEs to D4.0 spec

Luca Coelho (1):
      nl80211: do a struct assignment to radar_chandef instead of memcpy()

Narayanraddi Masti (1):
      mac80211: Add support for NL80211_STA_INFO_AIRTIME_LINK_METRIC

Rajkumar Manoharan (3):
      cfg80211: add support to probe unexercised mesh link
      mac80211: add option for setting control flags
      mac80211: probe unexercised mesh links

Sara Sharon (5):
      cfg80211: don't skip multi-bssid index element
      cfg80211: support non-inheritance element
      mac80211: support non-inheritance element
      cfg80211: support profile split between elements
      mac80211: support profile split between elements

Sergey Matyukevich (1):
      mac80211/cfg80211: update bss channel on channel switch

Shaul Triebitz (1):
      nl80211: increase NL80211_MAX_SUPP_REG_RULES

Sunil Dutt (1):
      cfg80211/nl80211: Offload OWE processing to user space in AP mode

vamsi krishna (1):
      nl80211/cfg80211: Specify band specific min RSSI thresholds with sched scan

 drivers/net/wireless/mac80211_hwsim.c |   8 +
 include/linux/ieee80211.h             |  14 +-
 include/net/cfg80211.h                | 104 +++++++++++
 include/net/fq_impl.h                 |  18 +-
 include/net/mac80211.h                |  30 +++
 include/uapi/linux/nl80211.h          |  86 ++++++++-
 net/mac80211/cfg.c                    |  46 +++++
 net/mac80211/debugfs.c                |  54 ++++++
 net/mac80211/driver-ops.c             |  21 +++
 net/mac80211/driver-ops.h             |   5 +
 net/mac80211/ieee80211_i.h            |   9 +-
 net/mac80211/iface.c                  |  11 +-
 net/mac80211/key.c                    |  87 ++++++---
 net/mac80211/key.h                    |   2 +
 net/mac80211/main.c                   |  16 ++
 net/mac80211/mesh.h                   |   2 +
 net/mac80211/mesh_hwmp.c              |  34 ++--
 net/mac80211/mesh_pathtbl.c           |   2 +-
 net/mac80211/mlme.c                   |   3 -
 net/mac80211/rc80211_minstrel_ht.c    | 124 ++++++++-----
 net/mac80211/rc80211_minstrel_ht.h    |   2 +-
 net/mac80211/rx.c                     |  74 ++++----
 net/mac80211/sta_info.c               |  15 ++
 net/mac80211/tdls.c                   |   2 +-
 net/mac80211/trace.h                  |  30 +++
 net/mac80211/tx.c                     | 113 +++++++++---
 net/mac80211/util.c                   | 162 ++++++++++-------
 net/mac80211/wme.c                    |  82 +++++----
 net/mac80211/wme.h                    |   2 +
 net/wireless/nl80211.c                | 331 +++++++++++++++++++++++++++++-----
 net/wireless/rdev-ops.h               |  29 ++-
 net/wireless/reg.c                    |  23 +--
 net/wireless/scan.c                   | 173 +++++++++++++++++-
 net/wireless/trace.h                  |  87 ++++++++-
 net/wireless/util.c                   |  21 ++-
 net/wireless/wext-compat.c            |   3 -
 36 files changed, 1465 insertions(+), 360 deletions(-)

