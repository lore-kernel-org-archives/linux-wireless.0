Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F78C43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5910206A2
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbeLOJPh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:15:37 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42362 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726030AbeLOJPh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:15:37 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5rO-0002oc-9F; Sat, 15 Dec 2018 11:03:46 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date:   Sat, 15 Dec 2018 11:03:22 +0200
Message-Id: <20181215090325.31604-22-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181215090325.31604-1-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 21/24] nl80211: fix memory leak if validate_pae_over_nl80211() fails
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

If validate_pae_over_nl80211() were to fail in nl80211_crypto_settings(),
we might leak the 'connkeys' allocation. Fix this.

Fixes: 64bf3d4bc2b0 ("nl80211: Add CONTROL_PORT_OVER_NL80211 attribute")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 669cbdb6f849..449a379e054a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9097,8 +9097,10 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_CONTROL_PORT_OVER_NL80211]) {
 		int r = validate_pae_over_nl80211(rdev, info);
 
-		if (r < 0)
+		if (r < 0) {
+			kzfree(connkeys);
 			return r;
+		}
 
 		ibss.control_port_over_nl80211 = true;
 	}
-- 
2.19.2

