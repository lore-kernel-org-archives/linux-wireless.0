Return-Path: <SRS0=FCSK=W6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0180C3A5A2
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 11:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FD72217D7
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 11:39:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NPAoBzep"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfICLjk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 07:39:40 -0400
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:53120 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727005AbfICLjk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 07:39:40 -0400
Received: from mail-irv-17.broadcom.com (mail-irv-17.lvn.broadcom.net [10.75.242.48])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 6B8C730C088;
        Tue,  3 Sep 2019 04:39:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 rnd-relay.smtp.broadcom.com 6B8C730C088
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1567510772;
        bh=PTT8S3fL9phBPdDpjNLjbDmxbf72gtNPsiSkBwag/n0=;
        h=From:To:Cc:Subject:Date:From;
        b=NPAoBzep02YAmIM65Szj8gdQZ8xkrJkOe8C8w3d7qwDX1Lm5WqiAQAFcsza4ab+JQ
         MLOcMZD84dT2oW5z8O36gAS2MvBm77qa4X7j08e4SSYHqK+tjwLOEsS3/fDWEO+ha0
         Z2NcEsT+ve/rq985uHE/Xl+JR8r5oDPs7AXBiFfQ=
Received: from bld-bun-01.bun.broadcom.com (bld-bun-01.bun.broadcom.com [10.176.128.83])
        by mail-irv-17.broadcom.com (Postfix) with ESMTP id 0C1BD60C99;
        Tue,  3 Sep 2019 04:39:39 -0700 (PDT)
Received: by bld-bun-01.bun.broadcom.com (Postfix, from userid 25152)
        id D6B10B0271E; Tue,  3 Sep 2019 13:39:37 +0200 (CEST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH] cfg80211: fix boundary value in ieee80211_frequency_to_channel()
Date:   Tue,  3 Sep 2019 13:39:32 +0200
Message-Id: <1567510772-24263-1-git-send-email-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The boundary value used for the 6G band was incorrect as it would
result in invalid 6G channel number for certain frequencies.

Reported-by: Amar Singhal <asinghal@codeaurora.org>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 net/wireless/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index c999390..006f3ea 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -116,7 +116,7 @@ int ieee80211_frequency_to_channel(int freq)
 		return (freq - 2407) / 5;
 	else if (freq >= 4910 && freq <= 4980)
 		return (freq - 4000) / 5;
-	else if (freq < 5940)
+	else if (freq < 5945)
 		return (freq - 5000) / 5;
 	else if (freq <= 45000) /* DMG band lower limit */
 		/* see 802.11ax D4.1 27.3.22.2 */
-- 
1.9.1

