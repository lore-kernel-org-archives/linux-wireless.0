Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B317BC10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 21:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D12C20850
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 21:40:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="URZQvU0U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfDLVkP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 17:40:15 -0400
Received: from [208.74.158.174] ([208.74.158.174]:33322 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfDLVkP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 17:40:15 -0400
Received: from v-f24-64.candelatech.com (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        by mail3.candelatech.com (Postfix) with ESMTP id D8A5113C2B9;
        Fri, 12 Apr 2019 14:40:14 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com D8A5113C2B9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1555105214;
        bh=AFBHr02OV/E3qmpQmrl0HvuLgWGGG4zwdFg7CADvGMo=;
        h=From:To:Cc:Subject:Date:From;
        b=URZQvU0UJVb5aPotz3xO6FBBe89QBHasHVqa9RDKopEZZ6FAClMxqsixR5lkupxvu
         KPK+c9FHWHM6KAAHzg9Bif++I9dMWGMJTkRxGwZ50m2m+GKdfutSsCuEpC180whgEb
         klWWzCqSuuWssQHMiyYqAAA7eJl+tDKsDXXWd/lc=
From:   greearb@candelatech.com
To:     linux-wireless@vger.kernel.org
Cc:     Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] iw:  Support authenticated-at station statistic.
Date:   Fri, 12 Apr 2019 14:40:09 -0700
Message-Id: <1555105210-22996-1-git-send-email-greearb@candelatech.com>
X-Mailer: git-send-email 2.7.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

This can be helpful for calculating roaming time and other
higher precision stats.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 nl80211.h | 2 ++
 station.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/nl80211.h b/nl80211.h
index e1ea2cb..ebaae12 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -3139,6 +3139,7 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_TX_DURATION: aggregate PPDU duration for all frames
  *	sent to the station (u64, usec)
  * @NL80211_STA_INFO_AIRTIME_WEIGHT: current airtime weight for station (u16)
+ * @NL80211_STA_INFO_AUTH_AT_MS: Timestamp of last assoc -> auth transition, in ms
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -3184,6 +3185,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_CONNECTED_TO_GATE,
 	NL80211_STA_INFO_TX_DURATION,
 	NL80211_STA_INFO_AIRTIME_WEIGHT,
+	NL80211_STA_INFO_AUTH_AT_MS,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/station.c b/station.c
index 25cbbc3..3b0c5f1 100644
--- a/station.c
+++ b/station.c
@@ -557,6 +557,9 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 	if (sinfo[NL80211_STA_INFO_CONNECTED_TIME])
 		printf("\n\tconnected time:\t%u seconds",
 			nla_get_u32(sinfo[NL80211_STA_INFO_CONNECTED_TIME]));
+	if (sinfo[NL80211_STA_INFO_AUTH_AT_MS])
+		printf("\n\tauthenticated at:\t%llu ms",
+			 (unsigned long long)nla_get_u64(sinfo[NL80211_STA_INFO_AUTH_AT_MS]));
 
 	printf("\n");
 	return NL_SKIP;
-- 
2.7.5

