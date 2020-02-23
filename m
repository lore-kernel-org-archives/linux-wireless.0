Return-Path: <SRS0=gp58=4L=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F81C35669
	for <linux-wireless@archiver.kernel.org>; Sun, 23 Feb 2020 02:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F211D20659
	for <linux-wireless@archiver.kernel.org>; Sun, 23 Feb 2020 02:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582425298;
	bh=P0RKFrgjP6JKGRMGk8GnsyzqGRfwiWUCR3jPyp8NyeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=XVscjhsiEn2+Uxr9ioq5TxkDF7qjOIDrmUiooYzvYYXr3zLcoZak9DcIiWcCt1QPJ
	 G8WFf7eGRRh4YKYHYgJYcVqEh+0G10I2b5rGcwgZZgVbi028KZ+RM0DDTOhF2mNrqF
	 E5YzRK3AsdMNnWFDJsKF35JsXKIldbXmpiGrquHo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbgBWCeu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 22 Feb 2020 21:34:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728116AbgBWCWW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Feb 2020 21:22:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5C4D2067D;
        Sun, 23 Feb 2020 02:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424541;
        bh=P0RKFrgjP6JKGRMGk8GnsyzqGRfwiWUCR3jPyp8NyeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wA1HGGYS6gLN+PiQp+0UId3orBG5IYpAmoi2TheGYJAq76ARaKnSPIr+I7vyi3NSJ
         zadaPy8K+FVq3kZYHlM5SFMtLslh2E5bwEHrR+vHoeaZEq+BFIu96Cy3YhLWirgrUn
         TFmmPSfsBdlCFktFx/UOQ67e2n3ciChFaIUv58Gs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 51/58] cfg80211: add missing policy for NL80211_ATTR_STATUS_CODE
Date:   Sat, 22 Feb 2020 21:21:12 -0500
Message-Id: <20200223022119.707-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022119.707-1-sashal@kernel.org>
References: <20200223022119.707-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[ Upstream commit ea75080110a4c1fa011b0a73cb8f42227143ee3e ]

The nl80211_policy is missing for NL80211_ATTR_STATUS_CODE attribute.
As a result, for strictly validated commands, it's assumed to not be
supported.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Link: https://lore.kernel.org/r/20200213131608.10541-2-sergey.matyukevich.os@quantenna.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1e97ac5435b23..118a98de516cd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -437,6 +437,7 @@ const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CONTROL_PORT_OVER_NL80211] = { .type = NLA_FLAG },
 	[NL80211_ATTR_PRIVACY] = { .type = NLA_FLAG },
+	[NL80211_ATTR_STATUS_CODE] = { .type = NLA_U16 },
 	[NL80211_ATTR_CIPHER_SUITE_GROUP] = { .type = NLA_U32 },
 	[NL80211_ATTR_WPA_VERSIONS] = { .type = NLA_U32 },
 	[NL80211_ATTR_PID] = { .type = NLA_U32 },
-- 
2.20.1

