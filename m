Return-Path: <SRS0=qTSE=YH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA742C4CECE
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Oct 2019 07:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7DE220854
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Oct 2019 07:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730201AbfJNHU6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Oct 2019 03:20:58 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:49272 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730273AbfJNHU5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Oct 2019 03:20:57 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1iJuel-0007ae-1U; Mon, 14 Oct 2019 10:20:39 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 14 Oct 2019 10:20:17 +0300
Message-Id: <20191014101813.3c0b6fe42b2b.Idc1ae686433b4235ec1eade66dab8f9eac753551@changeid>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191014072019.1254-1-luca@coelho.fi>
References: <20191014072019.1254-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v2 14/16] iwlwifi: dbg_ini: rename external debug configuration file
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Rename the external configuration file to align to the debug SAS.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 4f2a4d88f399..1934df7fccb8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -445,7 +445,7 @@ void iwl_dbg_tlv_load_bin(struct device *dev, struct iwl_trans *trans)
 	if (!iwlwifi_mod_params.enable_ini)
 		return;
 
-	res = request_firmware(&fw, "iwl-dbg-tlv.ini", dev);
+	res = request_firmware(&fw, "iwl-debug-yoyo.bin", dev);
 	if (res)
 		return;
 
-- 
2.23.0

