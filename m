Return-Path: <SRS0=RiXY=B6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B2DC433E4
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Aug 2020 05:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CDE120786
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Aug 2020 05:15:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="eLhDhhez"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgHTFPY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Aug 2020 01:15:24 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:21587 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbgHTFPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Aug 2020 01:15:21 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597900520; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=5+szVYDqnoVVDDx1+q3X3XssRFHIxhGh3LoZIm3QOBI=; b=eLhDhhezj0w8o6wszfgXkaFxAP1H7AQ7F4wFPw/hd8qZ7C0Se+ll8I7c6I7mYMdXVZRl1nEG
 5HvDCGxWIQQDME2t51UJtUOUNusQCMNzLCe15ZcRrGQ6Y2Cq9uXkunwBAlshnaMz1q3/MafL
 s2EfnKyjEgSGH4KGpTGE/qOAZ6M=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5f3e06d1f729de10789923d7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 20 Aug 2020 05:14:57
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 59894C43387; Thu, 20 Aug 2020 05:14:56 +0000 (UTC)
Received: from seevalam-linux.qualcomm.com (blr-c-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B6242C433CA;
        Thu, 20 Aug 2020 05:14:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B6242C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh Chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Tamizh Chelvam <tamizhr@codeaurora.org>
Subject: [PATCH] iw: print hop_count and path_change info of mpath
Date:   Thu, 20 Aug 2020 10:44:45 +0530
Message-Id: <1597900485-673-1-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Print hop_count and path_change info which is already providing
by Driver for all mpath through mpath dump command.

Signed-off-by: Tamizh Chelvam <tamizhr@codeaurora.org>
---
 mpath.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mpath.c b/mpath.c
index e39c24b..a88f89f 100644
--- a/mpath.c
+++ b/mpath.c
@@ -38,6 +38,8 @@ static int print_mpath_handler(struct nl_msg *msg, void *arg)
 		[NL80211_MPATH_INFO_DISCOVERY_TIMEOUT] = { .type = NLA_U32 },
 		[NL80211_MPATH_INFO_DISCOVERY_RETRIES] = { .type = NLA_U8 },
 		[NL80211_MPATH_INFO_FLAGS] = { .type = NLA_U8 },
+		[NL80211_MPATH_INFO_HOP_COUNT] = { .type = NLA_U8 },
+		[NL80211_MPATH_INFO_PATH_CHANGE] = { .type = NLA_U32 },
 	};
 
 	nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
@@ -85,6 +87,12 @@ static int print_mpath_handler(struct nl_msg *msg, void *arg)
 	if (pinfo[NL80211_MPATH_INFO_FLAGS])
 		printf("\t0x%x",
 			nla_get_u8(pinfo[NL80211_MPATH_INFO_FLAGS]));
+	if (pinfo[NL80211_MPATH_INFO_HOP_COUNT])
+		printf("\t%u",
+		       nla_get_u8(pinfo[NL80211_MPATH_INFO_HOP_COUNT]));
+	if (pinfo[NL80211_MPATH_INFO_PATH_CHANGE])
+		printf("\t%u",
+		       nla_get_u32(pinfo[NL80211_MPATH_INFO_PATH_CHANGE]));
 
 	printf("\n");
 	return NL_SKIP;
@@ -218,7 +226,7 @@ static int handle_mpath_dump(struct nl80211_state *state,
 			     enum id_input id)
 {
 	printf("DEST ADDR         NEXT HOP          IFACE\tSN\tMETRIC\tQLEN\t"
-	       "EXPTIME\t\tDTIM\tDRET\tFLAGS\n");
+	       "EXPTIME\t\tDTIM\tDRET\tFLAGS\tHOP_COUNT\tPATH_CHANGE\n");
 	register_handler(print_mpath_handler, NULL);
 	return 0;
 }
-- 
1.9.1

