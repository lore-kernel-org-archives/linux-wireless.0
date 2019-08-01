Return-Path: <SRS0=c1p6=V5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D592FC19759
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Aug 2019 13:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9083206B8
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Aug 2019 13:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbfHANQW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Aug 2019 09:16:22 -0400
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:9929 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728476AbfHANQV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Aug 2019 09:16:21 -0400
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 01 Aug 2019 15:16:20 +0200
Received: from unknown (HELO wigig-1329.mea.qualcomm.com) ([10.4.89.235])
  by ironmsg03-ams.qualcomm.com with ESMTP; 01 Aug 2019 15:16:16 +0200
From:   Alexei Avshalom Lazar <ailizaro@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: [PATCH v6 0/2] Add support for new channels on 60GHz band
Date:   Thu,  1 Aug 2019 16:16:12 +0300
Message-Id: <1564665374-2856-1-git-send-email-ailizaro@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The following set of patches add support for new channels on
60GHz band and EDMG channels:
Changelog:
V6:
- update commit message
- initialize chandef variable
V5:
- Addressed to comments from the community
- Added enum for bw_config
- Updated nla_policy to NLA_POLICY_RANGE()
V4:
- Addressed to comments from the community
- Updated comments and variable name
V3:
- Addressed to comments from the community
- Added 60G check for verifying some EDMG cases are relevant
- Used the ieee80211_sta_edmg_cap struct as the edmg channel configuration
- Updated nla_policy to NLA_POLICY_RANGE()
V2
- Addressed to comments from the community
- Align to latest Spec release

Alexei Avshalom Lazar (2):
  nl80211: Add support for EDMG channels
  wil6210: Add EDMG channel support

 drivers/net/wireless/ath/wil6210/cfg80211.c  | 205 +++++++++++++++++++++++++--
 drivers/net/wireless/ath/wil6210/txrx_edma.c |   2 +
 drivers/net/wireless/ath/wil6210/txrx_edma.h |   6 +
 drivers/net/wireless/ath/wil6210/wil6210.h   |   8 +-
 drivers/net/wireless/ath/wil6210/wmi.c       |   5 +-
 drivers/net/wireless/ath/wil6210/wmi.h       |  26 +++-
 include/net/cfg80211.h                       |  86 ++++++++++-
 include/uapi/linux/nl80211.h                 |  24 ++++
 net/mac80211/mlme.c                          |   2 +-
 net/mac80211/status.c                        |   2 +-
 net/wireless/chan.c                          | 159 +++++++++++++++++++++
 net/wireless/nl80211.c                       |  37 +++++
 net/wireless/util.c                          |  42 +++++-
 13 files changed, 584 insertions(+), 20 deletions(-)

-- 
2.7.4

