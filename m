Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B6AC41518
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 13:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 711C6218E2
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 13:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfAYNUx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 08:20:53 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:57458 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfAYNUx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 08:20:53 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gn1Pe-0001j7-Mh; Fri, 25 Jan 2019 14:20:50 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2019-01-25
Date:   Fri, 25 Jan 2019 14:20:40 +0100
Message-Id: <20190125132041.13375-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

Here are 8 fixes for the current cycle, nothing that seems out of
the ordinary.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 8a7fa0c35027d1a3ec3c3e8612800a1b4738e3c3:

  Merge tag 'mlx5-fixes-2019-01-18' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2019-01-18 18:23:23 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2019-01-25

for you to fetch changes up to 93183bdbe73bbdd03e9566c8dc37c9d06b0d0db6:

  cfg80211: extend range deviation for DMG (2019-01-25 10:18:51 +0100)

----------------------------------------------------------------
Just a few small fixes:
 * avoid trying to operate TDLS when not connection,
   this is not valid and led to issues
 * count TTL-dropped frames in mesh better
 * deal with new WiGig channels in regulatory code
 * remove a WARN_ON() that can trigger due to benign
   races during device/driver registration
 * fix nested netlink policy maxattrs (syzkaller)
 * fix hwsim n_limits (syzkaller)
 * propagate __aligned(2) to a surrounding struct
 * return proper error in virt_wifi error path

----------------------------------------------------------------
Balaji Pothunoori (1):
      mac80211: don't initiate TDLS connection if station is not associated to AP

Bob Copeland (1):
      mac80211: fix miscounting of ttl-dropped frames

Chaitanya Tata (2):
      cfg80211: reg: remove warn_on for a normal case
      cfg80211: extend range deviation for DMG

Johannes Berg (2):
      mac80211_hwsim: check that n_limits makes sense
      nl80211: fix NLA_POLICY_NESTED() arguments

Mathieu Malaterre (1):
      mac80211: Add attribute aligned(2) to struct 'action'

Wei Yongjun (1):
      virt_wifi: fix error return code in virt_wifi_newlink()

 drivers/net/wireless/mac80211_hwsim.c |  5 +++++
 drivers/net/wireless/virt_wifi.c      |  4 +++-
 net/mac80211/cfg.c                    |  4 ++++
 net/mac80211/rx.c                     |  6 ++++--
 net/wireless/nl80211.c                |  2 +-
 net/wireless/reg.c                    | 13 +++++++++----
 6 files changed, 26 insertions(+), 8 deletions(-)

