Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA37C10F14
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 21:40:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 544D020850
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 21:40:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="plve36pE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfDLVkS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 17:40:18 -0400
Received: from [208.74.158.174] ([208.74.158.174]:33336 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfDLVkS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 17:40:18 -0400
Received: from v-f24-64.candelatech.com (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        by mail3.candelatech.com (Postfix) with ESMTP id DFD8513C2B9;
        Fri, 12 Apr 2019 14:40:17 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com DFD8513C2B9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1555105218;
        bh=GJ+eo5+Sp9maQ370wrEcV5dXSzZigGvgdbdmIax19Rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=plve36pEDjoCbeOleIP2XX3IHcx+uvWNkVHrS8A/7FIY9ni5nO9+eMK6fQkXdE0Tf
         4XviDp/GtyyuVAQgxvM1CqX/tkxt33ta5XaprBFurtdQHhgG5uoictidFAR1q1gn5H
         zMevB45/2WgGVGmjyYpmJmCggVQMCNYfrQ4jGjVw=
From:   greearb@candelatech.com
To:     linux-wireless@vger.kernel.org
Cc:     Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] iw:  Print current time in station info dump
Date:   Fri, 12 Apr 2019 14:40:10 -0700
Message-Id: <1555105210-22996-2-git-send-email-greearb@candelatech.com>
X-Mailer: git-send-email 2.7.5
In-Reply-To: <1555105210-22996-1-git-send-email-greearb@candelatech.com>
References: <1555105210-22996-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

This lets us more precisely calculate the absolute timestamp
of last-rix (ie, now - idle).

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 station.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/station.c b/station.c
index 3b0c5f1..60804f2 100644
--- a/station.c
+++ b/station.c
@@ -314,6 +314,12 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		[NL80211_STA_INFO_ACK_SIGNAL_AVG] = { .type = NLA_U8 },
 	};
 	char *chain;
+	struct timeval now;
+	unsigned long long now_ms;
+
+	gettimeofday(&now, NULL);
+	now_ms = now.tv_sec * 1000;
+	now_ms += (now.tv_usec / 1000);
 
 	nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
 		  genlmsg_attrlen(gnlh, 0), NULL);
@@ -561,7 +567,7 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		printf("\n\tauthenticated at:\t%llu ms",
 			 (unsigned long long)nla_get_u64(sinfo[NL80211_STA_INFO_AUTH_AT_MS]));
 
-	printf("\n");
+	printf("\n\tcurrent time:\t%llu ms\n", now_ms);
 	return NL_SKIP;
 }
 
-- 
2.7.5

