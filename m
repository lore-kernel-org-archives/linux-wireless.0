Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D9E3C10F00
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 13:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EF6B2081B
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 13:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfBVNK5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 08:10:57 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:38530 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfBVNK5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 08:10:57 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gxAbP-0003jk-4S; Fri, 22 Feb 2019 14:10:55 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2019-02-22
Date:   Fri, 22 Feb 2019 14:10:51 +0100
Message-Id: <20190222131052.28249-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

So ... I thought there weren't going to be any more patches
when I asked you to apply that mac80211 one, but now a few
days later I still ended up with three that are current and
possibly even stable material.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 6321aa197547da397753757bd84c6ce64b3e3d89:

  phonet: fix building with clang (2019-02-21 16:23:56 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2019-02-22

for you to fetch changes up to 51d0af222f6fa43134c6187ab4f374630f6e0d96:

  mac80211: allocate tailroom for forwarded mesh packets (2019-02-22 14:00:40 +0100)

----------------------------------------------------------------
Three more fixes:
 * mac80211 mesh code wasn't allocating SKB tailroom properly
   in some cases
 * tx_sk_pacing_shift should be 7 for better performance
 * mac80211_hwsim wasn't propagating genlmsg_reply() errors

----------------------------------------------------------------
Felix Fietkau (1):
      mac80211: allocate tailroom for forwarded mesh packets

Li RongQing (1):
      mac80211_hwsim: propagate genlmsg_reply return code

Toke Høiland-Jørgensen (1):
      mac80211: Change default tx_sk_pacing_shift to 7

 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 net/mac80211/main.c                   | 4 ++--
 net/mac80211/rx.c                     | 7 ++++++-
 3 files changed, 9 insertions(+), 4 deletions(-)

