Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C805C64EBC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 09:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1BA4213A2
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 09:34:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D1BA4213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbeJDQ0y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 12:26:54 -0400
Received: from mga17.intel.com ([192.55.52.151]:47903 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727046AbeJDQ0y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 12:26:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2018 02:34:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,338,1534834800"; 
   d="scan'208";a="262780937"
Received: from localhost.jer.intel.com ([10.12.85.45])
  by orsmga005.jf.intel.com with ESMTP; 04 Oct 2018 02:34:28 -0700
From:   Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] iw: fix the beacon average signal parsing
Date:   Thu,  4 Oct 2018 12:34:20 +0300
Message-Id: <1538645660-29849-1-git-send-email-emmanuel.grumbach@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

NL80211_STA_INFO_BEACON_SIGNAL_AVG is parsed as a u8, but
it should be casted to a int8_t before being printed.

Change-Id: Ieb6fab3b803d8ea82819a450f07cc4b537d8de8b
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 station.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/station.c b/station.c
index 4885dc0..f4e0093 100644
--- a/station.c
+++ b/station.c
@@ -317,7 +317,7 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 
 	if (sinfo[NL80211_STA_INFO_BEACON_SIGNAL_AVG])
 		printf("\n\tbeacon signal avg:\t%d dBm",
-		       nla_get_u8(sinfo[NL80211_STA_INFO_BEACON_SIGNAL_AVG]));
+		       (int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_BEACON_SIGNAL_AVG]));
 	if (sinfo[NL80211_STA_INFO_T_OFFSET])
 		printf("\n\tToffset:\t%llu us",
 		       (unsigned long long)nla_get_u64(sinfo[NL80211_STA_INFO_T_OFFSET]));
-- 
2.7.4

