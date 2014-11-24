Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49679 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366AbaKXOg6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:58 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so5862287wiv.11
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:57 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 75/75] iwlwifi: update the secure mem space and for the CPUs
Date: Mon, 24 Nov 2014 16:34:51 +0200
Message-Id: <1416839691-28533-75-git-send-email-egrumbach@gmail.com> (sfid-20141124_153710_962045_94490C36)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Also update the timeout for the data verification.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 90011b1..1dae702 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -349,10 +349,10 @@ enum secure_load_status_reg {
 
 #define LMPM_SECURE_INSPECTOR_CODE_MEM_SPACE	(0x400000)
 #define LMPM_SECURE_INSPECTOR_DATA_MEM_SPACE	(0x402000)
-#define LMPM_SECURE_CPU1_HDR_MEM_SPACE		(0x420000)
-#define LMPM_SECURE_CPU2_HDR_MEM_SPACE		(0x420400)
+#define LMPM_SECURE_CPU1_HDR_MEM_SPACE		(0x404000)
+#define LMPM_SECURE_CPU2_HDR_MEM_SPACE		(0x405000)
 
-#define LMPM_SECURE_TIME_OUT	(100)
+#define LMPM_SECURE_TIME_OUT	(50000) /* 5 msec */
 
 /* Rx FIFO */
 #define RXF_SIZE_ADDR			(0xa00c88)
-- 
1.9.1

