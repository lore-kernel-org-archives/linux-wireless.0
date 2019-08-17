Return-Path: <SRS0=m094=WN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91DF4C3A59B
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Aug 2019 06:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6516921019
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Aug 2019 06:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfHQGwl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 17 Aug 2019 02:52:41 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:36376 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725945AbfHQGwl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Aug 2019 02:52:41 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hysZg-0006XT-5R; Sat, 17 Aug 2019 09:52:28 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Sat, 17 Aug 2019 09:51:58 +0300
Message-Id: <20190817065200.9701-21-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190817065200.9701-1-luca@coelho.fi>
References: <20190817065200.9701-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 20/22] iwlwifi: remove CMD_HIGH_PRIO
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This flag is never set on any host command. Remove it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 0f8aeb111b0e..20251f5e6f41 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -159,9 +159,6 @@ static inline u32 iwl_rx_packet_payload_len(const struct iwl_rx_packet *pkt)
  * @CMD_ASYNC: Return right away and don't wait for the response
  * @CMD_WANT_SKB: Not valid with CMD_ASYNC. The caller needs the buffer of
  *	the response. The caller needs to call iwl_free_resp when done.
- * @CMD_HIGH_PRIO: The command is high priority - it goes to the front of the
- *	command queue, but after other high priority commands. Valid only
- *	with CMD_ASYNC.
  * @CMD_SEND_IN_IDLE: The command should be sent even when the trans is idle.
  * @CMD_MAKE_TRANS_IDLE: The command response should mark the trans as idle.
  * @CMD_WAKE_UP_TRANS: The command response should wake up the trans
@@ -173,11 +170,10 @@ enum CMD_MODE {
 	CMD_ASYNC		= BIT(0),
 	CMD_WANT_SKB		= BIT(1),
 	CMD_SEND_IN_RFKILL	= BIT(2),
-	CMD_HIGH_PRIO		= BIT(3),
-	CMD_SEND_IN_IDLE	= BIT(4),
-	CMD_MAKE_TRANS_IDLE	= BIT(5),
-	CMD_WAKE_UP_TRANS	= BIT(6),
-	CMD_WANT_ASYNC_CALLBACK	= BIT(7),
+	CMD_SEND_IN_IDLE	= BIT(3),
+	CMD_MAKE_TRANS_IDLE	= BIT(4),
+	CMD_WAKE_UP_TRANS	= BIT(5),
+	CMD_WANT_ASYNC_CALLBACK	= BIT(6),
 };
 
 #define DEF_CMD_PAYLOAD_SIZE 320
-- 
2.23.0.rc1

