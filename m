Return-Path: <SRS0=0wPU=BP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B2FC433DF
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Aug 2020 01:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B7AA2075D
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Aug 2020 01:19:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="qVhhg0+h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgHEBTD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Aug 2020 21:19:03 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:62712 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726762AbgHEBTC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Aug 2020 21:19:02 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596590341; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=qBDoBREbIYpXiHlIjDswlxm4JgKKfFgqREmkYnxS1tA=; b=qVhhg0+hOP9YNhnxUbMKhOAs6NT/VwoS/HoCCvr0UeiNzdStwerA/8oWFvbU5WA0pnOLeKcX
 dCTbhmnyVSTOsM2S81oHXE0AX/iAyziiWJHU7dielFCzc8hl4DD9S9LuYvwe/B5h5LVLOwaN
 0l4Z/bcT/uYtJce2qx7CkrLxNt4=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n15.prod.us-west-2.postgun.com with SMTP id
 5f2a08f60eaac7150eb75031 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 05 Aug 2020 01:18:46
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 311EBC433CA; Wed,  5 Aug 2020 01:18:46 +0000 (UTC)
Received: from alokad-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: alokad)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A5041C433C6;
        Wed,  5 Aug 2020 01:18:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A5041C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=alokad@codeaurora.org
From:   Aloka Dixit <alokad@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Aloka Dixit <alokad@codeaurora.org>
Subject: [PATCH v5 0/2] Add FILS discovery support
Date:   Tue,  4 Aug 2020 18:18:36 -0700
Message-Id: <20200805011838.28166-1-alokad@codeaurora.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patchset adds support for FILS discovery transmission as per
IEEE Std 802.11ai-2016.

v5: Addressed review comments from v4.

Aloka Dixit (2):
  nl80211: Add FILS discovery support
  mac80211: Add FILS discovery support

 include/net/cfg80211.h       | 23 +++++++++++++++
 include/net/mac80211.h       | 31 ++++++++++++++++++++
 include/uapi/linux/nl80211.h | 40 +++++++++++++++++++++++++
 net/mac80211/cfg.c           | 57 ++++++++++++++++++++++++++++++++----
 net/mac80211/debugfs.c       |  1 +
 net/mac80211/ieee80211_i.h   |  7 +++++
 net/mac80211/main.c          |  6 ++++
 net/mac80211/tx.c            | 28 ++++++++++++++++++
 net/wireless/nl80211.c       | 45 ++++++++++++++++++++++++++++
 9 files changed, 232 insertions(+), 6 deletions(-)

-- 
2.25.0

