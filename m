Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A623EC282DA
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80E2F2084F
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfDILpv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 07:45:51 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47830 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbfDILpv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 07:45:51 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDpCC-0002pS-FJ; Tue, 09 Apr 2019 13:45:44 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2019-04-09
Date:   Tue,  9 Apr 2019 13:45:36 +0200
Message-Id: <20190409114537.19171-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

Here's a set of fixes for the current cycle. Mostly all over,
but some focus from Felix on the mac80211 internal TXQs.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 9a5a90d167b0e5fe3d47af16b68fd09ce64085cd:

  net: core: netif_receive_skb_list: unlist skb before passing to pt->func (2019-03-28 17:28:05 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2019-04-09

for you to fetch changes up to 78ad2341521d5ea96cb936244ed4c4c4ef9ec13b:

  mac80211: Honor SW_CRYPTO_CONTROL for unicast keys in AP VLAN mode (2019-04-09 13:40:32 +0200)

----------------------------------------------------------------
Various fixes:
 * iTXQ fixes from Felix
 * tracing fix - increase message length
 * fix SW_CRYPTO_CONTROL enforcement
 * WMM rule handling for regdomain intersection
 * max_interfaces in hwsim - reported by syzbot
 * clear private data in some more commands
 * a clang compiler warning fix

I added a patch with two new (unused) macros for
rate-limited printing to simplify getting the users
into the tree.

----------------------------------------------------------------
Alexander Wetzel (1):
      mac80211: Honor SW_CRYPTO_CONTROL for unicast keys in AP VLAN mode

Andrei Otcheretianski (1):
      mac80211: Increase MAX_MSG_LEN

Felix Fietkau (6):
      mac80211: un-schedule TXQs on powersave start
      mac80211: fix unaligned access in mesh table hash function
      mac80211: fix memory accounting with A-MSDU aggregation
      mac80211: do not call driver wake_tx_queue op during reconfig
      mac80211: rework locking for txq scheduling / airtime fairness
      mac80211: make ieee80211_schedule_txq schedule empty TXQs

Ilan Peer (1):
      cfg80211: Handle WMM rules in regulatory domain intersection

Johannes Berg (1):
      mac80211_hwsim: calculate if_combination.max_interfaces

Nathan Chancellor (1):
      cfg80211: Change an 'else if' into an 'else' in cfg80211_calculate_bitrate_he

Stanislaw Gruszka (1):
      cfg80211: add ratelimited variants of err and warn

Sunil Dutt (1):
      nl80211: Add NL80211_FLAG_CLEAR_SKB flag for other NL commands

YueHaibing (1):
      cfg80211: Use kmemdup in cfg80211_gen_new_ie()

 drivers/net/wireless/ath/ath10k/htt_rx.c |  2 +-
 drivers/net/wireless/ath/ath10k/mac.c    |  4 +-
 drivers/net/wireless/ath/ath9k/xmit.c    |  5 ++-
 drivers/net/wireless/mac80211_hwsim.c    | 19 ++++++++--
 include/net/cfg80211.h                   |  5 +++
 include/net/mac80211.h                   | 63 +++++++++++++++++---------------
 net/mac80211/driver-ops.h                |  3 ++
 net/mac80211/key.c                       |  9 ++---
 net/mac80211/mesh_pathtbl.c              |  2 +-
 net/mac80211/rx.c                        | 10 ++++-
 net/mac80211/trace_msg.h                 |  7 +++-
 net/mac80211/tx.c                        | 53 ++++++++++++---------------
 net/wireless/nl80211.c                   | 18 ++++++---
 net/wireless/reg.c                       | 39 ++++++++++++++++++++
 net/wireless/scan.c                      |  3 +-
 net/wireless/util.c                      |  6 ++-
 16 files changed, 163 insertions(+), 85 deletions(-)

