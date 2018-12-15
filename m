Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE898C43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A758F206A2
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbeLOJZl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:25:41 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42416 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728731AbeLOJZl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:25:41 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5rP-0002oc-NQ; Sat, 15 Dec 2018 11:03:48 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date:   Sat, 15 Dec 2018 11:03:24 +0200
Message-Id: <20181215090325.31604-24-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181215090325.31604-1-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 23/24] mac80211: ftm responder: remove pointless defensive coding
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The pointer and corresponding length is always set in pairs
in cfg80211, so no need to have this strange defensive check
that also confuses static checkers. Clean it up.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index cf8f946ae724..567c63ff830f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -800,8 +800,8 @@ static int ieee80211_set_ftm_responder_params(
 	u8 *pos;
 	int len;
 
-	if ((!lci || !lci_len) && (!civicloc || !civicloc_len))
-		return 1;
+	if (!lci_len && !civicloc_len)
+		return 0;
 
 	bss_conf = &sdata->vif.bss_conf;
 	old = bss_conf->ftmr_params;
-- 
2.19.2

