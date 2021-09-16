Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B071C433F5
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Sep 2021 02:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7959961178
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Sep 2021 02:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbhIPC4P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 15 Sep 2021 22:56:15 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:13413 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbhIPC4O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Sep 2021 22:56:14 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1631760895; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: To: From: Sender;
 bh=ofmd4mTJfu3vkiMdzoWiYJjc/KmHyk3vI4sfIgg/uOw=; b=wFn4aG+hKxz8MoneEapBRtUo50fsBC5xmUsTV5g6keWCm0TI4fkHV2zo3iDFwci5Dd9f5eUo
 yd3F83YYd/CgDv2AhsccxgovyPadnaLiip6eYby/W4UkTwh0w1cEWf1YCASArAXczMw+X4pE
 IppEgElxrRtU48W544cjqKSPKiU=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 6142b1f3b585cc7d24eb01cb (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 16 Sep 2021 02:54:43
 GMT
Sender: alokad=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4C2E3C43618; Thu, 16 Sep 2021 02:54:43 +0000 (UTC)
Received: from alokad-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: alokad)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B2D9BC4360D;
        Thu, 16 Sep 2021 02:54:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org B2D9BC4360D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Aloka Dixit <alokad@codeaurora.org>
To:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: [PATCH v12 0/4] MBSSID and EMA support in AP mode
Date:   Wed, 15 Sep 2021 19:54:33 -0700
Message-Id: <20210916025437.29138-1-alokad@codeaurora.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patchset adds support for multiple BSSID and
enhanced multi-BSSID advertisements for AP mode.
Individual patches describe the changes in this version.

John Crispin (4):
  nl80211: MBSSID and EMA support in AP mode
  mac80211: MBSSID support in interface handling
  mac80211: MBSSID and EMA support in beacon handling
  mac80211: MBSSID channel switch

 include/net/cfg80211.h       |  44 ++++++
 include/net/mac80211.h       |  92 ++++++++++++
 include/uapi/linux/nl80211.h |  76 +++++++++-
 net/mac80211/cfg.c           | 192 +++++++++++++++++++++---
 net/mac80211/ieee80211_i.h   |   2 +
 net/mac80211/iface.c         |  29 +++-
 net/mac80211/tx.c            | 173 +++++++++++++++++++---
 net/wireless/nl80211.c       | 277 ++++++++++++++++++++++++++++++-----
 8 files changed, 805 insertions(+), 80 deletions(-)


base-commit: 339133f6c318612f9a4556c300753beda27abc01
-- 
2.31.1

