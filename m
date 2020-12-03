Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6FD9C64E8A
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Dec 2020 10:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6697A2067B
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Dec 2020 10:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388533AbgLCKiY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Dec 2020 05:38:24 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:30032 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387840AbgLCKiY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Dec 2020 05:38:24 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606991884; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=phg2/TkrjV0irm6eIUZcG2DimLLflq+SrGdP4e4cIdY=; b=AY4fh6VQfIVZ4kNSu2vYHeWcaEVHxBiTAa/92O2oevNXyU3oUIsSnutUBEYmzMcXELyI1TS4
 skk/1oRscXVMSPn2/lEw/iXiOOUclx/6t+F/QmNTe2wri9cmkxP1v++UepznXIzg44R7wqjJ
 Zx1M/jAtzXBHZXYsoVxSpNEasVw=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5fc8bff20e79641fd5e1f4e3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 03 Dec 2020 10:37:38
 GMT
Sender: cjhuang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9D07CC43461; Thu,  3 Dec 2020 10:37:37 +0000 (UTC)
Received: from cjhuang-Inspiron-7590.qca.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cjhuang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 10D65C433ED;
        Thu,  3 Dec 2020 10:37:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 10D65C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=cjhuang@codeaurora.org
From:   Carl Huang <cjhuang@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, briannorris@chromium.org,
        dianders@chromium.org
Subject: [PATCH v4 0/3] add common API to configure SAR
Date:   Thu,  3 Dec 2020 05:37:25 -0500
Message-Id: <20201203103728.3034-1-cjhuang@codeaurora.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patchset is to add common API to configure SAR.
The mechanism is wlan driver registers sar capability
to wiphy and userspace queries it. Userspace then sets
power limiation to wlan driver.

v4:
- add "Reviewed-by:" tag

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

