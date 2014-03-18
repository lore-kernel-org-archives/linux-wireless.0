Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:56215 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbaCROpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:45:43 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so5422859eek.20
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:45:42 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/35] iwlwifi: mvm: init drv_stats_lock
Date: Tue, 18 Mar 2014 16:45:05 +0200
Message-Id: <1395153939-23897-1-git-send-email-egrumbach@gmail.com> (sfid-20140318_154547_404859_68C860B7)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Otherwise lockdep complains about the lock, I'm not sure
why we didn't see this before.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index e0ff43e..41c6370 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -1049,6 +1049,8 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	struct dentry *bcast_dir __maybe_unused;
 	char buf[100];
 
+	spin_lock_init(&mvm->drv_stats_lock);
+
 	mvm->debugfs_dir = dbgfs_dir;
 
 	MVM_DEBUGFS_ADD_FILE(tx_flush, mvm->debugfs_dir, S_IWUSR);
-- 
1.8.3.2

