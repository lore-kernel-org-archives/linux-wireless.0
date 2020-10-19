Return-Path: <SRS0=Yehs=D2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51961C433DF
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Oct 2020 10:20:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA80822276
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Oct 2020 10:20:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Uq9CyTIn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgJSKUz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Oct 2020 06:20:55 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:46488 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgJSKUz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Oct 2020 06:20:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603102854; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=pO0FDD57J3zRK84jwOrYtrWoQ4FhQcuNNWfyu+hfw6A=; b=Uq9CyTInRcezxPTNEtKIvBCDSTWGo7k6n7Ceh2/MfRDd4EM9PPEaKxc72oMqmnTWpotHd+0O
 0BqnNfp4fRlmRfUwM4kUUaAImjGJjZ0+MAk6TKBX8Z+FSRfmxzu1JXxI5dkwIhXeCGv4TBAW
 Xd//l1A7e4rLa+b1LLV9B/GXfJM=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5f8d6879856d9308b5931717 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 19 Oct 2020 10:20:41
 GMT
Sender: kathirve=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 19E03C433FF; Mon, 19 Oct 2020 10:20:41 +0000 (UTC)
Received: from akalaise-linux.qualcomm.com (blr-c-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kathirve)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6D47CC433F1;
        Mon, 19 Oct 2020 10:20:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6D47CC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kathirve@codeaurora.org
From:   Karthikeyan Kathirvel <kathirve@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Karthikeyan Kathirvel <kathirve@codeaurora.org>
Subject: [PATCH] mac80211: choosing first channel from the list
Date:   Mon, 19 Oct 2020 15:50:30 +0530
Message-Id: <1603102830-28935-1-git-send-email-kathirve@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Though the first channel from sband channel list is invalid
or disabled still mac80211 is choosing this disabled channel
as a default channel for monitor interface. This will end-up
in choosing wrong channel.

Fixed by assigning the first available valid or enabled channel
to the respective radios.

Signed-off-by: Karthikeyan Kathirvel <kathirve@codeaurora.org>
---

v2:
	rebased

 net/mac80211/main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b4a2efe..a4aefd6 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -982,8 +982,15 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 			continue;
 
 		if (!dflt_chandef.chan) {
+			/*
+			 * Assigning the first enabled channel to dflt_chandef from the
+			 * list of channels available specific to country
+			 */
+			for (i = 0; i < sband->n_channels; i++)
+				if (!(sband->channels[i].flags & IEEE80211_CHAN_DISABLED))
+					break;
 			cfg80211_chandef_create(&dflt_chandef,
-						&sband->channels[0],
+						&sband->channels[i == sband->n_channels ? 0 : i],
 						NL80211_CHAN_NO_HT);
 			/* init channel we're on */
 			if (!local->use_chanctx && !local->_oper_chandef.chan) {
-- 
2.7.4

