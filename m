Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61117C64E7A
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Dec 2020 09:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05A412067D
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Dec 2020 09:42:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="ER4/jqHj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403785AbgLAJmb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Dec 2020 04:42:31 -0500
Received: from m42-5.mailgun.net ([69.72.42.5]:63061 "EHLO m42-5.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391060AbgLAJma (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Dec 2020 04:42:30 -0500
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Dec 2020 04:42:30 EST
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606815724; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=gpkMDoeUdaevEpDoNTHvqsV6XW6wb7L6hqUENT61/o0=; b=ER4/jqHjBgwOHJ3LjR1K8uPWXgLKc9UHr0N78HJJnKS3wrT/C8u8+O+pU6DfSAfuJd0vUa8d
 YdmxyA7G/gIbVL9hVUYmabmWfAzsSiDzcs4XUXl3cPdmtwilZrxP3vXAW7J2JLgguQ1o47so
 9mgiuowc40E1dH296gLYUl/Iyok=
X-Mailgun-Sending-Ip: 69.72.42.5
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5fc60e8bf653ea0cd85804a9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Dec 2020 09:36:11
 GMT
Sender: cjhuang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6A129C43462; Tue,  1 Dec 2020 09:36:11 +0000 (UTC)
Received: from cjhuang-Inspiron-7590.qca.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cjhuang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 96576C433C6;
        Tue,  1 Dec 2020 09:36:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 96576C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=cjhuang@codeaurora.org
From:   Carl Huang <cjhuang@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, briannorris@chromium.org,
        dianders@chromium.org
Subject: [PATCH v3 0/3]  add common API to configure SAR
Date:   Tue,  1 Dec 2020 04:36:00 -0500
Message-Id: <20201201093603.4093-1-cjhuang@codeaurora.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patchset is to add common API to configure SAR.
The mechanism is wlan driver registers sar capability
to wiphy and userspace queries it. Userspace then sets
power limitation to wlan driver.

v3:
- check index duplicates. If index duplicates, returns error

v2:
- rebased on ToT
- fix comments by Johannes and Abhishek
- change sar_power to s32 and range_index to u32

Carl Huang (3):
  nl80211: add common API to configure SAR power limitations.
  mac80211: add ieee80211_set_sar_specs
  ath10k: allow dynamic SAR power limits via common API

 drivers/net/wireless/ath/ath10k/core.c |  16 +++
 drivers/net/wireless/ath/ath10k/core.h |   3 +
 drivers/net/wireless/ath/ath10k/hw.h   |   2 +
 drivers/net/wireless/ath/ath10k/mac.c  | 225 ++++++++++++++++++++++++---------
 include/net/cfg80211.h                 |  51 ++++++++
 include/net/mac80211.h                 |   2 +
 include/uapi/linux/nl80211.h           | 102 +++++++++++++++
 net/mac80211/cfg.c                     |  12 ++
 net/wireless/nl80211.c                 | 185 +++++++++++++++++++++++++++
 net/wireless/rdev-ops.h                |  12 ++
 net/wireless/trace.h                   |  19 +++
 11 files changed, 570 insertions(+), 59 deletions(-)

-- 
2.7.4

