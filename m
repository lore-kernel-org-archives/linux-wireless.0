Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64087 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbaKXOfs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:48 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so5903158wiv.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:47 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 31/75] iwlwifi: pcie: support loading FW with extended mem range
Date: Mon, 24 Nov 2014 16:34:07 +0200
Message-Id: <1416839691-28533-31-git-send-email-egrumbach@gmail.com> (sfid-20141124_154114_709666_0A538369)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Toggle the LMPM_CHICK register when writing chunks into the FW's extended
SRAM. This tells the FW to put the chunk into a different memory space.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h   |  6 ++++++
 drivers/net/wireless/iwlwifi/pcie/trans.c | 26 ++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 1560f45..90011b1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -368,4 +368,10 @@ enum secure_load_status_reg {
 #define MON_BUFF_WRPTR			(0xa03c44)
 #define MON_BUFF_CYCLE_CNT		(0xa03c48)
 
+/* FW chicken bits */
+#define LMPM_CHICK			0xA01FF8
+enum {
+	LMPM_CHICK_EXTENDED_ADDR_SPACE = BIT(0),
+};
+
 #endif				/* __iwl_prph_h__ */
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index b81d141..a3b63b7 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -79,6 +79,10 @@
 #include "iwl-fw-error-dump.h"
 #include "internal.h"
 
+/* extended range in FW SRAM */
+#define IWL_FW_MEM_EXTENDED_START	0x40000
+#define IWL_FW_MEM_EXTENDED_END		0x57FFF
+
 static void iwl_pcie_free_fw_monitor(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -627,14 +631,28 @@ static int iwl_pcie_load_section(struct iwl_trans *trans, u8 section_num,
 	}
 
 	for (offset = 0; offset < section->len; offset += chunk_sz) {
-		u32 copy_size;
+		u32 copy_size, dst_addr;
+		bool extended_addr = false;
 
 		copy_size = min_t(u32, chunk_sz, section->len - offset);
+		dst_addr = section->offset + offset;
+
+		if (dst_addr >= IWL_FW_MEM_EXTENDED_START &&
+		    dst_addr <= IWL_FW_MEM_EXTENDED_END)
+			extended_addr = true;
+
+		if (extended_addr)
+			iwl_set_bits_prph(trans, LMPM_CHICK,
+					  LMPM_CHICK_EXTENDED_ADDR_SPACE);
 
 		memcpy(v_addr, (u8 *)section->data + offset, copy_size);
-		ret = iwl_pcie_load_firmware_chunk(trans,
-						   section->offset + offset,
-						   p_addr, copy_size);
+		ret = iwl_pcie_load_firmware_chunk(trans, dst_addr, p_addr,
+						   copy_size);
+
+		if (extended_addr)
+			iwl_clear_bits_prph(trans, LMPM_CHICK,
+					    LMPM_CHICK_EXTENDED_ADDR_SPACE);
+
 		if (ret) {
 			IWL_ERR(trans,
 				"Could not load the [%d] uCode section\n",
-- 
1.9.1

