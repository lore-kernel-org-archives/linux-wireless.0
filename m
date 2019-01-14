Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92D58C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 11:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B96820659
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 11:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfANLAb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 06:00:31 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:46756 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726478AbfANLAb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 06:00:31 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gizym-0001R0-6E; Mon, 14 Jan 2019 13:00:28 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon, 14 Jan 2019 13:00:23 +0200
Message-Id: <20190114110023.23172-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH for v5.0] iwlwifi: make IWLWIFI depend on CFG80211
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Since IWLWIFI doesn't depend on MAC80211 anymore, it needs to depend
on CFG80211, because it uses a few symbols from it.  Add the
dependency on CFG80211 accordingly.

Additionally, make IWLWIFI_LEDS depend on IWLMVM or IWLDVM, since it
doesn't need mac80211 but must be used for these.

Fixes: aca432f06b8a ("iwlwifi: make MVM and DVM depend on MAC80211")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index 491ca3c8b43c..83d5bceea08f 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -1,6 +1,6 @@
 config IWLWIFI
 	tristate "Intel Wireless WiFi Next Gen AGN - Wireless-N/Advanced-N/Ultimate-N (iwlwifi) "
-	depends on PCI && HAS_IOMEM
+	depends on PCI && HAS_IOMEM && CFG80211
 	select FW_LOADER
 	---help---
 	  Select to build the driver supporting the:
@@ -47,6 +47,7 @@ if IWLWIFI
 config IWLWIFI_LEDS
 	bool
 	depends on LEDS_CLASS=y || LEDS_CLASS=IWLWIFI
+	depends on IWLMVM || IWLDVM
 	select LEDS_TRIGGERS
 	select MAC80211_LEDS
 	default y
-- 
2.20.1

