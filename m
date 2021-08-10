Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90108C432BE
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Aug 2021 08:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B1FB60EC0
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Aug 2021 08:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237898AbhHJI5I (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 10 Aug 2021 04:57:08 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:62782 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232978AbhHJI5H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Aug 2021 04:57:07 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628585806; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=bDhmj8HOl+jHQkiuraV3jXyEErZkA8xz/WZyOnK0yw4=; b=Soajkf42tTVCwebmRt1L0QJOAUi4cyzoYhy93g0YbHhIFkCJj3jQJm4w/ntss78aWrJTHzR2
 qZXvrD18Ackeor3dOO0vIshZRIRH9sTDXU4X9t6CyUv3ZZ6nZKMC/c8JMwoAhy7tnVVpjEqT
 iqbyRLLo8FEFoFQr8ln1mImHDIg=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 61123f3db14e7e2ecbc2931d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 10 Aug 2021 08:56:29
 GMT
Sender: mkenna=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 814FAC43217; Tue, 10 Aug 2021 08:56:29 +0000 (UTC)
Received: from ppranees-linux.qualcomm.com (blr-c-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mkenna)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BE7EDC4338A;
        Tue, 10 Aug 2021 08:56:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BE7EDC4338A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=mkenna@codeaurora.org
From:   Maharaja Kennadyrajan <mkenna@codeaurora.org>
To:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org
Cc:     Maharaja Kennadyrajan <mkenna@codeaurora.org>
Subject: [PATCH v5 0/3] Add support to configure beacon tx mode
Date:   Tue, 10 Aug 2021 14:26:20 +0530
Message-Id: <1628585783-21139-1-git-send-email-mkenna@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add support to configure the beacon tx mode as STAGGERED
or BURST mode via hostapd configuration during the AP
bring-up or via wpa_suppplicant configuration during MESH
bring-up.

Beacons can be sent out in burst(continuously in a single shot
one after another) or staggered (equally spread out over beacon
interval) mode.

V5: Addressed Johannes's and Felix's comment on v4.

V4: Rebased on latest ath.git TOT.

V3: Addressed Johnson's comment on v2 patch.

V2: Addressed Johannes's comment on v1 patch.

Maharaja Kennadyrajan (3):
  nl80211: Add support for beacon tx mode
  mac80211: Add support for beacon tx mode
  ath11k: Add support for beacon tx mode

 drivers/net/wireless/ath/ath11k/mac.c | 10 +++++++---
 include/net/cfg80211.h                |  4 ++++
 include/net/mac80211.h                |  2 ++
 include/uapi/linux/nl80211.h          | 20 ++++++++++++++++++++
 net/mac80211/cfg.c                    |  2 ++
 net/wireless/nl80211.c                | 11 +++++++++++
 6 files changed, 46 insertions(+), 3 deletions(-)

-- 
2.7.4

