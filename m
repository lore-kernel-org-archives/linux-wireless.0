Return-Path: <SRS0=Fjak=U3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA4CC4321A
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Jun 2019 09:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7DF6208CB
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Jun 2019 09:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfF1JUW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:20:22 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54684 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726524AbfF1JUW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jun 2019 05:20:22 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hgn3L-0001ny-Su; Fri, 28 Jun 2019 12:20:20 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 01/20] iwlwifi: lib: Use struct_size() helper
Date:   Fri, 28 Jun 2019 12:19:49 +0300
Message-Id: <20190628092008.11049-2-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628092008.11049-1-luca@coelho.fi>
References: <20190628092008.11049-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes, in particular in the
context in which this code is being used.

So, change the following form:

sizeof(*pattern_cmd) +
               wowlan->n_patterns * sizeof(struct iwlagn_wowlan_pattern)

 to :

struct_size(pattern_cmd, patterns, wowlan->n_patterns)

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
index b2f172d4f78a..cae9cd438697 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
@@ -1022,8 +1022,7 @@ int iwlagn_send_patterns(struct iwl_priv *priv,
 	if (!wowlan->n_patterns)
 		return 0;
 
-	cmd.len[0] = sizeof(*pattern_cmd) +
-		wowlan->n_patterns * sizeof(struct iwlagn_wowlan_pattern);
+	cmd.len[0] = struct_size(pattern_cmd, patterns, wowlan->n_patterns);
 
 	pattern_cmd = kmalloc(cmd.len[0], GFP_KERNEL);
 	if (!pattern_cmd)
-- 
2.20.1

