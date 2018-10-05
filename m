Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C74C1C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CB7320652
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:35:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CB7320652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727748AbeJERdw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 13:33:52 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13193 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727572AbeJERdw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 13:33:52 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C6529EC2CDD0D;
        Fri,  5 Oct 2018 18:35:34 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.399.0; Fri, 5 Oct 2018 18:35:29 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Intel Linux Wireless" <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH] iwlwifi: mvm: remove set but not used variable 'he_phy_data'
Date:   Fri, 5 Oct 2018 10:47:01 +0000
Message-ID: <1538736421-97401-1-git-send-email-yuehaibing@huawei.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c: In function 'iwl_mvm_rx_mpdu_mq':
drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c:1386:7: warning:
 variable 'he_phy_data' set but not used [-Wunused-but-set-variable]
   u64 he_phy_data;
   
'he_phy_data' never used since be introduce in
commit 18ead597daa1 ("iwlwifi: support new rx_mpdu_desc api")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 894dd63..7eaa586 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1383,12 +1383,6 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	/* update aggregation data for monitor sake on default queue */
 	if (!queue && (phy_info & IWL_RX_MPDU_PHY_AMPDU)) {
 		bool toggle_bit = phy_info & IWL_RX_MPDU_PHY_AMPDU_TOGGLE;
-		u64 he_phy_data;
-
-		if (mvm->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
-			he_phy_data = le64_to_cpu(desc->v3.he_phy_data);
-		else
-			he_phy_data = le64_to_cpu(desc->v1.he_phy_data);
 
 		rx_status->flag |= RX_FLAG_AMPDU_DETAILS;
 		rx_status->ampdu_reference = mvm->ampdu_ref;

