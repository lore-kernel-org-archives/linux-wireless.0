Return-Path: <SRS0=QcoQ=US=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1198C31E49
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Jun 2019 08:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B828120823
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Jun 2019 08:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731072AbfFSIFD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Jun 2019 04:05:03 -0400
Received: from nbd.name ([46.4.11.11]:38486 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbfFSIFD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jun 2019 04:05:03 -0400
Received: from pd95fd3e4.dip0.t-ipconnect.de ([217.95.211.228] helo=bertha.fritz.box)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hdVaW-0005zH-6k; Wed, 19 Jun 2019 10:05:00 +0200
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        John Crispin <john@phrozen.org>
Subject: [PATCH V7 0/2] mac80211: add 802.11 encapsulation offloading
Date:   Wed, 19 Jun 2019 10:04:55 +0200
Message-Id: <20190619080457.17135-1-john@phrozen.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This series picks up prior work from QCA. The patch is currently shipped
inside QSDK as part of the wlan-open package.

The series tries to address all feedback from the V2
-> https://patchwork.kernel.org/patch/9602585/

Changes in V3
* rebase on latest kernel
* various code style clean ups
* give some of the variables and functions more obvious names
* move the code that disables support for non-linear frames to the core
* disable monitor and tkip support

Changes in V4
* disable encap when TKIP is used instead of refusing TKIP
* use a flag inside tx_info instead of an extra element
* move 4addr detection into ieee80211_set_hw_80211_encap()
* ieee80211_tx_dequeue() was dropping out to early

Changes in V5
* implement comments from Johannes

Changes in V6
* the conditional masking out monitor support was inverse

Changes in V7
* dont mask out monitor support when encap is available. Instead turn encap
  of if a monitor device is brought up or already present

Vasanthakumar Thiagarajan (2):
  mac80211: add hw 80211 encapsulation offloading support
  ath10k: add tx hw 802.11 encapusaltion offloading suppor

 drivers/net/wireless/ath/ath10k/core.c   |  11 ++
 drivers/net/wireless/ath/ath10k/core.h   |   3 +
 drivers/net/wireless/ath/ath10k/htt_tx.c |  24 +--
 drivers/net/wireless/ath/ath10k/mac.c    |  70 +++++++--
 drivers/net/wireless/ath/ath10k/txrx.c   |  11 +-
 include/net/mac80211.h                   |  25 +++
 net/mac80211/cfg.c                       |   6 +
 net/mac80211/debugfs.c                   |   1 +
 net/mac80211/ieee80211_i.h               |  10 ++
 net/mac80211/iface.c                     | 100 ++++++++++++
 net/mac80211/key.c                       |   7 +
 net/mac80211/main.c                      |   4 +-
 net/mac80211/status.c                    |  79 ++++++++++
 net/mac80211/tx.c                        | 187 ++++++++++++++++++++++-
 14 files changed, 507 insertions(+), 31 deletions(-)

-- 
2.20.1

