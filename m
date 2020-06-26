Return-Path: <SRS0=B3tD=AH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0426C433DF
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jun 2020 09:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF87821582
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jun 2020 09:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgFZJtp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Jun 2020 05:49:45 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:38322 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726699AbgFZJto (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jun 2020 05:49:44 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jokzO-001EwP-G0; Fri, 26 Jun 2020 12:49:43 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 26 Jun 2020 12:49:39 +0300
Message-Id: <iwlwifi.20200626124931.871ba5b31eee.I97340172d92164ee92f3c803fe20a8a6e97714e1@changeid>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 1/2] nl80211: don't return err unconditionally in nl80211_start_ap()
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

When a memory leak was fixed, a return err was changed to goto err,
but, accidentally, the if (err) was removed, so now we always exit at
this point.

Fix it by adding if (err) back.

Fixes: 9951ebfcdf2b ("nl80211: fix potential leak in AP start")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 263ae395ad44..f31698fd4a7e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5016,7 +5016,8 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		err = nl80211_parse_he_obss_pd(
 					info->attrs[NL80211_ATTR_HE_OBSS_PD],
 					&params.he_obss_pd);
-		goto out;
+		if (err)
+			goto out;
 	}
 
 	if (info->attrs[NL80211_ATTR_HE_BSS_COLOR]) {
-- 
2.27.0

