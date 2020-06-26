Return-Path: <SRS0=B3tD=AH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63292C433E1
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jun 2020 09:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48DD721556
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jun 2020 09:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgFZJtq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Jun 2020 05:49:46 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:38328 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726873AbgFZJtq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jun 2020 05:49:46 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jokzP-001EwP-BS; Fri, 26 Jun 2020 12:49:44 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 26 Jun 2020 12:49:40 +0300
Message-Id: <iwlwifi.20200626124931.7ad2a3eb894f.I60905fb70bd20389a3b170db515a07275e31845e@changeid>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <iwlwifi.20200626124931.871ba5b31eee.I97340172d92164ee92f3c803fe20a8a6e97714e1@changeid>
References: <iwlwifi.20200626124931.871ba5b31eee.I97340172d92164ee92f3c803fe20a8a6e97714e1@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 2/2] nl80211: fix memory leak when parsing NL80211_ATTR_HE_BSS_COLOR
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

If there is an error when parsing the NL80211_ATTR_HE_BSS_COLOR
attribute, we return immediately without freeing param.acl.  Fit it by
using goto out instead of returning immediately.

Fixes: 5c5e52d1bb96 ("nl80211: add handling for BSS color")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f31698fd4a7e..0e07fb8585fb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5025,7 +5025,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 					info->attrs[NL80211_ATTR_HE_BSS_COLOR],
 					&params.he_bss_color);
 		if (err)
-			return err;
+			goto out;
 	}
 
 	nl80211_calculate_ap_params(&params);
-- 
2.27.0

