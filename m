Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:37531 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaBCU6s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:48 -0500
Received: by mail-ea0-f173.google.com with SMTP id d10so3998694eaj.4
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:48 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/62] iwlwifi: mvm: change the format of the SRAM dump
Date: Mon,  3 Feb 2014 22:57:28 +0200
Message-Id: <1391461088-8082-22-git-send-email-egrumbach@gmail.com> (sfid-20140203_220009_660150_B56EC3D0)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

As a debug tool, we dump the SRAM from the device when an
error occurs. The main users of this want it in a different
format, so change the format to suit their needs.
Also - add a short delay between the prints to make sure
that the user space logger can catch up.

This happens only when the firmware asserts, and only when
fw_restart is set to 0 which is typically a testing
configuration.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/utils.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 1aadede..b216232 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -457,7 +457,8 @@ void iwl_mvm_dump_sram(struct iwl_mvm *mvm)
 {
 	const struct fw_img *img;
 	int ofs, len = 0;
-	u8 *buf;
+	int i;
+	__le32 *buf;
 
 	if (!mvm->ucode_loaded)
 		return;
@@ -471,7 +472,12 @@ void iwl_mvm_dump_sram(struct iwl_mvm *mvm)
 		return;
 
 	iwl_trans_read_mem_bytes(mvm->trans, ofs, buf, len);
-	iwl_print_hex_error(mvm->trans, buf, len);
+	len = len >> 2;
+	for (i = 0; i < len; i++) {
+		IWL_ERR(mvm, "0x%08X\n", le32_to_cpu(buf[i]));
+		/* Add a small delay to let syslog catch up */
+		udelay(10);
+	}
 
 	kfree(buf);
 }
-- 
1.7.9.5

