Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E4CC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 08:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67B4720652
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 08:43:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfDZIm6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 04:42:58 -0400
Received: from nbd.name ([46.4.11.11]:53228 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbfDZIm5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 04:42:57 -0400
Received: from p548c8674.dip0.t-ipconnect.de ([84.140.134.116] helo=bertha.fritz.box)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hJwRY-0007KY-Mm; Fri, 26 Apr 2019 10:42:52 +0200
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Srini Kode <skode@qti.qualcomm.com>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        John Crispin <john@phrozen.org>
Subject: [PATCH 0/3] mac80211: notify the driver when it should enable TWT
Date:   Fri, 26 Apr 2019 10:42:41 +0200
Message-Id: <20190426084244.28098-1-john@phrozen.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The ath11k FW has a dedicated call for setting the TWT state. trigger this
changes to the BSS config.

In a later step we need to also add calls for manually stating TWT dialogs.

John Crispin (3):
  mac80211: allow turning TWT responder support on and off via netlink
  mac80211: dynamically turn TWT requester support on and off
  ath11k: add TWT support

 drivers/net/wireless/ath/ath11k/mac.c |  7 +++
 drivers/net/wireless/ath/ath11k/wmi.c | 91 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/wmi.h | 71 +++++++++++++++++++++++++++
 include/net/cfg80211.h                |  2 +
 include/net/mac80211.h                |  5 ++
 include/uapi/linux/nl80211.h          |  4 ++
 net/mac80211/cfg.c                    |  6 +++
 net/mac80211/mlme.c                   | 20 +++++++-
 net/wireless/nl80211.c                |  5 ++
 9 files changed, 209 insertions(+), 2 deletions(-)

-- 
2.11.0

