Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 327BCC4167B
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Dec 2020 12:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F224E2310E
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Dec 2020 12:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgLFMz4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 6 Dec 2020 07:55:56 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:34898 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727943AbgLFMzk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 6 Dec 2020 07:55:40 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kltYz-003AHZ-2C; Sun, 06 Dec 2020 14:54:53 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org
Date:   Sun,  6 Dec 2020 14:54:41 +0200
Message-Id: <iwlwifi.20201206145305.2ab3aad7d5fc.Iaca4ee6db651b7de17e4351f4be7973ff8600186@changeid>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206125450.564941-1-luca@coelho.fi>
References: <20201206125450.564941-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/11] mac80211: use struct assignment for he_obss_pd
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Use a struct assignment here, which is clearer than the
memcpy() and type-safe as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/cfg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1b3169c6a9a6..562f8a1c19ba 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1121,8 +1121,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	sdata->vif.bss_conf.enable_beacon = true;
 	sdata->vif.bss_conf.allow_p2p_go_ps = sdata->vif.p2p;
 	sdata->vif.bss_conf.twt_responder = params->twt_responder;
-	memcpy(&sdata->vif.bss_conf.he_obss_pd, &params->he_obss_pd,
-	       sizeof(struct ieee80211_he_obss_pd));
+	sdata->vif.bss_conf.he_obss_pd = params->he_obss_pd;
 	sdata->vif.bss_conf.he_bss_color = params->he_bss_color;
 	sdata->vif.bss_conf.s1g = params->chandef.chan->band ==
 				  NL80211_BAND_S1GHZ;
-- 
2.29.2

