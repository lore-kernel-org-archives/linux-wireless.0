Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:62122 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920AbbLAKAI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 05:00:08 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Derek Basehore <dbasehore@chromium.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 38/41] iwlwifi: mvm: report wakeup for wowlan
Date: Tue,  1 Dec 2015 11:59:04 +0200
Message-Id: <1448963947-24302-38-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110014_192010_36979301)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Derek Basehore <dbasehore@chromium.org>

When the wifi wakes up the system, we need to report it via calling
pm_wakeup_event for lucid sleep. This is so userspace knowns that the
wifi woke up the system via the /sys/power/wakeup_type sysfs interface.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 478cf82..9e51843 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1236,6 +1236,8 @@ static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
 		goto report;
 	}
 
+	pm_wakeup_event(mvm->dev, 0);
+
 	if (reasons & IWL_WOWLAN_WAKEUP_BY_MAGIC_PACKET)
 		wakeup.magic_pkt = true;
 
-- 
2.5.0

