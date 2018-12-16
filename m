Return-Path: <SRS0=od2B=OZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C584C43387
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Dec 2018 14:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3B12217FA
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Dec 2018 14:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbeLPOGe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 16 Dec 2018 09:06:34 -0500
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:29057 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729822AbeLPOGe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Dec 2018 09:06:34 -0500
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Dec 2018 09:06:33 EST
X-IronPort-AV: E=Sophos;i="5.56,361,1539640800"; 
   d="scan'208";a="1661981"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 16 Dec 2018 14:58:51 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9107"; a="6611859"
Received: from lx-amasri.mea.qualcomm.com ([10.18.172.210])
  by ironmsg01-ams.qualcomm.com with ESMTP; 16 Dec 2018 14:58:50 +0100
From:   Ahmad Masri <amasri@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: [PATCH 0/2] Add support for ACS offload for AP
Date:   Sun, 16 Dec 2018 15:58:09 +0200
Message-Id: <1544968691-20679-1-git-send-email-amasri@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The following set of patches add support for Automatic Channel Selection
(ACS) offload for AP in cfg80211 and an implementation in wil6210 driver.

Ahmad Masri (2):
  cfg80211: Add Automatic Channel Selection (ACS) offload for AP
  wil6210: add implementation of acs cfg80211_ops

 drivers/net/wireless/ath/wil6210/cfg80211.c | 140 ++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/debugfs.c  | 154 +++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/main.c     |   5 +
 drivers/net/wireless/ath/wil6210/wil6210.h  |  15 +++
 drivers/net/wireless/ath/wil6210/wmi.c      |  76 ++++++++++++
 drivers/net/wireless/ath/wil6210/wmi.h      |   3 +-
 include/net/cfg80211.h                      |  33 +++++
 include/uapi/linux/nl80211.h                |  65 ++++++++++
 net/wireless/mlme.c                         |  31 +++++
 net/wireless/nl80211.c                      | 182 ++++++++++++++++++++++++++++
 net/wireless/nl80211.h                      |   6 +
 net/wireless/rdev-ops.h                     |  12 ++
 net/wireless/trace.h                        |  23 ++++
 13 files changed, 742 insertions(+), 3 deletions(-)

-- 
1.9.1

