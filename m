Return-Path: <SRS0=BEmV=76=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD530C433DF
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Jun 2020 08:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DBF02073E
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Jun 2020 08:43:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="D6r91UgF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgFQInM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Jun 2020 04:43:12 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:14812 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726634AbgFQInM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jun 2020 04:43:12 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1592383391; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=nB2sUVjfGPEdYQepVHohnfo2rl/Qh32Jwyl/hlaijGc=; b=D6r91UgFvoGC2bntuLtakr+K12LqrSpxelJRw8dhQrKLuBA1OqQu31EKkNlZHht1cZXa3IcU
 XJ8xkuW4NsVreaBuRmgobeJ7NZ+cHoNXxDjCDtq0pR8/13mWVVVckfGo9yEeCVkPYysFEM6l
 U87yBqir/7yPSqcoCeIuzXr6KKU=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-east-1.postgun.com with SMTP id
 5ee9d7868fe116ddd9c6c091 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 17 Jun 2020 08:42:46
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 62A79C43391; Wed, 17 Jun 2020 08:42:45 +0000 (UTC)
Received: from ssreeela-linux.qualcomm.com (blr-c-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: ppranees)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3F55CC433CB;
        Wed, 17 Jun 2020 08:42:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3F55CC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=ppranees@codeaurora.org
From:   P Praneesh <ppranees@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        P Praneesh <ppranees@codeaurora.org>
Subject: [PATCH] mac80211: avoid bss color setting in non-he mode
Date:   Wed, 17 Jun 2020 14:12:28 +0530
Message-Id: <1592383348-19266-1-git-send-email-ppranees@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Adding bss-color configuration for HE mode alone.
Earlier we have enabled it by default, irrespective
of capabilities. But bss-color feature is only for
HE mode. Hence avoiding this by adding bss-color flag
only for HE mode.

Signed-off-by: P Praneesh <ppranees@codeaurora.org>
---
 net/mac80211/cfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 548a384..2c5847d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -992,8 +992,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 		      BSS_CHANGED_P2P_PS |
 		      BSS_CHANGED_TXPOWER |
 		      BSS_CHANGED_TWT |
-		      BSS_CHANGED_HE_OBSS_PD |
-		      BSS_CHANGED_HE_BSS_COLOR;
+		      BSS_CHANGED_HE_OBSS_PD;
 	int i, err;
 	int prev_beacon_int;
 
@@ -1019,6 +1018,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 		sdata->vif.bss_conf.frame_time_rts_th =
 			le32_get_bits(params->he_oper->he_oper_params,
 			      IEEE80211_HE_OPERATION_RTS_THRESHOLD_MASK);
+		changed |= BSS_CHANGED_HE_BSS_COLOR;
 	}
 
 	mutex_lock(&local->mtx);
-- 
2.7.4

