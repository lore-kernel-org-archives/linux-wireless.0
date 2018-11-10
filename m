Return-Path: <SRS0=mdyG=NV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B63AAC43441
	for <linux-wireless@archiver.kernel.org>; Sat, 10 Nov 2018 15:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12C9720858
	for <linux-wireless@archiver.kernel.org>; Sat, 10 Nov 2018 15:21:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="Le6NCM4m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 12C9720858
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=wetzel-home.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbeKKBHI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 10 Nov 2018 20:07:08 -0500
Received: from 3.mo177.mail-out.ovh.net ([46.105.36.172]:50511 "EHLO
        3.mo177.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbeKKBHI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Nov 2018 20:07:08 -0500
X-Greylist: delayed 6616 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Nov 2018 20:07:07 EST
Received: from player739.ha.ovh.net (unknown [10.109.160.251])
        by mo177.mail-out.ovh.net (Postfix) with ESMTP id B746BD1D2E
        for <linux-wireless@vger.kernel.org>; Sat, 10 Nov 2018 13:54:06 +0100 (CET)
Received: from awhome.eu (p57B7E4EB.dip0.t-ipconnect.de [87.183.228.235])
        (Authenticated sender: postmaster@awhome.eu)
        by player739.ha.ovh.net (Postfix) with ESMTPSA id 7265D4A00A6;
        Sat, 10 Nov 2018 13:54:05 +0100 (CET)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1541854444;
        bh=xRM2pBghOc/mUv8PPxUtJopYLAHlypbEQcsNDnQSm30=;
        h=From:To:Cc:Subject:Date;
        b=Le6NCM4myukIv22fZ2OckfurVXjO1hgZ/5M2dxo+ns7YmqwjyfKpqaqPQ7LTVLdzf
         h6nNup2X5pWAiKlt2eDppSThrrTywotlSlgbHuNtibBniX5nJuvcQWIoJf2+lCRGFp
         MeUP5eU/wAN1kPR/WnUpLPMc1COnV8Xnu9oJdypM=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [RFC PATCH 0/2] Extended Key ID support for linux
Date:   Sat, 10 Nov 2018 13:53:29 +0100
Message-Id: <20181110125331.2726-1-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 15343200984743091399
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrkeehgdegiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecu
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

