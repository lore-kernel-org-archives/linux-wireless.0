Return-Path: <SRS0=Y8Bh=OQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34FC2C64EB1
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 12:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E73D120892
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 12:11:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jj9olFCz";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DmgHHMtT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E73D120892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbeLGMLF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Dec 2018 07:11:05 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37462 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbeLGMLE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Dec 2018 07:11:04 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DD158609F3; Fri,  7 Dec 2018 12:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544184664;
        bh=vL5MXaDMEGv4Ul1ztJASbWsT0tbQ1eK2aM7oEoZiq9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jj9olFCzFQiXUiOYj/v/FUKgpqmMvATcxSUP1A378xC4xUoGKjtarvTHP2WKUi2jP
         HxFfHHZpmvcExG1PS9IBub0fueSCp4+/HN28KAKT9amJocPknKFVpN7O8JblGan9+w
         wo+PeWnmxJahXcsLqG1Wpey9La6wpOCQkkkEM1l4=
Received: from jouni.codeaurora.org (37-33-76-121.bb.dnainternet.fi [37.33.76.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jouni@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F158061314;
        Fri,  7 Dec 2018 12:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544184663;
        bh=vL5MXaDMEGv4Ul1ztJASbWsT0tbQ1eK2aM7oEoZiq9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmgHHMtTbWpe8bKdBghvKob/C7l6vXiAzfXUU3Aur9BHQLsNtL41/Zhf9ZA9eRNiB
         5bK19TRvP+fEhTF20YNYhv5pBUdBwCgiPGpLdBv6l3DTlJScATexI7rcI4rzCoUh/7
         VwUylEswedsdUXB5nT4csW+QxF0jtc5puaQTGm0s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F158061314
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=jouni@codeaurora.org
From:   Jouni Malinen <jouni@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH 5/5] mac80211_hwsim: Declare support for Multi-BSSID
Date:   Fri,  7 Dec 2018 14:10:50 +0200
Message-Id: <1544184650-14124-5-git-send-email-jouni@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1544184650-14124-1-git-send-email-jouni@codeaurora.org>
References: <1544184650-14124-1-git-send-email-jouni@codeaurora.org>
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

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0540834..d5024ad 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2766,6 +2766,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	ieee80211_hw_set(hw, TDLS_WIDER_BW);
 	if (rctbl)
 		ieee80211_hw_set(hw, SUPPORTS_RC_TABLE);
+	ieee80211_hw_set(hw, SUPPORTS_MULTI_BSSID);
 
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
 			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
-- 
2.7.4

