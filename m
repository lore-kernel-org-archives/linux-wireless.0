Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83950C433DB
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Jan 2021 08:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C99820878
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Jan 2021 08:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730074AbhASIO2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Jan 2021 03:14:28 -0500
Received: from a1.mail.mailgun.net ([198.61.254.60]:23361 "EHLO
        a1.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730989AbhASILn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jan 2021 03:11:43 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611043873; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=iXY4t0AiwPZAqR8gGon7bhXtng3YxUhWvhS1wjCMWw0=; b=FbkLRTB6wEwhuQETBpUAhIYB7GypfSNYWFZEpyb6NwY8RBydBfdMpcESoprgh3joQeIkn6TH
 9WAkoRpc18tEcoR/cyIazbvVHckA5noyjCtirCpRr1A7rVO+1h0DcdHtfwe0DCvDs081oUdL
 WUeGQqjU1b0g0Fo3I4mFonHtfmc=
X-Mailgun-Sending-Ip: 198.61.254.60
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 600693f975e5c01cba0f0f04 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 19 Jan 2021 08:10:33
 GMT
Sender: alokad=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3D899C433CA; Tue, 19 Jan 2021 08:10:33 +0000 (UTC)
Received: from alokad-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: alokad)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A2D14C433C6;
        Tue, 19 Jan 2021 08:10:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A2D14C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=alokad@codeaurora.org
From:   Aloka Dixit <alokad@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Aloka Dixit <alokad@codeaurora.org>
Subject: [PATCH V6 0/4] mac80211: add multiple bssid support
Date:   Tue, 19 Jan 2021 00:10:23 -0800
Message-Id: <20210119081027.5133-1-alokad@codeaurora.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patchset adds support for multiple BSSID and
enhanced multi-BSSID advertisements.
Individual patches describe the changes in this version.

John Crispin (4):
  nl80211: add basic multiple bssid support
  mac80211: add multiple bssid support to interface handling
  mac80211: add multiple bssid/EMA support to beacon handling
  mac80211: CSA on non-transmitting interfaces

 include/net/cfg80211.h       |  47 +++++++++
 include/net/mac80211.h       | 116 ++++++++++++++++++++-
 include/uapi/linux/nl80211.h |  66 ++++++++++++
 net/mac80211/cfg.c           | 181 ++++++++++++++++++++++++++++++--
 net/mac80211/debugfs.c       |   1 +
 net/mac80211/ieee80211_i.h   |   2 +
 net/mac80211/iface.c         |   6 ++
 net/mac80211/tx.c            | 189 +++++++++++++++++++++++++++++----
 net/wireless/nl80211.c       | 197 +++++++++++++++++++++++++++++------
 9 files changed, 741 insertions(+), 64 deletions(-)


base-commit: 0ae5b43d6dde6003070106e97cd0d41bace2eeb2
-- 
2.25.0

