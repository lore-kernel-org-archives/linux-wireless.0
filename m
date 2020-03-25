Return-Path: <SRS0=rxFU=5K=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C30C18E5B
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Mar 2020 08:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B86422070A
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Mar 2020 08:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgCYIJ3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 25 Mar 2020 04:09:29 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:41434 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgCYIJ3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Mar 2020 04:09:29 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jH16M-007ePm-Vb; Wed, 25 Mar 2020 09:09:27 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     john@phrozen.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] ieee80211: fix HE SPR size calculation
Date:   Wed, 25 Mar 2020 09:09:19 +0100
Message-Id: <20200325090918.dfe483b49e06.Ia53622f23b2610a2ae6ea39a199866196fe946c1@changeid>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The he_sr_control field is just a u8, so le32_to_cpu()
shouldn't be applied to it; this was evidently copied
from ieee80211_he_oper_size(). Fix it.

Fixes: ef11a931bd1c ("mac80211: HE: add Spatial Reuse element parsing support")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 7d3f2ced92d1..30ef0f06dd5b 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2109,7 +2109,7 @@ ieee80211_he_spr_size(const u8 *he_spr_ie)
 		return 0;
 
 	/* Calc required length */
-	he_spr_params = le32_to_cpu(he_spr->he_sr_control);
+	he_spr_params = he_spr->he_sr_control;
 	if (he_spr_params & IEEE80211_HE_SPR_NON_SRG_OFFSET_PRESENT)
 		spr_len++;
 	if (he_spr_params & IEEE80211_HE_SPR_SRG_INFORMATION_PRESENT)
-- 
2.25.1

