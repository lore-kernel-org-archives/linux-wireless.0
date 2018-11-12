Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2283AC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 22:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D10C8223DD
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 22:52:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ze7++Dqd";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ze7++Dqd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D10C8223DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbeKMIrO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Nov 2018 03:47:14 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44360 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbeKMIrN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Nov 2018 03:47:13 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C43E160764; Mon, 12 Nov 2018 22:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542063118;
        bh=HI2JM1w88EGflNxd1xgBFCra5zqD6kusDXxxVISKG5U=;
        h=From:To:Cc:Subject:Date:From;
        b=Ze7++Dqd4uDCsRON9F0J+nbz0RdJMYuAau2uYEY3syCz7Nngy4M1v3tJzfjGsNdk2
         iyH3L+RwpHe2CFfLiLFGDqhkghknA6q8mUDhgnWAYg//63H+blIFPkwC9/D7LYWSmQ
         dhNwkn70zyBUc9ANFngUMNBIuJ74iq4DRS9kZ+EU=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 041F860600;
        Mon, 12 Nov 2018 22:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542063118;
        bh=HI2JM1w88EGflNxd1xgBFCra5zqD6kusDXxxVISKG5U=;
        h=From:To:Cc:Subject:Date:From;
        b=Ze7++Dqd4uDCsRON9F0J+nbz0RdJMYuAau2uYEY3syCz7Nngy4M1v3tJzfjGsNdk2
         iyH3L+RwpHe2CFfLiLFGDqhkghknA6q8mUDhgnWAYg//63H+blIFPkwC9/D7LYWSmQ
         dhNwkn70zyBUc9ANFngUMNBIuJ74iq4DRS9kZ+EU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 041F860600
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Mon, 12 Nov 2018 14:51:56 -0800
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     make-wifi-fast@lists.bufferbloat.net,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [PATCH v3 0/6] Move TXQ scheduling and airtime fairness into mac80211
Date:   Mon, 12 Nov 2018 14:51:47 -0800
Message-Id: <1542063113-22438-1-git-send-email-rmanohar@codeaurora.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Here is the consolidated series of mac80211, ath9k and ath10k changes
for moving TXQ scheduling and airtime fairness into mac80211 and support
airtime fairness.

Three main APIs are defined for TXQ scheduling.
  - ieee80211_next_txq
  - ieee80211_return_txq
  - ieee80211_txq_may_transmit

and two APIs for synchronization when the driver wants to iterate
through all TXQs.
  - ieee80211_txq_schedule_start
  - ieee80211_txq_schedule_end

The earlier discussions:
https://patchwork.kernel.org/project/linux-wireless/list/?series=&submitter=&state=*&q=TXQ+scheduling&archive=both&delegate=

-Rajkumar

v2:
 - replaced driver specific airtime default by multiplier
 - fixed tab intent
 - fixed author and commit log
v3:
 - fixed checkpatch warnings and kbuild bot errors.
   few of over 80 char warnings are left.

Kan Yan (1):
  ath10k: reporting estimated tx airtime for fairness

Toke Høiland-Jørgensen (5):
  mac80211: Add TXQ scheduling API
  cfg80211: Add airtime statistics and settings
  mac80211: Add airtime accounting and scheduling to TXQs
  ath9k: Switch to mac80211 TXQ scheduling and airtime APIs
  ath10k: migrate to mac80211 txq scheduling

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
 include/net/mac80211.h                     | 121 +++++++++++++-
 include/uapi/linux/nl80211.h               |  15 ++
 net/mac80211/agg-tx.c                      |   2 +-
 net/mac80211/cfg.c                         |   3 +
 net/mac80211/debugfs.c                     |   3 +
 net/mac80211/debugfs_sta.c                 |  50 +++++-
 net/mac80211/driver-ops.h                  |   9 ++
 net/mac80211/ieee80211_i.h                 |  11 ++
 net/mac80211/main.c                        |   9 ++
 net/mac80211/sta_info.c                    |  46 +++++-
 net/mac80211/sta_info.h                    |  13 ++
 net/mac80211/status.c                      |   6 +
 net/mac80211/tx.c                          | 140 ++++++++++++++++-
 net/wireless/nl80211.c                     |  30 ++++
 28 files changed, 644 insertions(+), 354 deletions(-)

-- 
1.9.1

