Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45732 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756350AbbIUU7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 16:59:13 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:58:47 +0300
Message-Id: <1442869141-31637-7-git-send-email-luca@coelho.fi> (sfid-20150921_230043_102946_4E6103D3)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 07/21] iwlwifi: mvm: don't NUL-terminate low-latency debugfs file
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's obviously no reason to write a NUL-terminating byte into
the debugfs file. Apparently nobody tried to use this from a tool
that doesn't strip NUL bytes though, so we never noticed. Fix it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 383a316..334ae56 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -1250,11 +1250,10 @@ static ssize_t iwl_dbgfs_low_latency_read(struct file *file,
 {
 	struct ieee80211_vif *vif = file->private_data;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	char buf[3];
+	char buf[2];
 
 	buf[0] = mvmvif->low_latency ? '1' : '0';
 	buf[1] = '\n';
-	buf[2] = '\0';
 	return simple_read_from_buffer(user_buf, count, ppos, buf, sizeof(buf));
 }
 
-- 
2.5.1

