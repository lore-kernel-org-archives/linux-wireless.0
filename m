Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F02CC282CE
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 11:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E39A7217D9
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 11:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbfBLLvd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 06:51:33 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:48084 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfBLLvd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 06:51:33 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gtWb4-0005JV-Hw; Tue, 12 Feb 2019 12:51:30 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2019-02-12
Date:   Tue, 12 Feb 2019 12:51:20 +0100
Message-Id: <20190212115121.27086-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

We have few more fixes, mostly one-liners; two are bigger:
 * the speculation one, only because the function had multiple
   return points and that had to change, and
 * the peer measurement locking one, because I had to refactor
   a function to be able to call it with or without locking
   (depending on context).

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit f09bef61f1ed72869b231e5cff16e73a06505cfb:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf (2019-02-05 11:23:23 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2019-02-12

for you to fetch changes up to 6157ca0d6bfe437691b1e98a62e2efe12b6714da:

  mac80211: Fix Tx aggregation session tear down with ITXQs (2019-02-11 15:50:56 +0100)

----------------------------------------------------------------
Just a few fixes:
 * aggregation session teardown with internal TXQs was
   continuing to send some frames marked as aggregation,
   fix from Ilan
 * IBSS join was missed during firmware restart, should
   such a thing happen
 * speculative execution based on the return value of
   cfg80211_classify8021d() - which is controlled by the
   sender of the packet - could be problematic in some
   code using it, prevent it
 * a few peer measurement fixes

----------------------------------------------------------------
Aviya Erenfeld (1):
      nl80211: Fix FTM per burst maximum value

Ilan Peer (1):
      mac80211: Fix Tx aggregation session tear down with ITXQs

Johannes Berg (5):
      cfg80211: pmsr: fix MAC address setting
      cfg80211: pmsr: fix abort locking
      mac80211: call drv_ibss_join() on restart
      cfg80211: pmsr: record netlink port ID
      cfg80211: prevent speculation on cfg80211_classify8021d() return

 net/mac80211/agg-tx.c  |  4 +++-
 net/mac80211/util.c    |  6 +++++-
 net/wireless/core.c    |  2 ++
 net/wireless/nl80211.c |  2 +-
 net/wireless/pmsr.c    | 26 +++++++++++++++++---------
 net/wireless/util.c    | 35 ++++++++++++++++++++++++-----------
 6 files changed, 52 insertions(+), 23 deletions(-)

