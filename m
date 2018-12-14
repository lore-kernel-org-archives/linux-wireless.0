Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F92C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A75B32080F
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730792AbeLNU3x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 15:29:53 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41930 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730713AbeLNU3x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 15:29:53 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=localhost.localdomain)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gXu5n-0002RG-9C; Fri, 14 Dec 2018 22:29:51 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 14 Dec 2018 22:29:28 +0200
Message-Id: <20181214202945.32375-2-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181214202945.32375-1-luca@coelho.fi>
References: <20181214202945.32375-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 01/18] iwlwifi: pcie: use iwl_tx_cmd_gen2 and not iwl_tx_cmd
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

When building AMSDU for gen2, code uses iwl_tx_cmd. The only
updated field is len, which is in the same location, so it
is not a bug. However, it is a bit confusing and error prone,
so change it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 16e8c3eb09b8..156ca1b1f621 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -238,7 +238,7 @@ static int iwl_pcie_gen2_build_amsdu(struct iwl_trans *trans,
 {
 #ifdef CONFIG_INET
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_tx_cmd *tx_cmd = (void *)dev_cmd->payload;
+	struct iwl_tx_cmd_gen2 *tx_cmd = (void *)dev_cmd->payload;
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	unsigned int snap_ip_tcp_hdrlen, ip_hdrlen, total_len, hdr_room;
 	unsigned int mss = skb_shinfo(skb)->gso_size;
-- 
2.19.2

