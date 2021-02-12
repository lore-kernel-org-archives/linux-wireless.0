Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECFAEC433E0
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Feb 2021 13:56:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADFD764E57
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Feb 2021 13:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhBLN4i (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Feb 2021 08:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhBLN4h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Feb 2021 08:56:37 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C269C061574;
        Fri, 12 Feb 2021 05:55:57 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lAYvL-001riz-OT; Fri, 12 Feb 2021 14:55:55 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2021-02-12
Date:   Fri, 12 Feb 2021 14:55:50 +0100
Message-Id: <20210212135551.49439-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

This is almost certainly a last update for net-next, and
it's not very big - the biggest chunk here is minstrel
improvements from Felix, to lower overhead.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 3c5a2fd042d0bfac71a2dfb99515723d318df47b:

  tcp: Sanitize CMSG flags and reserved args in tcp_zerocopy_receive. (2021-02-11 18:25:05 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2021-02-12

for you to fetch changes up to 735a48481cca453525d9199772f9c3733a47cff4:

  nl80211: add documentation for HT/VHT/HE disable attributes (2021-02-12 11:00:07 +0100)

----------------------------------------------------------------
Last set of updates:
 * more minstrel work from Felix to reduce the
   probing overhead
 * QoS for nl80211 control port frames
 * STBC injection support
 * and a couple of small fixes

----------------------------------------------------------------
Ben Greear (1):
      cfg80211/mac80211: Support disabling HE mode

Colin Ian King (1):
      mac80211: fix potential overflow when multiplying to u32 integers

Felix Fietkau (6):
      mac80211: minstrel_ht: use bitfields to encode rate indexes
      mac80211: minstrel_ht: update total packets counter in tx status path
      mac80211: minstrel_ht: reduce the need to sample slower rates
      mac80211: minstrel_ht: significantly redesign the rate probing strategy
      mac80211: minstrel_ht: show sampling rates in debugfs
      mac80211: minstrel_ht: remove sample rate switching code for constrained devices

Johannes Berg (1):
      nl80211: add documentation for HT/VHT/HE disable attributes

Luca Coelho (1):
      cfg80211: initialize reg_rule in __freq_reg_info()

Markus Theil (1):
      mac80211: enable QoS support for nl80211 ctrl port

Matteo Croce (1):
      cfg80211: remove unused callback

Philipp Borgers (1):
      mac80211: add STBC encoding to ieee80211_parse_tx_radiotap

 include/net/cfg80211.h                     |   2 +
 include/uapi/linux/nl80211.h               |  13 +-
 net/mac80211/mesh_hwmp.c                   |   2 +-
 net/mac80211/mlme.c                        |   3 +
 net/mac80211/rc80211_minstrel_ht.c         | 766 ++++++++++++++---------------
 net/mac80211/rc80211_minstrel_ht.h         |  47 +-
 net/mac80211/rc80211_minstrel_ht_debugfs.c |  22 +-
 net/mac80211/status.c                      |   8 +-
 net/mac80211/tx.c                          |  34 +-
 net/wireless/nl80211.c                     |   7 +
 net/wireless/reg.c                         |   2 +-
 net/wireless/sysfs.c                       |   7 -
 12 files changed, 486 insertions(+), 427 deletions(-)

