Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD35C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 08:49:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 195C62133F
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 08:49:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbeLSItv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 03:49:51 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:54554 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbeLSItu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 03:49:50 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gZXY4-0004og-2M; Wed, 19 Dec 2018 09:49:48 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2018-12-19
Date:   Wed, 19 Dec 2018 09:49:41 +0100
Message-Id: <20181219084942.8245-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

It's getting late in the cycle, so I don't know if you still want to
take these in, but we have three fixes for kernel crashes we've seen
at least here at Intel.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit a5f3932646a74e690ed532a1f421f75c3b8cf1ec:

  net: dsa: mv88e6xxx: set ethtool regs version (2018-12-17 23:29:00 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2018-12-19

for you to fetch changes up to 34b1e0e9efe101822e83cc62d22443ed3867ae7a:

  mac80211: free skb fraglist before freeing the skb (2018-12-19 09:40:17 +0100)

----------------------------------------------------------------
Just three fixes:
 * fix a memory leak in an error path
 * fix TXQs in interface teardown
 * free fraglist if we used it internally
   before returning SKB

----------------------------------------------------------------
Johannes Berg (1):
      nl80211: fix memory leak if validate_pae_over_nl80211() fails

Sara Sharon (2):
      mac80211: fix a kernel panic when TXing after TXQ teardown
      mac80211: free skb fraglist before freeing the skb

 net/mac80211/iface.c   | 3 +++
 net/mac80211/main.c    | 2 --
 net/mac80211/status.c  | 5 +++++
 net/wireless/nl80211.c | 4 +++-
 4 files changed, 11 insertions(+), 3 deletions(-)

