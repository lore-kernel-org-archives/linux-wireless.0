Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB3DC433DB
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Jan 2021 23:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76CF422D74
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Jan 2021 23:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbhAFX7S (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Jan 2021 18:59:18 -0500
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:64467 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726918AbhAFX7S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Jan 2021 18:59:18 -0500
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 06 Jan 2021 15:50:58 -0800
X-QCInternal: smtphost
Received: from mxchen-linux.qualcomm.com (HELO mxchen-linux.localdomain) ([10.234.28.165])
  by ironmsg05-sd.qualcomm.com with ESMTP; 06 Jan 2021 15:50:57 -0800
Received: by mxchen-linux.localdomain (Postfix, from userid 451784)
        id 009CE3D45; Wed,  6 Jan 2021 15:50:56 -0800 (PST)
From:   Max Chen <mxchen@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Max Chen <mxchen@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 0/2] Add Extended MCS Phyrate Conversion Support on 60GHz
Date:   Wed,  6 Jan 2021 15:50:48 -0800
Message-Id: <1609977050-7089-1-git-send-email-mxchen@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The following set of patches add phyrate conversion support for extended MCS
on 60GHz band:
-Cfg80211 support for extended MCS phyrate conversions
-Wil6210 support for extended MCS 12.1

Max Chen (2):
  cfg80211: Add phyrate conversion support for extended MCS in 60GHz
    band
  wil6210: Add Support for Extended DMG MCS 12.1

 drivers/net/wireless/ath/wil6210/cfg80211.c  | 38 ++++++++++++++++++++++------
 drivers/net/wireless/ath/wil6210/debugfs.c   | 17 ++++++++-----
 drivers/net/wireless/ath/wil6210/txrx_edma.c |  2 ++
 drivers/net/wireless/ath/wil6210/wil6210.h   |  3 +++
 drivers/net/wireless/ath/wil6210/wmi.c       | 11 ++++----
 include/net/cfg80211.h                       |  2 ++
 net/wireless/util.c                          | 21 +++++++++++++++
 7 files changed, 75 insertions(+), 19 deletions(-)

-- 
2.7.4

