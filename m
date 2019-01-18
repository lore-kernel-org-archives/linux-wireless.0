Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A8A0C1B0F7
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 21:48:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30B082054F
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 21:48:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dFkLvbjj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbfARVsD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 16:48:03 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37503 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729621AbfARVsC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 16:48:02 -0500
Received: by mail-pl1-f193.google.com with SMTP id b5so6909203plr.4
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jan 2019 13:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Wl+tZHkelqSW/Z/0kZC9iVm+SdmRlr7QDRkFsAKKw3U=;
        b=dFkLvbjj2sDAbUWB+ECp5x2eBy2/907p+J/SWFnnx+qbC0wqThDZrkbBhWsGkGGQfx
         h0ePgZDbj8neP27df3Zjd9zLZKkDi/otYs4YOacu1OyhlqMiWk4hbUoegweA9Eaeb+0A
         DQpyVHkrCMAh6pe37Pw8MeNqICUcdrGOX6cfQxsv3pfp2Ak/5L796wjqu5tEKcEBeH06
         5IaCVOjNygRQM2S0G+cLQpyP8cKnydEZ/SITUyGJoHjX+sXyw+iPnQZHWpm54onvd4dI
         gBHrhtyzNHvMPFEqlBC8ukjczxrVN/Z9EWdugI3LvcRU+usiEKDmDoMBnC3paLkdMHvp
         UXCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Wl+tZHkelqSW/Z/0kZC9iVm+SdmRlr7QDRkFsAKKw3U=;
        b=lomOTo8WHPPXs9numyuZMH569+kPYwHJJPrsswmXxcYu492k4PyUyFqSwhOnMoWnLL
         GXFZtxHkEZWkAyJr4XlBTR+nhs3Bjlx9vT2MJcgyHB7+qB+nxSdoQWSBWFDhHXo4OxaK
         mU78haSteSi9E7vZTkk6nuREYe7JH879jsc3SLrZR+oL0YkOD7DH4e17ftfkyeOlPKJh
         5KZjaYmzZpORTiTV0xYocuNZu4+T2XjjYUAX5yk2iXnlSwjYHlWnwt80ikKuP5Atkvzu
         VMEMoMD5XSLQ16Ya0JUlxwLvECiqLWHs6RStT1zVKnizhmIAZdx84jrje6XQEAQYomB0
         SmEw==
X-Gm-Message-State: AJcUukdXFIW98BzqyXoqrYhq0m0W/RQWkjFsdkeCYtQdiH7GkQvnp53z
        bhk9YKl7dET6sjX4WvInJ8ZJcfS+u8c=
X-Google-Smtp-Source: ALg8bN4e4T83q4KcTjdZUcROaIYTkCbFjwB8a4pqxfP/XOwO8KKpgvMMgTWh8iHQxYKN30zJWv14yg==
X-Received: by 2002:a17:902:47aa:: with SMTP id r39mr20507955pld.219.1547848081514;
        Fri, 18 Jan 2019 13:48:01 -0800 (PST)
Received: from localhost.localdomain ([183.83.169.42])
        by smtp.gmail.com with ESMTPSA id g136sm7164751pfb.154.2019.01.18.13.47.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jan 2019 13:48:00 -0800 (PST)
From:   chaitanya.mgit@gmail.com
To:     linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc:     Chaitanya Tata <chaitanya.tata@bluwirelesstechnology.com>,
        Chaitanya Tata <Chaitanya.Tata@bluwireless.co.uk>
Subject: [PATCH] cfg80211: extend range deviation for DMG
Date:   Sat, 19 Jan 2019 03:17:47 +0530
Message-Id: <20190118214747.16406-1-chaitanya.mgit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chaitanya Tata <chaitanya.tata@bluwirelesstechnology.com>

Recently, DMG frequency bands have been extended till 71GHz, so extend
the range check till 20GHz (45-71GHZ), else some channels will be marked
as disabled.

Signed-off-by: Chaitanya Tata <Chaitanya.Tata@bluwireless.co.uk>
---
 net/wireless/reg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ecfb1a06dbb2..cce4c16eaaa0 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1255,7 +1255,7 @@ static bool is_valid_rd(const struct ieee80211_regdomain *rd)
  * definitions (the "2.4 GHz band", the "5 GHz band" and the "60GHz band"),
  * however it is safe for now to assume that a frequency rule should not be
  * part of a frequency's band if the start freq or end freq are off by more
- * than 2 GHz for the 2.4 and 5 GHz bands, and by more than 10 GHz for the
+ * than 2 GHz for the 2.4 and 5 GHz bands, and by more than 20 GHz for the
  * 60 GHz band.
  * This resolution can be lowered and should be considered as we add
  * regulatory rule support for other "bands".
@@ -1270,7 +1270,7 @@ static bool freq_in_rule_band(const struct ieee80211_freq_range *freq_range,
 	 * with the Channel starting frequency above 45 GHz.
 	 */
 	u32 limit = freq_khz > 45 * ONE_GHZ_IN_KHZ ?
-			10 * ONE_GHZ_IN_KHZ : 2 * ONE_GHZ_IN_KHZ;
+			20 * ONE_GHZ_IN_KHZ : 2 * ONE_GHZ_IN_KHZ;
 	if (abs(freq_khz - freq_range->start_freq_khz) <= limit)
 		return true;
 	if (abs(freq_khz - freq_range->end_freq_khz) <= limit)
-- 
2.17.1

