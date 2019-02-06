Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4672DC169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 177462080D
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbfBFLRb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 06:17:31 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55686 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727580AbfBFLRa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 06:17:30 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grLCq-0001ED-I2; Wed, 06 Feb 2019 13:17:28 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Aviya Erenfeld <aviya.erenfeld@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  6 Feb 2019 13:17:08 +0200
Message-Id: <20190206111721.29283-3-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206111721.29283-1-luca@coelho.fi>
References: <20190206111721.29283-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/15] nl80211: Fix FTM per burst maximum value
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Aviya Erenfeld <aviya.erenfeld@intel.com>

Fix FTM per burst maximum value from 15 to 31
(The maximal bits that represents that number in the frame
is 5 hence a maximal value of 31)

Signed-off-by: Aviya Erenfeld <aviya.erenfeld@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a3cc039b9f55..e36437abc45a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -250,7 +250,7 @@ nl80211_pmsr_ftm_req_attr_policy[NL80211_PMSR_FTM_REQ_ATTR_MAX + 1] = {
 	[NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION] =
 		NLA_POLICY_MAX(NLA_U8, 15),
 	[NL80211_PMSR_FTM_REQ_ATTR_FTMS_PER_BURST] =
-		NLA_POLICY_MAX(NLA_U8, 15),
+		NLA_POLICY_MAX(NLA_U8, 31),
 	[NL80211_PMSR_FTM_REQ_ATTR_NUM_FTMR_RETRIES] = { .type = NLA_U8 },
 	[NL80211_PMSR_FTM_REQ_ATTR_REQUEST_LCI] = { .type = NLA_FLAG },
 	[NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC] = { .type = NLA_FLAG },
-- 
2.20.1

