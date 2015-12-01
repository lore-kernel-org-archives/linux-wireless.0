Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020AbbLAJ7d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:33 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Moshe Harel <moshe.harel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/41] iwlwifi: mvm: add bt rrc and ttc to debugfs
Date: Tue,  1 Dec 2015 11:58:43 +0200
Message-Id: <1448963947-24302-17-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_105947_056817_682BD9E7)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Moshe Harel <moshe.harel@intel.com>

As part of the bt_notif file add fields that are currently
not represented

Signed-off-by: Moshe Harel <moshe.harel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 2322c99..82a61f6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -512,6 +512,10 @@ static ssize_t iwl_dbgfs_bt_notif_read(struct file *file, char __user *user_buf,
 		pos += scnprintf(buf+pos, bufsz-pos,
 				 "antenna isolation = %d CORUN LUT index = %d\n",
 				 mvm->last_ant_isol, mvm->last_corun_lut);
+		pos += scnprintf(buf + pos, bufsz - pos, "bt_rrc = %d\n",
+				 notif->rrc_enabled);
+		pos += scnprintf(buf + pos, bufsz - pos, "bt_ttc = %d\n",
+				 notif->ttc_enabled);
 	} else {
 		struct iwl_bt_coex_profile_notif *notif =
 			&mvm->last_bt_notif;
@@ -530,6 +534,10 @@ static ssize_t iwl_dbgfs_bt_notif_read(struct file *file, char __user *user_buf,
 		pos += scnprintf(buf+pos, bufsz-pos,
 				 "antenna isolation = %d CORUN LUT index = %d\n",
 				 mvm->last_ant_isol, mvm->last_corun_lut);
+		pos += scnprintf(buf + pos, bufsz - pos, "bt_rrc = %d\n",
+				 (notif->ttc_rrc_status >> 4) & 0xF);
+		pos += scnprintf(buf + pos, bufsz - pos, "bt_ttc = %d\n",
+				 notif->ttc_rrc_status & 0xF);
 	}
 
 	pos += scnprintf(buf + pos, bufsz - pos, "sync_sco = %d\n",
-- 
2.5.0

