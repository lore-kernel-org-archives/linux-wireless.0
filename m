Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B94C4167B
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Dec 2020 03:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3EC3221F8
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Dec 2020 03:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgLGDgV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 6 Dec 2020 22:36:21 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:14688 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728583AbgLGDgV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 6 Dec 2020 22:36:21 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607312161; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=OW3BxPM5ee5qmxWXxVRu9QkhvMKFI+1pGCUBvh1AYlw=; b=H+FS2gvC28Zdf2R5zT2bfNT+RCx177JGKp90gxgc6Iw/vgsN9SeTysRel9Q7dPYr0/RZAp7n
 SMpNDdjcEYetSyLd3F3ulIkLw1uw0lpPPdd09MrMEr4gtRiM72oZybEql9/pWflsJOToDFd/
 740UaZiFr2+Ec1IwEIr3rhhX0oQ=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5fcda30435e04c51ab209523 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 07 Dec 2020 03:35:32
 GMT
Sender: wgong=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C2440C433CA; Mon,  7 Dec 2020 03:35:31 +0000 (UTC)
Received: from gongwen-ThinkPad-T420.qca.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wgong)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1D5C1C433CA;
        Mon,  7 Dec 2020 03:35:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1D5C1C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=wgong@codeaurora.org
From:   Wen Gong <wgong@codeaurora.org>
To:     ath10k@lists.infradead.org, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, wgong@codeaurora.org
Subject: [PATCH 0/2] mac80211/ath10k: save ssid info for STATION mode
Date:   Mon,  7 Dec 2020 11:36:33 +0800
Message-Id: <1607312195-3583-1-git-send-email-wgong@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

save the ssid info for STATION mode which could be used for ath10k to
get the corret/exact cfg80211_bss.

Wen Gong (2):
  mac80211: save ssid info to ieee80211_bss_conf while assoc
  ath10k: pass the ssid info to get the correct bss entity

 drivers/net/wireless/ath/ath10k/mac.c | 3 ++-
 net/mac80211/mlme.c                   | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

-- 
2.23.0

