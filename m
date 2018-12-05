Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5F0C04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 14:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ADA620878
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 14:29:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5ADA620878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbeLEO3w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 09:29:52 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:41360 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727606AbeLEO3v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 09:29:51 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gUYBQ-0000Sn-OS; Wed, 05 Dec 2018 15:29:48 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2018-12-05
Date:   Wed,  5 Dec 2018 15:29:34 +0100
Message-Id: <20181205142935.29088-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

As per the below summary / shortlog, we have a few things
that should still go into the current release.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit ea53abfab960909d622ca37bcfb8e1c5378d21cc:

  bonding/802.3ad: fix link_failure_count tracking (2018-11-04 16:44:44 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2018-12-05

for you to fetch changes up to 312ca38ddda64bac6513ec68e0ac3789b4eb44dc:

  cfg80211: Fix busy loop regression in ieee80211_ie_split_ric() (2018-12-05 12:51:29 +0100)

----------------------------------------------------------------
As it's been a while, we have various fixes for
 * hwsim
 * AP mode (client powersave related)
 * CSA/FTM interaction
 * a busy loop in IE handling
 * and similar

----------------------------------------------------------------
Alexey Khoroshilov (1):
      mac80211_hwsim: fix module init error paths for netlink

Ben Greear (1):
      mac80211: Clear beacon_int in ieee80211_do_stop

Emmanuel Grumbach (1):
      mac80211: ignore NullFunc frames in the duplicate detection

Felix Fietkau (2):
      mac80211: ignore tx status for PS stations in ieee80211_tx_status_ext
      mac80211: fix reordering of buffered broadcast packets

Johannes Berg (2):
      cfg80211/mac80211: fix FTM settings across CSA
      mac80211: fix CSA beacon allocation size

Jouni Malinen (1):
      cfg80211: Fix busy loop regression in ieee80211_ie_split_ric()

Sergey Matyukevich (1):
      cfg80211: add missing constraint for user-supplied VHT mask

Sriram R (1):
      cfg80211: Prevent regulatory restore during STA disconnect in concurrent interfaces

Vasyl Vavrychuk (1):
      mac80211_hwsim: Timer should be initialized before device registered

Wei Yongjun (1):
      mac80211: fix missing unlock on error in ieee80211_mark_sta_auth()

Yan-Hsuan Chuang (1):
      mac80211: fix GFP_KERNEL under tasklet context

 drivers/net/wireless/mac80211_hwsim.c | 20 +++++++++++---------
 net/mac80211/cfg.c                    |  7 ++++---
 net/mac80211/iface.c                  |  2 ++
 net/mac80211/mlme.c                   | 12 ++++++++----
 net/mac80211/rx.c                     |  5 +++--
 net/mac80211/status.c                 |  2 ++
 net/mac80211/tx.c                     |  4 ++--
 net/wireless/mlme.c                   |  4 ++--
 net/wireless/nl80211.c                |  1 +
 net/wireless/sme.c                    |  8 +++++++-
 net/wireless/util.c                   |  2 ++
 11 files changed, 44 insertions(+), 23 deletions(-)

