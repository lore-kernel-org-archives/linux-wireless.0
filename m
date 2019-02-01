Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B66C282DB
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 10:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 378442086C
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 10:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbfBAKR5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 05:17:57 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:37996 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfBAKR4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 05:17:56 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gpVtR-0007MJ-QV; Fri, 01 Feb 2019 11:17:54 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2019-02-01
Date:   Fri,  1 Feb 2019 11:17:43 +0100
Message-Id: <20190201101744.7551-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

Two more fixes for the current cycle, one is a new bug introduced
in 4.20, the other one seems to be much older.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 5e66e35aab335b83d9ffb220d8a3a13986a7a60e:

  bnxt_en: Disable interrupts when allocating CP rings or NQs. (2019-01-31 12:55:28 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2019-02-01

for you to fetch changes up to e005bd7ddea06784c1eb91ac5bb6b171a94f3b05:

  cfg80211: call disconnect_wk when AP stops (2019-02-01 11:12:50 +0100)

----------------------------------------------------------------
Two more fixes:
 * sometimes, not enough tailroom was allocated for
   software-encrypted management frames in mac80211
 * cfg80211 regulatory restore got an additional condition,
   needs to rerun the checks after that condition changes

----------------------------------------------------------------
Felix Fietkau (1):
      mac80211: ensure that mgmt tx skbs have tailroom for encryption

Johannes Berg (1):
      cfg80211: call disconnect_wk when AP stops

 net/mac80211/tx.c   | 12 +++++++++---
 net/wireless/ap.c   |  2 ++
 net/wireless/core.h |  2 ++
 net/wireless/sme.c  |  2 +-
 4 files changed, 14 insertions(+), 4 deletions(-)

