Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:62334 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab3LQUpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:19 -0500
Received: by mail-ea0-f177.google.com with SMTP id n15so3150934ead.36
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:18 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/36] iwlwifi: trans: turn set_pmi into an optional callback
Date: Tue, 17 Dec 2013 22:44:27 +0200
Message-Id: <1387313079-28123-24-git-send-email-egrumbach@gmail.com> (sfid-20131217_214525_511284_AFD79F6C)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

It is not currently implemented for SDIO, and not required for other slave
buses as well.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 8aaabdb..0c36478 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -787,7 +787,8 @@ static inline u32 iwl_trans_write_mem32(struct iwl_trans *trans, u32 addr,
 
 static inline void iwl_trans_set_pmi(struct iwl_trans *trans, bool state)
 {
-	trans->ops->set_pmi(trans, state);
+	if (trans->ops->set_pmi)
+		trans->ops->set_pmi(trans, state);
 }
 
 static inline void
-- 
1.7.9.5

