Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A87C56202
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 09:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BF642145D
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 09:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgKMJe3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Nov 2020 04:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgKMJe3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Nov 2020 04:34:29 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64FEC0613D1;
        Fri, 13 Nov 2020 01:34:28 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kdVTO-006rg8-UA; Fri, 13 Nov 2020 10:34:27 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2020-11-13
Date:   Fri, 13 Nov 2020 10:34:20 +0100
Message-Id: <20201113093421.24025-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Jakub,

We have a few fixes, most importantly probably the fix for
the sleeping-in-atomic syzbot reported half a dozen (or so)
times.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 52755b66ddcef2e897778fac5656df18817b59ab:

  cosa: Add missing kfree in error path of cosa_write (2020-11-11 17:52:01 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2020-11-13

for you to fetch changes up to 7bc40aedf24d31d8bea80e1161e996ef4299fb10:

  mac80211: free sta in sta_info_insert_finish() on errors (2020-11-13 09:48:32 +0100)

----------------------------------------------------------------
A handful of fixes:
 * a use-after-free fix in rfkill
 * a memory leak fix in the mac80211 TX status path
 * some rate scaling fixes
 * a fix for the often-reported (by syzbot) sleeping
   in atomic issue with mac80211's station removal

----------------------------------------------------------------
Claire Chang (1):
      rfkill: Fix use-after-free in rfkill_resume()

Felix Fietkau (3):
      mac80211: fix memory leak on filtered powersave frames
      mac80211: minstrel: remove deferred sampling code
      mac80211: minstrel: fix tx status processing corner case

Johannes Berg (1):
      mac80211: free sta in sta_info_insert_finish() on errors

 net/mac80211/rc80211_minstrel.c | 27 +++++----------------------
 net/mac80211/rc80211_minstrel.h |  1 -
 net/mac80211/sta_info.c         | 14 ++++----------
 net/mac80211/status.c           | 18 ++++++++----------
 net/rfkill/core.c               |  3 +++
 5 files changed, 20 insertions(+), 43 deletions(-)

