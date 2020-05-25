Return-Path: <SRS0=BuOi=7H=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D98C433E1
	for <linux-wireless@archiver.kernel.org>; Mon, 25 May 2020 14:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84130207CB
	for <linux-wireless@archiver.kernel.org>; Mon, 25 May 2020 14:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390884AbgEYOP6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 May 2020 10:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388714AbgEYOP6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 May 2020 10:15:58 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997D7C061A0E;
        Mon, 25 May 2020 07:15:58 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jdDtU-002lZQ-97; Mon, 25 May 2020 16:15:56 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2020-05-25
Date:   Mon, 25 May 2020 16:15:46 +0200
Message-Id: <20200525141547.40538-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

We have a couple more fixes, all of them seem sort of older issues
that surfaced now.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 98790bbac4db1697212ce9462ec35ca09c4a2810:

  Merge tag 'efi-urgent-2020-05-24' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2020-05-24 10:24:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2020-05-25

for you to fetch changes up to 0bbab5f0301587cad4e923ccc49bb910db86162c:

  cfg80211: fix debugfs rename crash (2020-05-25 13:12:32 +0200)

----------------------------------------------------------------
A few changes:
 * fix a debugfs vs. wiphy rename crash
 * fix an invalid HE spec definition
 * fix a mesh timer crash

----------------------------------------------------------------
Johannes Berg (1):
      cfg80211: fix debugfs rename crash

Linus Lüssing (1):
      mac80211: mesh: fix discovery timer re-arming issue / crash

Pradeep Kumar Chitrapu (1):
      ieee80211: Fix incorrect mask for default PE duration

 include/linux/ieee80211.h | 2 +-
 net/mac80211/mesh_hwmp.c  | 7 +++++++
 net/wireless/core.c       | 2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

