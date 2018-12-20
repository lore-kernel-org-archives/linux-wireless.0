Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B244CC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 23:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70A48218FE
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 23:14:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="U+j+0Izs";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="U+j+0Izs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390304AbeLTXOP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 18:14:15 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37734 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390296AbeLTXOP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 18:14:15 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B492C6090B; Thu, 20 Dec 2018 23:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545347654;
        bh=vjT7O+matsxPZs8gGlXl57DqETh8hnTH5ga45TPgQ4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+j+0IzszP3B3LHJQUvT7LCJZQGXm+AxJP02VsQv3SFkQ5b1a9bRhUQW7GXheE4mK
         YC9zIneZyuZOUwffUblMywX1Jfwq6Ak82cEHxsW3WwbROEXfcLO7qWN6UTNDOdICyA
         bUeAsZ93+iSAJalsdY18llMGDdhyI5dvryn4M7lg=
Received: from jouni.codeaurora.org (87-95-219-4.bb.dnainternet.fi [87.95.219.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jouni@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8392A60867;
        Thu, 20 Dec 2018 23:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545347654;
        bh=vjT7O+matsxPZs8gGlXl57DqETh8hnTH5ga45TPgQ4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+j+0IzszP3B3LHJQUvT7LCJZQGXm+AxJP02VsQv3SFkQ5b1a9bRhUQW7GXheE4mK
         YC9zIneZyuZOUwffUblMywX1Jfwq6Ak82cEHxsW3WwbROEXfcLO7qWN6UTNDOdICyA
         bUeAsZ93+iSAJalsdY18llMGDdhyI5dvryn4M7lg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8392A60867
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=jouni@codeaurora.org
From:   Jouni Malinen <jouni@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH v2 5/5] mac80211_hwsim: Declare support for Multi-BSSID
Date:   Fri, 21 Dec 2018 01:13:56 +0200
Message-Id: <1545347636-5076-5-git-send-email-jouni@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1545347636-5076-1-git-send-email-jouni@codeaurora.org>
References: <1545347636-5076-1-git-send-email-jouni@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This can be used to test cfg80211 support for Multi-BSSID scan result
parsing.

Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 1 +
 1 file changed, 1 insertion(+)

v2:
- no changes

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index e4db8e2..74096d4 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2794,6 +2794,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	ieee80211_hw_set(hw, TDLS_WIDER_BW);
 	if (rctbl)
 		ieee80211_hw_set(hw, SUPPORTS_RC_TABLE);
+	ieee80211_hw_set(hw, SUPPORTS_MULTI_BSSID);
 
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
 			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
-- 
2.7.4

