Return-Path: <SRS0=l8aR=WZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96147C3A59F
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Aug 2019 22:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CB192166E
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Aug 2019 22:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfH2WWA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Aug 2019 18:22:00 -0400
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:53947 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727763AbfH2WWA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Aug 2019 18:22:00 -0400
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 29 Aug 2019 15:22:00 -0700
Received: from asinghal-linux.qualcomm.com ([10.234.220.60])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 29 Aug 2019 15:22:00 -0700
Received: by asinghal-linux.qualcomm.com (Postfix, from userid 73644)
        id 0D30136AF; Thu, 29 Aug 2019 15:22:00 -0700 (PDT)
From:   Amar Singhal <asinghal@codeaurora.org>
To:     johannes@sipsolutions.net, jouni@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, jjohnson@codeaurora.org,
        rmanohar@codeaurora.org, Amar Singhal <asinghal@codeaurora.org>
Subject: [PATCH] cfg80211: Convert 6 GHz channel frequency to channel number
Date:   Thu, 29 Aug 2019 15:21:30 -0700
Message-Id: <1567117290-19295-1-git-send-email-asinghal@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Enhance function ieee80211_frequency_to_channel by adding 6 GHz
channels.

Signed-off-by: Amar Singhal <asinghal@codeaurora.org>
---
 net/wireless/util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index cf63b63..9aba8d54 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -111,8 +111,10 @@ int ieee80211_frequency_to_channel(int freq)
 		return (freq - 2407) / 5;
 	else if (freq >= 4910 && freq <= 4980)
 		return (freq - 4000) / 5;
-	else if (freq <= 45000) /* DMG band lower limit */
+	else if (freq > 5000 && freq <= 5920)
 		return (freq - 5000) / 5;
+	else if (freq >= 5945 && freq <= 7205)
+		  return (freq - 5940) / 5;
 	else if (freq >= 58320 && freq <= 70200)
 		return (freq - 56160) / 2160;
 	else
--
1.9.1

