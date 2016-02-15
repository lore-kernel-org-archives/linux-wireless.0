Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:18944 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbcBOL7O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 06:59:14 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>, <stable@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/5] iwlwifi: mvm: don't allow sched scans without matches to be started
Date: Mon, 15 Feb 2016 13:59:04 +0200
Message-Id: <1455537546-22157-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160215_181514_988166_75F7D4CD)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA13D1A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA13D1A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The firmware can perform a scheduled scan with not matchsets passed,
but it can't send notification that results were found.  Since the
userspace then cannot know when we got new results and the firmware
wouldn't trigger a wake in case we are sleeping, it's better not to
allow scans without matchsets.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=110831

Cc: <stable@vger.kernel.org> [3.17+]
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 9a15642..ea1e177 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1298,6 +1298,10 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 		return -EBUSY;
 	}
 
+	/* we don't support "match all" in the firmware */
+	if (!req->n_match_sets)
+		return -EOPNOTSUPP;
+
 	ret = iwl_mvm_check_running_scans(mvm, type);
 	if (ret)
 		return ret;
-- 
2.5.0

