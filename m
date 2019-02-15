Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96A5C4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 12:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2E0B2075C
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 12:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394691AbfBOMvz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 07:51:55 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:40370 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389229AbfBOMvy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 07:51:54 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gucy8-0007ip-B2; Fri, 15 Feb 2019 13:51:52 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2019-02-15
Date:   Fri, 15 Feb 2019 13:51:45 +0100
Message-Id: <20190215125146.18856-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

It's clear things are winding down, this is basically just the stuff
from Herbert that we've been discussing. I threw in a simple error
path fix, mostly because it's simple :-)

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit f9bcc9f3ee4fbbe8f11dfec76745476f5780517e:

  net: ethernet: freescale: set FEC ethtool regs version (2019-02-14 12:45:35 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2019-02-15

for you to fetch changes up to 83e37e0bdd1470bbe6612250b745ad39b1a7b130:

  mac80211: Restore vif beacon interval if start ap fails (2019-02-15 13:30:24 +0100)

----------------------------------------------------------------
Just a few fixes this time:
 * mesh rhashtable fixes from Herbert
 * a small error path fix when starting AP interfaces

----------------------------------------------------------------
Herbert Xu (2):
      mac80211: Use linked list instead of rhashtable walk for mesh tables
      mac80211: Free mpath object when rhashtable insertion fails

Rakesh Pillai (1):
      mac80211: Restore vif beacon interval if start ap fails

 net/mac80211/cfg.c          |   6 +-
 net/mac80211/mesh.h         |   6 ++
 net/mac80211/mesh_pathtbl.c | 155 +++++++++++++-------------------------------
 3 files changed, 57 insertions(+), 110 deletions(-)

