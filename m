Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD14BC433DB
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Jan 2021 00:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A3CE23108
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Jan 2021 00:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730033AbhATAwT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Jan 2021 19:52:19 -0500
Received: from m42-8.mailgun.net ([69.72.42.8]:20916 "EHLO m42-8.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729436AbhATAwR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jan 2021 19:52:17 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611103915; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=Xkd/Bcz6n2t4PA2ITTKp3gZBWSknzNaWjkNeUHNlgZg=; b=Qng3ylqSrYo+LzTBTvHcZHCcQqWdF2yTRWTRXRVkW5t4g1hj0yOH96rncrOlTtftpP1UD8nF
 dyvjlztcuu2htSwutlWP0IAfeG00F/ZCYelYUuqbXgRhXZMcgGxDpSwjBACx2kplncB5hEIt
 2HYSNk9j0kAQCWfOeSFCdmn2Va0=
X-Mailgun-Sending-Ip: 69.72.42.8
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 60077e91e23dedcc3a941154 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 20 Jan 2021 00:51:29
 GMT
Sender: alokad=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BA81FC43461; Wed, 20 Jan 2021 00:51:27 +0000 (UTC)
Received: from alokad-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: alokad)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DD9F6C433CA;
        Wed, 20 Jan 2021 00:51:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DD9F6C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=alokad@codeaurora.org
From:   Aloka Dixit <alokad@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Aloka Dixit <alokad@codeaurora.org>
Subject: [PATCH V7 0/4] mac80211: add multiple bssid support
Date:   Tue, 19 Jan 2021 16:51:16 -0800
Message-Id: <20210120005120.32424-1-alokad@codeaurora.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patchset adds support for multiple BSSID and
enhanced multi-BSSID advertisements.
This version adds few calls to kfree() in nl80211.c which were
missing in V6.

John Crispin (4):
  nl80211: add basic multiple bssid support
  mac80211: add multiple bssid support to interface handling
  mac80211: add multiple bssid/EMA support to beacon handling
  mac80211: CSA on non-transmitting interfaces

 include/net/cfg80211.h       |  47 ++++++
 include/net/mac80211.h       | 116 +++++++++++++-
 include/uapi/linux/nl80211.h |  66 ++++++++
 net/mac80211/cfg.c           | 181 ++++++++++++++++++++--
 net/mac80211/debugfs.c       |   1 +
 net/mac80211/ieee80211_i.h   |   2 +
 net/mac80211/iface.c         |   6 +
 net/mac80211/tx.c            | 189 ++++++++++++++++++++---
 net/wireless/nl80211.c       | 282 +++++++++++++++++++++++++++--------
 9 files changed, 796 insertions(+), 94 deletions(-)


base-commit: 0ae5b43d6dde6003070106e97cd0d41bace2eeb2
-- 
2.25.0

