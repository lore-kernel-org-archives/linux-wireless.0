Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3CD5C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 23:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 982BD2175B
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 23:11:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="RQVna14Y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 982BD2175B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbeKOJRG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 04:17:06 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44596 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbeKOJRG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 04:17:06 -0500
Received: by mail-pg1-f193.google.com with SMTP id w3-v6so8044988pgs.11
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2018 15:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3ihS5G2vTlbdR1RKnOtmgQ0nJ7GYgg9o1beHk8C4t/w=;
        b=RQVna14YaGRwdyK5D8KtO33Gu/rMiqJjDwUA8zZWTf2EG7FoNud7Uo7/ZxNdxRjeRS
         PO2felWU0ZgQuXwYdllXdkgxrmeoccvPzBjd0isbUwz8/W6sCelj8d1BW0qW9S0IseLa
         PY6JD2djrcHxcJKE/i/TRXW75cuEwe6Am6kyI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3ihS5G2vTlbdR1RKnOtmgQ0nJ7GYgg9o1beHk8C4t/w=;
        b=VDnDfNtl5qbVkUHkLcp+ZBjrbaL1XBhjHN5FkdQmNOhvmcZz3pamUTfOf7AtPsPlc6
         927SdgdcMqCJ3o6nRaBGtfQZL5n0dQZOrnGyDe7Kan74ZCms11dkvAVaPs4jwtFtJNHV
         7D2y8i79ydaeky9tWlPMc/xYxYuuc/355GwG10BRl0Py0mptj9ARLIlBpdNY3YPIuuC9
         8cFy3l9N9+d6Wr9dPszumgc7VhITA/nTFE/mMnpl9I2hVP5oDDcwBjXI4FxwVh/UqCQm
         VoW58+G7UflGgCBFm0C4XxLPswZpluI3uDppnl7HhOxqunfaKmA3A25x+6chNdpIqn9L
         PODA==
X-Gm-Message-State: AGRZ1gJ8YktiDeIEWrhI2W3wYmcQ1qsGNrKeGfxuCk9WLTThhXPBBlg1
        Bc3RIZpg3wEVVW/c67Ru2ZgMhw==
X-Google-Smtp-Source: AJdET5fwXSqgr/mrtvkryjbB7dJB/Wm5E+6kB0lfCdqhasB+MNwS9cpRtnHB5TFqQe8Q/Pzik6TYYw==
X-Received: by 2002:a62:6a88:: with SMTP id f130-v6mr3903590pfc.98.1542237107661;
        Wed, 14 Nov 2018 15:11:47 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id 5-v6sm30416056pfg.141.2018.11.14.15.11.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Nov 2018 15:11:46 -0800 (PST)
From:   Brian Norris <briannorris@chromium.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] iw: add FEATURE support for scan randomization
Date:   Wed, 14 Nov 2018 15:11:29 -0800
Message-Id: <20181114231129.256298-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.19.1.930.g4563a0d9d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 info.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/info.c b/info.c
index d0577e32552e..f1a25daa63da 100644
--- a/info.c
+++ b/info.c
@@ -609,6 +609,12 @@ broken_combination:
 			printf("\tDevice supports configuring vdev MAC-addr on create.\n");
 		if (features & NL80211_FEATURE_TDLS_CHANNEL_SWITCH)
 			printf("\tDevice supports TDLS channel switching\n");
+		if (features & NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR)
+			printf("\tDevice supports randomizing MAC-addr in scans.\n");
+		if (features & NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR)
+			printf("\tDevice supports randomizing MAC-addr in sched scans.\n");
+		if (features & NL80211_FEATURE_ND_RANDOM_MAC_ADDR)
+			printf("\tDevice supports randomizing MAC-addr in net-detect scans.\n");
 	}
 
 	if (tb_msg[NL80211_ATTR_TDLS_SUPPORT])
-- 
2.19.1.930.g4563a0d9d0-goog

