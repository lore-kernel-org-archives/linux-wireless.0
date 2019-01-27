Return-Path: <SRS0=DVo7=QD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C8CC282C0
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32CF42146E
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfA0KU1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 05:20:27 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51462 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726839AbfA0KU1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 05:20:27 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gnhXO-0001vC-Ks; Sun, 27 Jan 2019 12:19:39 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 27 Jan 2019 12:19:08 +0200
Message-Id: <20190127101908.6428-22-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127101908.6428-1-luca@coelho.fi>
References: <20190127101908.6428-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 21/21] iwiwifi: fix bad monitor buffer register addresses
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

The monitor buffer register address is wrong.
Set the right address

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Fixes: c2d202017da1 ("iwlwifi: pcie: add firmware monitor capabilities")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 9d89b7d7f9fa..3aaa5f06461c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -358,12 +358,12 @@
 
 /* FW monitor */
 #define MON_BUFF_SAMPLE_CTL		(0xa03c00)
-#define MON_BUFF_BASE_ADDR		(0xa03c3c)
+#define MON_BUFF_BASE_ADDR		(0xa03c1c)
 #define MON_BUFF_END_ADDR		(0xa03c40)
 #define MON_BUFF_WRPTR			(0xa03c44)
 #define MON_BUFF_CYCLE_CNT		(0xa03c48)
 /* FW monitor family 8000 and on */
-#define MON_BUFF_BASE_ADDR_VER2		(0xa03c3c)
+#define MON_BUFF_BASE_ADDR_VER2		(0xa03c1c)
 #define MON_BUFF_END_ADDR_VER2		(0xa03c20)
 #define MON_BUFF_WRPTR_VER2		(0xa03c24)
 #define MON_BUFF_CYCLE_CNT_VER2		(0xa03c28)
-- 
2.20.1

