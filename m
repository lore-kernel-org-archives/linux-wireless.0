Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0740C43441
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 11:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E27220862
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 11:04:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="nmNgUsTa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E27220862
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=wetzel-home.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbeKKUwP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Nov 2018 15:52:15 -0500
Received: from 5.mo5.mail-out.ovh.net ([87.98.173.103]:34813 "EHLO
        5.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbeKKUwO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Nov 2018 15:52:14 -0500
X-Greylist: delayed 71107 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Nov 2018 15:52:14 EST
Received: from player728.ha.ovh.net (unknown [10.109.143.72])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id 76D3F201D90
        for <linux-wireless@vger.kernel.org>; Sun, 11 Nov 2018 12:03:58 +0100 (CET)
Received: from awhome.eu (p4FF91EF0.dip0.t-ipconnect.de [79.249.30.240])
        (Authenticated sender: postmaster@awhome.eu)
        by player728.ha.ovh.net (Postfix) with ESMTPSA id 422AA54008F;
        Sun, 11 Nov 2018 12:03:57 +0100 (CET)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1541934236;
        bh=1Lv5qvx6MKDVQF0gfEVUd4QYzMh20lsq31Mi1P8ojkA=;
        h=From:To:Cc:Subject:Date;
        b=nmNgUsTamGe6cUP6Sn4+rmYlmEb/XM+MIKZJOhIxcLp7sLqV71n77zpAhJ6SycPLz
         uoHnaQzkzrO1kOCYor2s3k0JIbKo3zNKthtjhUsTgGiD27TTlO8z3KGUsx02vI5wUB
         8+rJfMTDru1rPfiM3swEXhiBnwcoAxVp37qhNgZA=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [RFC PATCH v2 0/2] Extended Key ID support for linux
Date:   Sun, 11 Nov 2018 12:02:33 +0100
Message-Id: <20181111110235.14213-1-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 909164178465299655
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrkeejgddvvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecu
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

IEEE 802.11-2012 added support for Extended Key ID, allowing pairwise
keys to also use keyID 1 and moving group keys to IDs 2 and 3.

Support for Extended Key ID is basically completed and confirmed working
with both hwsim and "on the air" with ath9k/iwldvm using software
encryption and those patches here.

(The corresponding patch for wpa_supplicanat/hostapd need some more
work, but that's mostly cleanup and support for STKSAs.)

Prior to propose this patch for merging I would like to get Extended
Key ID working with HW encryption for at least some devices, but after
experimenting with ath9k and to a lesser extend with ath10k it's now
clear that this will be an per-driver effort and it may well turn out to
be impossible without firmware updates.

So I've decided to continue working on the HW support for now but also
ask you for feedback for what I got so far. 
Any feedback is welcome and I especially like to learn what you think of
the API extensions and what has to be changed to get it merged.

RFC patch history:
v2:
Correct tested version without null pointer bug

Alexander Wetzel (2):
  nl80211/cfg80211: Add support for Extended Key ID
  mac80211: Add support for Extended Key ID

 include/net/cfg80211.h       |  2 ++
 include/net/mac80211.h       |  6 +++++
 include/uapi/linux/nl80211.h | 41 ++++++++++++++++++++++++++---
 net/mac80211/cfg.c           | 30 ++++++++++++++++++++-
 net/mac80211/debugfs_sta.c   |  1 +
 net/mac80211/key.c           | 46 +++++++++++++++++++++++++-------
 net/mac80211/key.h           |  1 +
 net/mac80211/main.c          |  2 ++
 net/mac80211/sta_info.c      |  1 +
 net/mac80211/sta_info.h      |  1 +
 net/wireless/nl80211.c       | 51 ++++++++++++++++++++++++++++++++----
 net/wireless/rdev-ops.h      |  3 ++-
 net/wireless/trace.h         | 31 ++++++++++++++++++----
 net/wireless/util.c          |  9 ++++---
 14 files changed, 197 insertions(+), 28 deletions(-)

-- 
2.19.1

