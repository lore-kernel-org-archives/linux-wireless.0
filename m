Return-Path: <SRS0=jLDm=2U=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5A9C2D0C2
	for <linux-wireless@archiver.kernel.org>; Mon, 30 Dec 2019 13:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23D5A20730
	for <linux-wireless@archiver.kernel.org>; Mon, 30 Dec 2019 13:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfL3Ns0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 30 Dec 2019 08:48:26 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55604 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727445AbfL3Ns0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Dec 2019 08:48:26 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <luca@coelho.fi>)
        id 1ilvPD-0004G3-6e; Mon, 30 Dec 2019 15:48:24 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 30 Dec 2019 15:48:16 +0200
Message-Id: <20191230134816.88136-1-luca@coelho.fi>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v5.5] Revert "iwlwifi: mvm: fix scan config command size"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mehmet Akif Tasova <makiftasova@gmail.com>

Since v5.4-rc1 was released, iwlwifi started throwing errors when scan
commands were sent to the firmware with certain devices (depending on
the OTP burned in the device, which contains the list of available
channels).  For instance:

iwlwifi 0000:00:14.3: FW error in SYNC CMD SCAN_CFG_CMD

This bug was reported in the ArchLinux bug tracker:
https://bugs.archlinux.org/task/64703

And also in a specific case in bugzilla, when the lar_disabled option
was set: https://bugzilla.kernel.org/show_bug.cgi?id=205193

Revert the commit that introduced this error, by using the number of
channels from the OTP instead of the number of channels that is
specified in the FW TLV that tells us how many channels it supports.

This reverts commit 06eb547c4ae4382e70d556ba213d13c95ca1801b.

Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Mehmet Akif Tasova <makiftasova@gmail.com>
[ Luca: reworded the commit message a bit. ]
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index a046ac9fa852..a5af8f4128b1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1213,7 +1213,7 @@ static int iwl_mvm_legacy_config_scan(struct iwl_mvm *mvm)
 		cmd_size = sizeof(struct iwl_scan_config_v2);
 	else
 		cmd_size = sizeof(struct iwl_scan_config_v1);
-	cmd_size += num_channels;
+	cmd_size += mvm->fw->ucode_capa.n_scan_channels;
 
 	cfg = kzalloc(cmd_size, GFP_KERNEL);
 	if (!cfg)
-- 
2.24.1

