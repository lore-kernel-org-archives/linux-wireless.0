Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD89EC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 11:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0E6D2077C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 11:14:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0E6D2077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbeJLSqK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 14:46:10 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47830 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbeJLSqJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 14:46:09 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gAvOU-0001mP-Mu; Fri, 12 Oct 2018 13:14:10 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2018-10-12
Date:   Fri, 12 Oct 2018 13:13:53 +0200
Message-Id: <20181012111354.30062-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

Here's another set of updates. Note that there's a patch here
(lib80211 skcipher removal to simplify the code) that will
cause conflicts when merging with the crypto tree, the new
code from this should be used. Please advise Greg/Linus unless
the crypto tree will somehow end up in your tree first?

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit abf1a08ff3237a27188ff8cc2904f2cea893af55:

  net: vhost: remove bad code line (2018-10-07 21:31:32 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2018-10-12

for you to fetch changes up to f8252e7b5a83deee0e477fc1e31e3f06ceb35d28:

  mac80211: implement ieee80211_tx_rate_update to update rate (2018-10-12 13:05:40 +0200)

----------------------------------------------------------------
Highlights:
 * merge net-next, so I can finish the hwsim workqueue removal
 * fix TXQ NULL pointer issue that was reported multiple times
 * minstrel cleanups from Felix
 * simplify lib80211 code by not using skcipher, note that this
   will conflict with the crypto tree (and this new code here
   should be used)
 * use new netlink policy validation in nl80211
 * fix up SAE (part of WPA3) in client-mode
 * FTM responder support in the stack

----------------------------------------------------------------
Andrew Zaborowski (1):
      nl80211: Fix a GET_KEY reply attribute

Anilkumar Kolli (1):
      mac80211: implement ieee80211_tx_rate_update to update rate

Ankita Bajaj (1):
      nl80211: Add per peer statistics to compute FCS error rate

Chaitanya T K (1):
      mac80211: minstrel: Enable STBC and LDPC for VHT Rates

Colin Ian King (1):
      cfg80211: remove redundant check of !scan_plan

Erik Stromdahl (1):
      mac80211: fix issue with possible txq NULL pointer

Felix Fietkau (8):
      mac80211: minstrel: remove unnecessary debugfs cleanup code
      mac80211: minstrel: merge with minstrel_ht, always enable VHT support
      mac80211: minstrel: reduce minstrel_mcs_groups size
      mac80211: minstrel: fix using short preamble CCK rates on HT clients
      mac80211: minstrel: fix CCK rate group streams value
      mac80211: minstrel: fix sampling/reporting of CCK rates in HT mode
      mac80211: minstrel: do not sample rates 3 times slower than max_prob_rate
      mac80211: rc80211_minstrel: remove variance / stddev calculation

Johannes Berg (14):
      cfg80211: combine duplicate wdev init code
      cfg80211: tracing: reuse wiphy_wdev_evt for rdev_get_txq_stats
      nl80211: remove nl80211_prepare_wdev_dump() skb argument
      cfg80211: regulatory: make initialization more robust
      cfg80211: move cookie_counter out of wiphy
      nl80211: add error messages to nl80211_parse_chandef()
      cfg80211: combine wdev/netdev unregister code
      cfg80211: unify sending NL80211_CMD_NEW_INTERFACE
      cfg80211: sort tracing properly
      Merge remote-tracking branch 'net-next/master' into mac80211-next
      lib80211: don't use skcipher
      nl80211: use policy range validation where applicable
      nl80211: use netlink policy validation function for elements
      mac80211: avoid reflecting frames back to the client

Jouni Malinen (3):
      mac80211: Helper function for marking STA authenticated
      mac80211: Move ieee80211_mgd_auth() EBUSY check to be before allocation
      mac80211: Extend SAE authentication in infra BSS STA mode

Martin Willi (1):
      mac80211_hwsim: drop now unused work-queue from hwsim

Masashi Honma (1):
      mac80211: Remove unused initialization

Pradeep Kumar Chitrapu (2):
      cfg80211: support FTM responder configuration/statistics
      mac80211: support FTM responder configuration/statistics

Wei Yongjun (1):
      mac80211: fix error handling in ieee80211_register_hw()

zhong jiang (1):
      cfg80211: remove unnecessary null pointer check in cfg80211_netdev_notifier_call

 drivers/net/wireless/mac80211_hwsim.c      |  11 +-
 include/linux/ieee80211.h                  |   1 +
 include/net/cfg80211.h                     |  62 ++-
 include/net/mac80211.h                     |  43 ++
 include/uapi/linux/nl80211.h               |  98 ++++
 net/mac80211/Kconfig                       |  17 +-
 net/mac80211/Makefile                      |  11 +-
 net/mac80211/cfg.c                         |  85 +++
 net/mac80211/driver-ops.h                  |  16 +
 net/mac80211/ieee80211_i.h                 |   1 +
 net/mac80211/main.c                        |  11 +-
 net/mac80211/mlme.c                        | 107 ++--
 net/mac80211/rate.h                        |  13 -
 net/mac80211/rc80211_minstrel.c            | 162 ------
 net/mac80211/rc80211_minstrel.h            |  35 +-
 net/mac80211/rc80211_minstrel_debugfs.c    |  68 +--
 net/mac80211/rc80211_minstrel_ht.c         | 298 +++++++----
 net/mac80211/rc80211_minstrel_ht.h         |  20 +-
 net/mac80211/rc80211_minstrel_ht_debugfs.c |  58 +-
 net/mac80211/rx.c                          |  12 +-
 net/mac80211/status.c                      |  19 +
 net/mac80211/trace.h                       |  23 +
 net/mac80211/util.c                        |   8 +
 net/wireless/core.c                        |  83 +--
 net/wireless/core.h                        |  14 +
 net/wireless/lib80211_crypt_tkip.c         |  59 +-
 net/wireless/lib80211_crypt_wep.c          |  52 +-
 net/wireless/nl80211.c                     | 830 ++++++++++++++---------------
 net/wireless/rdev-ops.h                    |  15 +
 net/wireless/reg.c                         |   9 +
 net/wireless/trace.h                       | 233 ++++----
 31 files changed, 1338 insertions(+), 1136 deletions(-)
