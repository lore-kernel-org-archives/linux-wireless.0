Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB8DC282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 11:54:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9C08218CD
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 11:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfAYLyO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 06:54:14 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:55868 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfAYLyO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 06:54:14 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gmzyK-0007S0-Ur; Fri, 25 Jan 2019 12:48:33 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH 12/12] mac80211_hwsim: Declare support for Multi-BSSID
Date:   Fri, 25 Jan 2019 12:48:25 +0100
Message-Id: <20190125114825.5872-12-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190125114825.5872-1-johannes@sipsolutions.net>
References: <20190125114825.5872-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Jouni Malinen <jouni@codeaurora.org>

This can be used to test cfg80211 support for Multi-BSSID scan result
parsing.

Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 3a4b8786f7ea..ee368b0e2a19 100644
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
2.17.2

