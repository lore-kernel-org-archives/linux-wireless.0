Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:57092 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaKKFih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 00:38:37 -0500
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>, <stable@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/2] iwlwifi: pcie: fix prph dump length
Date: Tue, 11 Nov 2014 07:38:29 +0200
Message-Id: <1415684309-18816-2-git-send-email-egrumbach@gmail.com> (sfid-20141111_063841_373372_8CD8206A)
In-Reply-To: <CANUX_P2Q31DLtiZJ-GNcnME3LDXE2vWLN61QqNOxsjqxgfb4Gg@mail.gmail.com>
References: <CANUX_P2Q31DLtiZJ-GNcnME3LDXE2vWLN61QqNOxsjqxgfb4Gg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

The length counting previously done had an error in it, causing
the length down the data dumping function to be shorter than it
should be, causing the end of the data to get truncated off and
lost.

Cc: <stable@vger.kernel.org> [3.17+]
Fixes: 67c65f2cf710 ("iwlwifi: dump periphery registers to fw-error-dump")
Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 160c3eb..dd2f3f8 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1894,8 +1894,7 @@ static u32 iwl_trans_pcie_dump_prph(struct iwl_trans *trans,
 		int reg;
 		__le32 *val;
 
-		prph_len += sizeof(*data) + sizeof(*prph) +
-			num_bytes_in_chunk;
+		prph_len += sizeof(**data) + sizeof(*prph) + num_bytes_in_chunk;
 
 		(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_PRPH);
 		(*data)->len = cpu_to_le32(sizeof(*prph) +
-- 
1.9.1

