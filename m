Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2A4C282C2
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 05:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 224B9218A1
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 05:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfBFF7x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 00:59:53 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55526 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726001AbfBFF7w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 00:59:52 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grGFR-00014d-Fi; Wed, 06 Feb 2019 07:59:50 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date:   Wed,  6 Feb 2019 07:59:41 +0200
Message-Id: <20190206055943.11757-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <96393f6a0a9d06776260368db9d2fd89c11cd33b.camel@coelho.fi>
References: <96393f6a0a9d06776260368db9d2fd89c11cd33b.camel@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v2 1/2] cfg80211: pmsr: fix MAC address setting
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

When we *don't* have a MAC address attribute, we shouldn't
try to use this - this was intended to copy the local MAC
address instead, so fix it.

Fixes: 9bb7e0f24e7e ("cfg80211: add peer measurement with FTM initiator API")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/pmsr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index de9286703280..f2e388e329fd 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -256,8 +256,7 @@ int nl80211_pmsr_start(struct sk_buff *skb, struct genl_info *info)
 		if (err)
 			goto out_err;
 	} else {
-		memcpy(req->mac_addr, nla_data(info->attrs[NL80211_ATTR_MAC]),
-		       ETH_ALEN);
+		memcpy(req->mac_addr, wdev_address(wdev), ETH_ALEN);
 		memset(req->mac_addr_mask, 0xff, ETH_ALEN);
 	}
 
-- 
2.20.1

