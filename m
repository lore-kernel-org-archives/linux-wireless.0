Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:50881 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbaKXOgr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:47 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so5842245wid.15
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:46 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 68/75] iwlwifi: trans: add suspend/resume ops
Date: Mon, 24 Nov 2014 16:34:44 +0200
Message-Id: <1416839691-28533-68-git-send-email-egrumbach@gmail.com> (sfid-20141124_153656_175586_13D5DEC7)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Add suspend/resume trans ops that will be called from
mac80211's suspend/resume ops.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 0768f83e..0289803 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -534,6 +534,8 @@ struct iwl_trans_ops {
 			      u32 value);
 	void (*ref)(struct iwl_trans *trans);
 	void (*unref)(struct iwl_trans *trans);
+	void (*suspend)(struct iwl_trans *trans);
+	void (*resume)(struct iwl_trans *trans);
 
 	struct iwl_trans_dump_data *(*dump_data)(struct iwl_trans *trans);
 };
@@ -702,6 +704,18 @@ static inline void iwl_trans_unref(struct iwl_trans *trans)
 		trans->ops->unref(trans);
 }
 
+static inline void iwl_trans_suspend(struct iwl_trans *trans)
+{
+	if (trans->ops->suspend)
+		trans->ops->suspend(trans);
+}
+
+static inline void iwl_trans_resume(struct iwl_trans *trans)
+{
+	if (trans->ops->resume)
+		trans->ops->resume(trans);
+}
+
 static inline struct iwl_trans_dump_data *
 iwl_trans_dump_data(struct iwl_trans *trans)
 {
-- 
1.9.1

