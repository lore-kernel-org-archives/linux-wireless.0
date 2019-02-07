Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A31C0C282C4
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D3772173B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfBGWgl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 17:36:41 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:56578 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726622AbfBGWgk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 17:36:40 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grsHe-0002II-H7; Fri, 08 Feb 2019 00:36:38 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 00:36:09 +0200
Message-Id: <20190207223622.9642-5-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190207223622.9642-1-luca@coelho.fi>
References: <20190207223622.9642-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/17] iwlwifi: pcie: add TPT oriented prints
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Currently there is no way to debug RX/TX paths using prints
without harming tpt. Add prints to debug RX allocation path.
We can still get 1.9 gbps with those on.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/iwl-debug.h    |  5 +++--
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  | 20 +++++++++++++------
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-debug.h b/drivers/net/wireless/intel/iwlwifi/iwl-debug.h
index a2af68a0d34b..655ff5694560 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-debug.h
@@ -1,6 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
+ * Copyright (C) 2018 Intel Corporation
  *
  * Portions of this file are derived from the ipw3945 project.
  *
@@ -159,7 +160,7 @@ do {                                            			\
 /* 0x000F0000 - 0x00010000 */
 #define IWL_DL_FW		0x00010000
 #define IWL_DL_RF_KILL		0x00020000
-#define IWL_DL_FW_ERRORS	0x00040000
+#define IWL_DL_TPT		0x00040000
 /* 0x00F00000 - 0x00100000 */
 #define IWL_DL_RATE		0x00100000
 #define IWL_DL_CALIB		0x00200000
@@ -193,7 +194,6 @@ do {                                            			\
 #define IWL_DEBUG_CALIB(p, f, a...)	IWL_DEBUG(p, IWL_DL_CALIB, f, ## a)
 #define IWL_DEBUG_FW(p, f, a...)	IWL_DEBUG(p, IWL_DL_FW, f, ## a)
 #define IWL_DEBUG_RF_KILL(p, f, a...)	IWL_DEBUG(p, IWL_DL_RF_KILL, f, ## a)
-#define IWL_DEBUG_FW_ERRORS(p, f, a...)	IWL_DEBUG(p, IWL_DL_FW_ERRORS, f, ## a)
 #define IWL_DEBUG_DROP(p, f, a...)	IWL_DEBUG(p, IWL_DL_DROP, f, ## a)
 #define IWL_DEBUG_DROP_LIMIT(p, f, a...)	\
 		IWL_DEBUG_LIMIT(p, IWL_DL_DROP, f, ## a)
@@ -215,6 +215,7 @@ do {                                            			\
 #define IWL_DEBUG_DEV_RADIO(p, f, a...)	IWL_DEBUG_DEV(p, IWL_DL_RADIO, f, ## a)
 #define IWL_DEBUG_POWER(p, f, a...)	IWL_DEBUG(p, IWL_DL_POWER, f, ## a)
 #define IWL_DEBUG_11H(p, f, a...)	IWL_DEBUG(p, IWL_DL_11H, f, ## a)
+#define IWL_DEBUG_TPT(p, f, a...)	IWL_DEBUG(p, IWL_DL_TPT, f, ## a)
 #define IWL_DEBUG_RPM(p, f, a...)	IWL_DEBUG(p, IWL_DL_RPM, f, ## a)
 #define IWL_DEBUG_LAR(p, f, a...)	IWL_DEBUG(p, IWL_DL_LAR, f, ## a)
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 36cbfed409d0..49c2ce549c86 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -540,7 +540,7 @@ static void iwl_pcie_rx_allocator(struct iwl_trans *trans)
 	struct list_head local_empty;
 	int pending = atomic_read(&rba->req_pending);
 
-	IWL_DEBUG_RX(trans, "Pending allocation requests = %d\n", pending);
+	IWL_DEBUG_TPT(trans, "Pending allocation requests = %d\n", pending);
 
 	/* If we were scheduled - there is at least one request */
 	spin_lock(&rba->lock);
@@ -598,9 +598,10 @@ static void iwl_pcie_rx_allocator(struct iwl_trans *trans)
 
 		if (!pending) {
 			pending = atomic_read(&rba->req_pending);
-			IWL_DEBUG_RX(trans,
-				     "Got more pending allocation requests = %d\n",
-				     pending);
+			if (pending)
+				IWL_DEBUG_TPT(trans,
+					      "Got more pending allocation requests = %d\n",
+					      pending);
 		}
 
 		spin_lock(&rba->lock);
@@ -619,7 +620,7 @@ static void iwl_pcie_rx_allocator(struct iwl_trans *trans)
 	list_splice_tail(&local_empty, &rba->rbd_empty);
 	spin_unlock(&rba->lock);
 
-	IWL_DEBUG_RX(trans, "%s, exit.\n", __func__);
+	IWL_DEBUG_TPT(trans, "%s, exit.\n", __func__);
 }
 
 /*
@@ -1429,6 +1430,9 @@ static void iwl_pcie_rx_handle(struct iwl_trans *trans, int queue)
 			     !emergency)) {
 			iwl_pcie_rx_move_to_allocator(rxq, rba);
 			emergency = true;
+			IWL_DEBUG_TPT(trans,
+				      "RX path is in emergency. Pending allocations %d\n",
+				      rb_pending_alloc);
 		}
 
 		IWL_DEBUG_RX(trans, "Q %d: HW = %d, SW = %d\n", rxq->id, r, i);
@@ -1458,8 +1462,12 @@ static void iwl_pcie_rx_handle(struct iwl_trans *trans, int queue)
 			count++;
 			if (count == 8) {
 				count = 0;
-				if (rb_pending_alloc < rxq->queue_size / 3)
+				if (rb_pending_alloc < rxq->queue_size / 3) {
+					IWL_DEBUG_TPT(trans,
+						      "RX path exited emergency. Pending allocations %d\n",
+						      rb_pending_alloc);
 					emergency = false;
+				}
 
 				rxq->read = i;
 				spin_unlock(&rxq->lock);
-- 
2.20.1

