Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84901C04EBD
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 17:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BF8020866
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 17:31:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5BF8020866
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731243AbeJQBOW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 21:14:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39803 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730635AbeJQBOW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 21:14:22 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1gCT3T-0000VN-RX; Tue, 16 Oct 2018 17:22:51 +0000
From:   Colin King <colin.king@canonical.com>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: mvm: fix spelling mistake "Recieved" -> "Received"
Date:   Tue, 16 Oct 2018 18:22:51 +0100
Message-Id: <20181016172251.1227-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in IWL_DEBUG_TE message text.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 505b0385d800..271db16cf0c8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3351,7 +3351,7 @@ static bool iwl_mvm_rx_aux_roc(struct iwl_notif_wait_data *notif_wait,
 	resp = (void *)pkt->data;
 
 	IWL_DEBUG_TE(mvm,
-		     "Aux ROC: Recieved response from ucode: status=%d uid=%d\n",
+		     "Aux ROC: Received response from ucode: status=%d uid=%d\n",
 		     resp->status, resp->event_unique_id);
 
 	te_data->uid = le32_to_cpu(resp->event_unique_id);
-- 
2.19.1

