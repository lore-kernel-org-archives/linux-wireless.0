Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C201EC00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 835B02087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:17:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 835B02087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbeJHP2T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:28:19 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56346 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726793AbeJHP2T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:28:19 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g9Qjb-0003w6-Va; Mon, 08 Oct 2018 11:17:48 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Oct 2018 11:17:25 +0300
Message-Id: <20181008081735.3401-9-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181008081735.3401-1-luca@coelho.fi>
References: <20181008081735.3401-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/18] iwlwifi: mvm: give TX queue info struct a name
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Make this a named struct rather than an anonymous one,
we'll want to refer to it by name later.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 24 +++++++++++---------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index ff1ba84f3aa6..cff58ed35fbe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -788,6 +788,18 @@ struct iwl_mvm_geo_profile {
 	u8 values[ACPI_GEO_TABLE_SIZE];
 };
 
+struct iwl_mvm_dqa_txq_info {
+	u8 hw_queue_refcount;
+	u8 ra_sta_id; /* The RA this queue is mapped to, if exists */
+	bool reserved; /* Is this the TXQ reserved for a STA */
+	u8 mac80211_ac; /* The mac80211 AC this queue is mapped to */
+	u8 txq_tid; /* The TID "owner" of this queue*/
+	u16 tid_bitmap; /* Bitmap of the TIDs mapped to this queue */
+	/* Timestamp for inactivation per TID of this queue */
+	unsigned long last_frame_time[IWL_MAX_TID_COUNT + 1];
+	enum iwl_mvm_queue_status status;
+};
+
 struct iwl_mvm {
 	/* for logger access */
 	struct device *dev;
@@ -844,17 +856,7 @@ struct iwl_mvm {
 
 	u16 hw_queue_to_mac80211[IWL_MAX_TVQM_QUEUES];
 
-	struct {
-		u8 hw_queue_refcount;
-		u8 ra_sta_id; /* The RA this queue is mapped to, if exists */
-		bool reserved; /* Is this the TXQ reserved for a STA */
-		u8 mac80211_ac; /* The mac80211 AC this queue is mapped to */
-		u8 txq_tid; /* The TID "owner" of this queue*/
-		u16 tid_bitmap; /* Bitmap of the TIDs mapped to this queue */
-		/* Timestamp for inactivation per TID of this queue */
-		unsigned long last_frame_time[IWL_MAX_TID_COUNT + 1];
-		enum iwl_mvm_queue_status status;
-	} queue_info[IWL_MAX_HW_QUEUES];
+	struct iwl_mvm_dqa_txq_info queue_info[IWL_MAX_HW_QUEUES];
 	spinlock_t queue_info_lock; /* For syncing queue mgmt operations */
 	struct work_struct add_stream_wk; /* To add streams to queues */
 
-- 
2.19.0

