Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B640C43461
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Apr 2021 19:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8094861158
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Apr 2021 19:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhDZTGa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Apr 2021 15:06:30 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:49055 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232868AbhDZTG3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Apr 2021 15:06:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619463948; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=po3JegB5oV8/BkdGAbdIR3FQ6uZYc7pFcgvulhI+rWM=; b=s9V56EmsijpR+7DxpwwsabqRTvWmYYF/ajCEgwsrgM8neZyh/YsjAAaQ53/FIThWO5/KdJ4I
 aGvAS67hSYyCiIgm4G5pJuRk4jolYV3elJG/1X0UkK4h99SXUItiiF/l/wu5pZVEWDdh8cuB
 9JH7E4irYW91aq68w8q4E+Tpb8I=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60870f042cc44d3aeae9afc4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 26 Apr 2021 19:05:40
 GMT
Sender: alokad=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C8D6BC43217; Mon, 26 Apr 2021 19:05:40 +0000 (UTC)
Received: from alokad-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: alokad)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 45B65C4338A;
        Mon, 26 Apr 2021 19:05:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 45B65C4338A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=alokad@codeaurora.org
From:   Aloka Dixit <alokad@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Aloka Dixit <alokad@codeaurora.org>
Subject: [PATCH v10 0/4] multiple bssid and EMA support in AP mode
Date:   Mon, 26 Apr 2021 12:05:30 -0700
Message-Id: <20210426190534.12667-1-alokad@codeaurora.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patchset adds support for multiple BSSID and
enhanced multi-BSSID advertisements for AP mode.

HWSIM support will be added in a separate patchset.

John Crispin (4):
  nl80211: multiple bssid and EMA support in AP mode
  mac80211: multiple bssid support in interface handling
  mac80211: MBSSID and EMA support in beacon handling
  mac80211: CSA on non-transmitting interfaces

 include/net/cfg80211.h       |  51 +++++++
 include/net/mac80211.h       | 123 ++++++++++++++-
 include/uapi/linux/nl80211.h | 101 ++++++++++++-
 net/mac80211/cfg.c           | 198 +++++++++++++++++++++++--
 net/mac80211/debugfs.c       |   2 +
 net/mac80211/ieee80211_i.h   |   2 +
 net/mac80211/iface.c         |  12 ++
 net/mac80211/tx.c            | 189 ++++++++++++++++++++---
 net/wireless/nl80211.c       | 280 ++++++++++++++++++++++++++++++-----
 9 files changed, 883 insertions(+), 75 deletions(-)


base-commit: 5d869070569a23aa909c6e7e9d010fc438a492ef
-- 
2.31.1

