Return-Path: <SRS0=6JIn=5C=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C8DC18E5B
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Mar 2020 10:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF0C320663
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Mar 2020 10:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgCQKdu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 17 Mar 2020 06:33:50 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:34454 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725730AbgCQKdu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Mar 2020 06:33:50 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <luca@coelho.fi>)
        id 1jE9Xf-0003XL-H4; Tue, 17 Mar 2020 12:33:48 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 17 Mar 2020 12:33:41 +0200
Message-Id: <iwlwifi.20200317123331.16762b29f26c.I928bcaa799e7b3d33838c0667714eeb9fa665290@changeid>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v5.6] iwlwifi: pcie: add 0x2526/0x401* devices back to cfg detection
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Three devices, with PCI device ID 0x2526 and subdevice IDs 0x4010,
0x4018 and 0x401C were removed accidentally.  Add them back.

Reported-by: Brett Hassal <brett.hassal@gmail.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=206661
Fixes: 0b295a1eb81f ("iwlwifi: add device name to device_info")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 97f227f3cbc3..f441b20e1642 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -981,6 +981,9 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 	IWL_DEV_INFO(0x2526, 0x0014, iwl9260_2ac_160_cfg, iwl9260_160_name),
 	IWL_DEV_INFO(0x2526, 0x0018, iwl9260_2ac_160_cfg, iwl9260_160_name),
 	IWL_DEV_INFO(0x2526, 0x001C, iwl9260_2ac_160_cfg, iwl9260_160_name),
+	IWL_DEV_INFO(0x2526, 0x4010, iwl9260_2ac_160_cfg, iwl9260_160_name),
+	IWL_DEV_INFO(0x2526, 0x4018, iwl9260_2ac_160_cfg, iwl9260_160_name),
+	IWL_DEV_INFO(0x2526, 0x401C, iwl9260_2ac_160_cfg, iwl9260_160_name),
 	IWL_DEV_INFO(0x2526, 0x6010, iwl9260_2ac_160_cfg, iwl9260_160_name),
 	IWL_DEV_INFO(0x2526, 0x6014, iwl9260_2ac_160_cfg, iwl9260_160_name),
 	IWL_DEV_INFO(0x2526, 0x8014, iwl9260_2ac_160_cfg, iwl9260_160_name),
-- 
2.25.1

