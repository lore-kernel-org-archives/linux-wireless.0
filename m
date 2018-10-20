Return-Path: <SRS0=EPmr=NA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA0EECDE3D
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 11:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53B892150F
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 11:05:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BHVEX03I";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BVwM+it6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53B892150F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbeJTTPo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 15:15:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52972 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727292AbeJTTPn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 15:15:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1277160913; Sat, 20 Oct 2018 11:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540033539;
        bh=eYkMGWiMgr7vHjUfNeOoa/YWB+kb1Ns3Oj0QPje5lFg=;
        h=From:To:Cc:Subject:Date:From;
        b=BHVEX03Ih51+z1VxpOQl3uROUvLocqWeiDy3oJMaj3B0ybf90BLIQ18N3m2VPTyeX
         cYM6bVB1tPWo4y8nYt4tqvWl9cdI/oZp8Y/zBpEpbQGMgQ+0xSelPTdG6/DoOz6lMt
         0GaY4k5NXTWB5HHaNyTJL2Kg+8vMdLFnecd9pbkM=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 519B7604BE;
        Sat, 20 Oct 2018 11:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540033538;
        bh=eYkMGWiMgr7vHjUfNeOoa/YWB+kb1Ns3Oj0QPje5lFg=;
        h=From:To:Cc:Subject:Date:From;
        b=BVwM+it6MnPR0RY7ql92CewKycpAwKk+3Rgsvl0hJOSk0xp9mh2YzfSjm6MWiq+Y8
         MSHgNbWNjLm0LZpZXzhcUAHRKBB7ASlSXITIxDLC33aYff/Rtc87Rzrp6m/5BNija0
         kNS+zo1GU6VlSv+6E1aFuuwivlfzNpTJCIRkRKiU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 519B7604BE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Sat, 20 Oct 2018 04:05:36 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [PATCH 0/6] Move TXQ scheduling and airtime fairness into mac80211
Date:   Sat, 20 Oct 2018 04:05:28 -0700
Message-Id: <1540033534-11211-1-git-send-email-rmanohar@codeaurora.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Toke,

It is been a while since mac80211 TXQ discussion started. Here is the consolidated
series of mac80211, ath9k and ath10k changes to move TXQ scheduling and airtime
fairness into mac80211. The major changes w.r.t 5th RFC version are in may_transmit()
API. Whenever the driver checks deficit for given TXQ, the list will be
reordered so that driver/firmware RR quickly becomes in sync with mac80211
list. Also airtime tasklet approach cumbersome and causing regression
in multi client performance.

- Removed airtime kickout tasklet

- Reworked on ieee80211_txq_may_transmit() API

- Provided option to configure driver specific default airtime. 

- Bundled ath10k changes along with this series.

-Rajkumar
 
Rajkumar Manoharan (2):
  ath10k: migrate to mac80211 txq scheduling
  ath10k: reporting estimated tx airtime for fairness

Toke Høiland-Jørgensen (4):
  mac80211: Add TXQ scheduling API
  cfg80211: Add airtime statistics and settings
  mac80211: Add airtime accounting and scheduling to TXQs
  ath9k: Switch to mac80211 TXQ scheduling and airtime APIs

 drivers/net/wireless/ath/ath10k/core.c     |   2 -
 drivers/net/wireless/ath/ath10k/core.h     |   8 +-
 drivers/net/wireless/ath/ath10k/htc.h      |   1 -
 drivers/net/wireless/ath/ath10k/htt_rx.c   |   9 ++
 drivers/net/wireless/ath/ath10k/mac.c      | 155 +++++++++++-------
 drivers/net/wireless/ath/ath10k/txrx.c     |   4 +
 drivers/net/wireless/ath/ath9k/ath9k.h     |  14 --
 drivers/net/wireless/ath/ath9k/debug.c     |   3 -
 drivers/net/wireless/ath/ath9k/debug.h     |   8 -
 drivers/net/wireless/ath/ath9k/debug_sta.c |  70 ---------
 drivers/net/wireless/ath/ath9k/init.c      |   3 +-
 drivers/net/wireless/ath/ath9k/recv.c      |   9 +-
 drivers/net/wireless/ath/ath9k/xmit.c      | 244 +++++++++--------------------
 include/net/cfg80211.h                     |  10 +-
 include/net/mac80211.h                     | 118 +++++++++++++-
 include/uapi/linux/nl80211.h               |  15 ++
 net/mac80211/agg-tx.c                      |   2 +-
 net/mac80211/cfg.c                         |   3 +
 net/mac80211/debugfs.c                     |   3 +
 net/mac80211/debugfs_sta.c                 |  50 +++++-
 net/mac80211/driver-ops.h                  |   9 ++
 net/mac80211/ieee80211_i.h                 |  12 ++
 net/mac80211/main.c                        |   9 ++
 net/mac80211/sta_info.c                    |  54 ++++++-
 net/mac80211/sta_info.h                    |  13 ++
 net/mac80211/status.c                      |   6 +
 net/mac80211/tx.c                          | 140 ++++++++++++++++-
 net/wireless/nl80211.c                     |  28 ++++
 28 files changed, 646 insertions(+), 356 deletions(-)

-- 
1.9.1

