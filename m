Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E31CC282D9
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18CCB218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbfAaUW5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:22:57 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53686 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727435AbfAaUW5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 15:22:57 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gpIqu-0004pL-9C; Thu, 31 Jan 2019 22:22:24 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 31 Jan 2019 22:21:57 +0200
Message-Id: <20190131202206.15903-13-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190131202206.15903-1-luca@coelho.fi>
References: <20190131202206.15903-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/21] iwlwifi: mvm: fix RSS config command
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

The hash mask is a bitmap, so we should use BIT() on
the enum values.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Fixes: 43413a975d06 ("iwlwifi: mvm: support rss queues configuration command")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index d8ae9561a9b0..134dab2d774a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -105,12 +105,12 @@ static int iwl_send_rss_cfg_cmd(struct iwl_mvm *mvm)
 	int i;
 	struct iwl_rss_config_cmd cmd = {
 		.flags = cpu_to_le32(IWL_RSS_ENABLE),
-		.hash_mask = IWL_RSS_HASH_TYPE_IPV4_TCP |
-			     IWL_RSS_HASH_TYPE_IPV4_UDP |
-			     IWL_RSS_HASH_TYPE_IPV4_PAYLOAD |
-			     IWL_RSS_HASH_TYPE_IPV6_TCP |
-			     IWL_RSS_HASH_TYPE_IPV6_UDP |
-			     IWL_RSS_HASH_TYPE_IPV6_PAYLOAD,
+		.hash_mask = BIT(IWL_RSS_HASH_TYPE_IPV4_TCP) |
+			     BIT(IWL_RSS_HASH_TYPE_IPV4_UDP) |
+			     BIT(IWL_RSS_HASH_TYPE_IPV4_PAYLOAD) |
+			     BIT(IWL_RSS_HASH_TYPE_IPV6_TCP) |
+			     BIT(IWL_RSS_HASH_TYPE_IPV6_UDP) |
+			     BIT(IWL_RSS_HASH_TYPE_IPV6_PAYLOAD),
 	};
 
 	if (mvm->trans->num_rx_queues == 1)
-- 
2.20.1

