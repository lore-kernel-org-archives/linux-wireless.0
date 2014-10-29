Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62136 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555AbaJ2LvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:14 -0400
Received: by mail-wg0-f44.google.com with SMTP id x12so1101243wgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:51:13 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/25] iwlwifi: pcie: warn if extern fw_debug buffer failed
Date: Wed, 29 Oct 2014 13:50:31 +0200
Message-Id: <1414583446-11032-10-git-send-email-egrumbach@gmail.com> (sfid-20141029_131321_568261_FFFC703E)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Otherwise we have no way to know that the buffer hasn't been
allocated.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 3781b02..5c9064f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -133,7 +133,7 @@ static void iwl_pcie_alloc_fw_monitor(struct iwl_trans *trans)
 		break;
 	}
 
-	if (!page)
+	if (WARN_ON_ONCE(!page))
 		return;
 
 	trans_pcie->fw_mon_page = page;
-- 
1.9.1

