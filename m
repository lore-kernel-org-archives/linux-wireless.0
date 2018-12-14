Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB17AC43387
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DB712080F
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730915AbeLNUaV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 15:30:21 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42050 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730713AbeLNUaU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 15:30:20 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=localhost.localdomain)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gXu5z-0002RG-G6; Fri, 14 Dec 2018 22:30:03 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 14 Dec 2018 22:29:43 +0200
Message-Id: <20181214202945.32375-17-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181214202945.32375-1-luca@coelho.fi>
References: <20181214202945.32375-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 16/18] iwlwifi: mvm: d3: use struct_size() in kzalloc()
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct foo {
	int stuff;
        void *entry[];
};

instance = kzalloc(sizeof(struct foo) + sizeof(void *) * count, GFP_KERNEL);

Instead of leaving these open-coded and prone to type mistakes, we can
now use the new struct_size() helper:

instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL);

This issue was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 9b018d00f78f..01b5338201d6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1811,8 +1811,7 @@ static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
 		n_matches = 0;
 	}
 
-	net_detect = kzalloc(sizeof(*net_detect) +
-			     (n_matches * sizeof(net_detect->matches[0])),
+	net_detect = kzalloc(struct_size(net_detect, matches, n_matches),
 			     GFP_KERNEL);
 	if (!net_detect || !n_matches)
 		goto out_report_nd;
@@ -1827,8 +1826,7 @@ static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
 		for (j = 0; j < SCAN_OFFLOAD_MATCHING_CHANNELS_LEN; j++)
 			n_channels += hweight8(fw_match->matching_channels[j]);
 
-		match = kzalloc(sizeof(*match) +
-				(n_channels * sizeof(*match->channels)),
+		match = kzalloc(struct_size(match, channels, n_channels),
 				GFP_KERNEL);
 		if (!match)
 			goto out_report_nd;
-- 
2.19.2

