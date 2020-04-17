Return-Path: <SRS0=s1dN=6B=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9ADC38A29
	for <linux-wireless@archiver.kernel.org>; Fri, 17 Apr 2020 10:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 301E9221EA
	for <linux-wireless@archiver.kernel.org>; Fri, 17 Apr 2020 10:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgDQKV7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 17 Apr 2020 06:21:59 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56616 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729065AbgDQKV6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Apr 2020 06:21:58 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jPO8C-000Kba-4c; Fri, 17 Apr 2020 13:21:56 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 17 Apr 2020 13:21:41 +0300
Message-Id: <iwlwifi.20200417131727.891bb9741eca.Ia66448f7e00be9e4c9ea7147b90d4fcd5f1d3845@changeid>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200417102142.2173014-1-luca@coelho.fi>
References: <20200417102142.2173014-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/10] iwlwifi: mvm: add DCM flag to rate pretty-print
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

It's useful to know if DCM was enabled, add this flag
to the rate pretty-printer.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index c1aba2bf73cf..1b6cbcf57d5f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -3740,11 +3740,12 @@ int rs_pretty_print_rate(char *buf, int bufsz, const u32 rate)
 	}
 
 	return scnprintf(buf, bufsz,
-			 "0x%x: %s | ANT: %s BW: %s MCS: %d NSS: %d %s%s%s%s",
+			 "0x%x: %s | ANT: %s BW: %s MCS: %d NSS: %d %s%s%s%s%s",
 			 rate, type, rs_pretty_ant(ant), bw, mcs, nss,
 			 (rate & RATE_MCS_SGI_MSK) ? "SGI " : "NGI ",
 			 (rate & RATE_MCS_STBC_MSK) ? "STBC " : "",
 			 (rate & RATE_MCS_LDPC_MSK) ? "LDPC " : "",
+			 (rate & RATE_HE_DUAL_CARRIER_MODE_MSK) ? "DCM " : "",
 			 (rate & RATE_MCS_BF_MSK) ? "BF " : "");
 }
 
-- 
2.25.1

