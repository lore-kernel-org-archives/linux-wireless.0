Return-Path: <SRS0=kjT+=T5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1BFC28CC1
	for <linux-wireless@archiver.kernel.org>; Wed, 29 May 2019 12:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EEE521019
	for <linux-wireless@archiver.kernel.org>; Wed, 29 May 2019 12:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfE2M0A (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 29 May 2019 08:26:00 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54286 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726956AbfE2MZt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 May 2019 08:25:49 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hVxeN-0007wy-5b; Wed, 29 May 2019 15:25:47 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 04/10] cfg80211: util: fix bit count off by one
Date:   Wed, 29 May 2019 15:25:31 +0300
Message-Id: <20190529122537.8564-5-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190529122537.8564-1-luca@coelho.fi>
References: <20190529122537.8564-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

The bits of Rx MCS Map in VHT capability were enumerated
with index transform - index i -> (i + 1) bit => nss i. BUG!
while it should be -   index i -> (i + 1) bit => (i + 1) nss.

The bug was exposed in commit a53b2a0b1245 ("iwlwifi: mvm: implement VHT
extended NSS support in rs.c"), where iwlwifi started using the
function.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Fixes: b0aa75f0b1b2 ("ieee80211: add new VHT capability fields/parsing")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index cf63b635afc0..33dbf7ee9b97 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1998,7 +1998,7 @@ int ieee80211_get_vht_max_nss(struct ieee80211_vht_cap *cap,
 			continue;
 
 		if (supp >= mcs_encoding) {
-			max_vht_nss = i;
+			max_vht_nss = i + 1;
 			break;
 		}
 	}
-- 
2.20.1

