Return-Path: <SRS0=Jrqb=ZC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09AFC17440
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Nov 2019 03:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D47021924
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Nov 2019 03:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573355448;
	bh=YUdWJefQqbJCfgysInUFfykhGjVrzLCnQMM6zBJYnkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mJVSGPn+SU0pnzFe6rgfeKSKG2u873ln1ypVgwwnmx8tmBVi3ot1e7SbnD0m3WLhL
	 LopfX7snGZZR27yiSD+sRQAvzl30JkABtxdwN75F0W9QDeu69yYkKo7ifqxl0vbKfn
	 9+3N7yDhNdLMjJlrkRmkZXzvoJtOZ6Dycuk6G85s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728685AbfKJCow (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Nov 2019 21:44:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728656AbfKJCos (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7ACF215EA;
        Sun, 10 Nov 2019 02:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353887;
        bh=YUdWJefQqbJCfgysInUFfykhGjVrzLCnQMM6zBJYnkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vxhm1GP9BfqhIBPvV1WvFlw0B4k5wW2RadfUv2SIIKmBmUCwKMQERhAqdbTpuI4k1
         0xHgC3Ik8FKG/jkNBaWjJ6k9MG0lXXetLjz2m5XZY+Clmqylgld5A/6aKveu0lRLpK
         w6GDzp7Qu+99AP2acQoZrZ4UILbWzYpBOokHikAA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Erel Geron <erelx.geron@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 161/191] iwlwifi: fix non_shared_ant for 22000 devices
Date:   Sat,  9 Nov 2019 21:39:43 -0500
Message-Id: <20191110024013.29782-161-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Erel Geron <erelx.geron@intel.com>

[ Upstream commit a40287727d9b737e183959fd31a4e0c55f312853 ]

The non-shared antenna was wrong for 22000 device series.
Fix it to ANT_B for correct antenna preference by coex in MVM driver.

Fixes: e34d975e40ff ("iwlwifi: Add a000 HW family support")
Signed-off-by: Erel Geron <erelx.geron@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index b4347806a59ed..a0de61aa0feff 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -143,7 +143,7 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
 	.ucode_api_min = IWL_22000_UCODE_API_MIN,			\
 	.led_mode = IWL_LED_RF_STATE,					\
 	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_22000,		\
-	.non_shared_ant = ANT_A,					\
+	.non_shared_ant = ANT_B,					\
 	.dccm_offset = IWL_22000_DCCM_OFFSET,				\
 	.dccm_len = IWL_22000_DCCM_LEN,					\
 	.dccm2_offset = IWL_22000_DCCM2_OFFSET,				\
-- 
2.20.1

