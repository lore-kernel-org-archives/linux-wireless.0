Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:18944 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbcBOL7S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 06:59:18 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Anton Protopopov <a.s.protopopov@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/5] iwlwifi: pcie: fix erroneous return value
Date: Mon, 15 Feb 2016 13:59:06 +0200
Message-Id: <1455537546-22157-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160215_181515_558032_368BD3D4)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA13D1A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA13D1A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anton Protopopov <a.s.protopopov@gmail.com>

The iwl_trans_pcie_start_fw() function may return the positive value EIO
instead of -EIO in case of error.

Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 5503072..5a854c6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1168,7 +1168,7 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	if (trans_pcie->is_down) {
 		IWL_WARN(trans,
 			 "Can't start_fw since the HW hasn't been started\n");
-		ret = EIO;
+		ret = -EIO;
 		goto out;
 	}
 
-- 
2.5.0

