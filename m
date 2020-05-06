Return-Path: <SRS0=8PMz=6U=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C7DC28CBC
	for <linux-wireless@archiver.kernel.org>; Wed,  6 May 2020 13:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5910C20746
	for <linux-wireless@archiver.kernel.org>; Wed,  6 May 2020 13:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgEFNm5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 May 2020 09:42:57 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3824 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728620AbgEFNm4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 May 2020 09:42:56 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A380299D6FA32FB08C48;
        Wed,  6 May 2020 21:42:52 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Wed, 6 May 2020
 21:42:42 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <johannes.berg@intel.com>, <emmanuel.grumbach@intel.com>,
        <luciano.coelho@intel.com>, <linuxwifi@intel.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] iwlwifi: mvm: Remove unused inline function iwl_mvm_tid_to_ac_queue
Date:   Wed, 6 May 2020 21:42:17 +0800
Message-ID: <20200506134217.49760-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

commit cfbc6c4c5b91 ("iwlwifi: mvm: support mac80211 TXQs model")
left behind this, remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 56ae72debb96..f271bb264ddc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1364,14 +1364,6 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	return ret;
 }
 
-static inline u8 iwl_mvm_tid_to_ac_queue(int tid)
-{
-	if (tid == IWL_MAX_TID_COUNT)
-		return IEEE80211_AC_VO; /* MGMT */
-
-	return tid_to_mac80211_ac[tid];
-}
-
 void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk)
 {
 	struct iwl_mvm *mvm = container_of(wk, struct iwl_mvm,
-- 
2.17.1


