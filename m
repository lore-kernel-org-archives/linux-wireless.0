Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FDC7C282C6
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 581DA218B0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbfAYUNR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 15:13:17 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:50772 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726257AbfAYUNP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 15:13:15 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gn7qj-00010a-Ik; Fri, 25 Jan 2019 22:13:13 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 25 Jan 2019 22:12:51 +0200
Message-Id: <20190125201305.5616-4-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190125201305.5616-1-luca@coelho.fi>
References: <20190125201305.5616-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/17] iwlwifi: iwlmvm: in monitor NDP notif take the NSS from rx_vec
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

Take the NSS value from 'rx_vec' rather than from 'rate_n_flags'.
The rate_n_flags has only 2 bits for the NSS giving a max of 4SS
(0 = 1SS etc.). Since there may be up to 8SS use the rx_vec which
has 3 bits for the NSS.
While at it, fix the rx_vec array to length of 2.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h |  5 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c  | 17 +++++++++++++----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
index b4f7ea30a7c1..11c25f32a286 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
@@ -719,6 +719,9 @@ struct iwl_rx_mpdu_desc {
 #define RX_NO_DATA_FRAME_TIME_POS	0
 #define RX_NO_DATA_FRAME_TIME_MSK	(0xfffff << RX_NO_DATA_FRAME_TIME_POS)
 
+#define RX_NO_DATA_RX_VEC0_HE_NSTS_MSK	0x03800000
+#define RX_NO_DATA_RX_VEC0_VHT_NSTS_MSK	0x38000000
+
 /**
  * struct iwl_rx_no_data - RX no data descriptor
  * @info: 7:0 frame type, 15:8 RX error type
@@ -739,7 +742,7 @@ struct iwl_rx_no_data {
 	__le32 fr_time;
 	__le32 rate;
 	__le32 phy_info[2];
-	__le32 rx_vec[3];
+	__le32 rx_vec[2];
 } __packed; /* RX_NO_DATA_NTFY_API_S_VER_1 */
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 786e93f6b502..07ddd7bc07ce 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1701,15 +1701,24 @@ void iwl_mvm_rx_monitor_ndp(struct iwl_mvm *mvm, struct napi_struct *napi,
 	} else if (rate_n_flags & RATE_MCS_VHT_MSK) {
 		u8 stbc = (rate_n_flags & RATE_MCS_STBC_MSK) >>
 				RATE_MCS_STBC_POS;
-		rx_status->nss =
-			((rate_n_flags & RATE_VHT_MCS_NSS_MSK) >>
-						RATE_VHT_MCS_NSS_POS) + 1;
 		rx_status->rate_idx = rate_n_flags & RATE_VHT_MCS_RATE_CODE_MSK;
 		rx_status->encoding = RX_ENC_VHT;
 		rx_status->enc_flags |= stbc << RX_ENC_FLAG_STBC_SHIFT;
 		if (rate_n_flags & RATE_MCS_BF_MSK)
 			rx_status->enc_flags |= RX_ENC_FLAG_BF;
-	} else if (!(rate_n_flags & RATE_MCS_HE_MSK)) {
+		/*
+		 * take the nss from the rx_vec since the rate_n_flags has
+		 * only 2 bits for the nss which gives a max of 4 ss but
+		 * there may be up to 8 spatial streams
+		 */
+		rx_status->nss =
+			le32_get_bits(desc->rx_vec[0],
+				      RX_NO_DATA_RX_VEC0_VHT_NSTS_MSK) + 1;
+	} else if (rate_n_flags & RATE_MCS_HE_MSK) {
+		rx_status->nss =
+			le32_get_bits(desc->rx_vec[0],
+				      RX_NO_DATA_RX_VEC0_HE_NSTS_MSK) + 1;
+	} else {
 		int rate = iwl_mvm_legacy_rate_to_mac80211_idx(rate_n_flags,
 							       rx_status->band);
 
-- 
2.20.1

