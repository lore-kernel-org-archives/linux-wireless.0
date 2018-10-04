Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B308AC64EBC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 19:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 884B22087D
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 19:44:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 884B22087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbeJECi4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 22:38:56 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:50126 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbeJECi4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 22:38:56 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g89Xd-0000Y1-Fz; Thu, 04 Oct 2018 21:44:09 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2018-10-04
Date:   Thu,  4 Oct 2018 21:43:54 +0200
Message-Id: <20181004194355.1364-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

I got three more fixes submitted, and am sending those to you
now in the hope of still getting them in, although all of the
bugs are actually older than the current cycle.

If there's a release on Sunday then I guess I won't care, but
if not then I'd appreciate if you could pull net into net-next
as I have at least one patch there that otherwise doesn't apply
(at least the result wouldn't compile). Not sure if you've seen
anything from Greg indicating either way.

Anyway, for now these fixes look good to me, so please pull or
let me know if there's any problem.

Thanks,
johannes



The following changes since commit 43955a45dc0b4f3be7f0c3afc0e080ed59bb5280:

  netlink: fix typo in nla_parse_nested() comment (2018-09-29 11:48:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2018-10-04

for you to fetch changes up to 1db58529454742f67ebd96e3588315e880b72837:

  cfg80211: fix use-after-free in reg_process_hint() (2018-10-01 09:14:03 +0200)

----------------------------------------------------------------
Just three small fixes:
 * fix use-after-free in regulatory code
 * fix rx-mgmt key flag in AP mode (mac80211)
 * fix wireless extensions compat code memory leak

----------------------------------------------------------------
Felix Fietkau (1):
      mac80211: fix setting IEEE80211_KEY_FLAG_RX_MGMT for AP mode keys

Stefan Seyfried (1):
      cfg80211: fix wext-compat memory leak

Yu Zhao (1):
      cfg80211: fix use-after-free in reg_process_hint()

 net/mac80211/cfg.c         |  2 +-
 net/wireless/reg.c         |  7 ++++---
 net/wireless/wext-compat.c | 14 ++++++++++----
 3 files changed, 15 insertions(+), 8 deletions(-)
