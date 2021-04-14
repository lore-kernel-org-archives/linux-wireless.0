Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB69C433ED
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Apr 2021 11:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B424A61008
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Apr 2021 11:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350678AbhDNLey (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Apr 2021 07:34:54 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:14626 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350677AbhDNLex (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Apr 2021 07:34:53 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618400072; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=w32R03vxsYBHaH8nDRiohY6eWnAL9bUdNfYcKWw7Lto=; b=O/PniIs0Um6WWjmLP3hiNmBkZJRVZQSX3GdL0NdtBXzUTiQaVCiFyHgf1N2Y9NGKcMwfPnBq
 oVMIa9kMCCe2+sM4xYTpsaLfL1copG3XFahrenjMvx31NUNZY2CjrBvYw4KhzvuwpefXjjU0
 KBVGpgrXM9piJFqi4OG/S+4BpKI=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 6076d335c06dd10a2d722b2f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 14 Apr 2021 11:34:13
 GMT
Sender: akalaise=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BF3EEC433ED; Wed, 14 Apr 2021 11:34:12 +0000 (UTC)
Received: from akalaise-linux.qualcomm.com (blr-c-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: akalaise)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 23B31C433CA;
        Wed, 14 Apr 2021 11:34:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 23B31C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=akalaise@codeaurora.org
From:   Abinaya Kalaiselvan <akalaise@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Abinaya Kalaiselvan <akalaise@codeaurora.org>
Subject: [PATCH] mac80211: fix NULL ptr dereference during mesh peer connection for non HE devices
Date:   Wed, 14 Apr 2021 17:03:32 +0530
Message-Id: <1618400012-30541-1-git-send-email-akalaise@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"sband->iftype_data" is not assigned with any value for non HE supported
devices, which causes NULL pointer access during mesh peer connection
in those devices. Fix this by accessing the pointer after HE
capabilities condition check.

Fixes: 7f7aa94bcaf0 (mac80211: reduce peer HE MCS/NSS to own capabilities)
Signed-off-by: Abinaya Kalaiselvan <akalaise@codeaurora.org>
---
 net/mac80211/he.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/he.c b/net/mac80211/he.c
index 0c0b970..543c2cb 100644
--- a/net/mac80211/he.c
+++ b/net/mac80211/he.c
@@ -111,7 +111,7 @@ ieee80211_he_cap_ie_to_sta_he_cap(struct ieee80211_sub_if_data *sdata,
 				  struct sta_info *sta)
 {
 	struct ieee80211_sta_he_cap *he_cap = &sta->sta.he_cap;
-	struct ieee80211_sta_he_cap own_he_cap = sband->iftype_data->he_cap;
+	struct ieee80211_sta_he_cap own_he_cap;
 	struct ieee80211_he_cap_elem *he_cap_ie_elem = (void *)he_cap_ie;
 	u8 he_ppe_size;
 	u8 mcs_nss_size;
@@ -123,6 +123,8 @@ ieee80211_he_cap_ie_to_sta_he_cap(struct ieee80211_sub_if_data *sdata,
 	if (!he_cap_ie || !ieee80211_get_he_sta_cap(sband))
 		return;
 
+	 own_he_cap = sband->iftype_data->he_cap;
+
 	/* Make sure size is OK */
 	mcs_nss_size = ieee80211_he_mcs_nss_size(he_cap_ie_elem);
 	he_ppe_size =
-- 
2.7.4

