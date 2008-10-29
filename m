Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36487 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939AbYJ2VF2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 17:05:28 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 7/7] iwlwifi: do not call statistics from rfkill
Date: Wed, 29 Oct 2008 14:05:49 -0700
Message-Id: <1225314349-11139-8-git-send-email-reinette.chatre@intel.com> (sfid-20081029_220539_554603_F1978E45)
In-Reply-To: <1225314349-11139-7-git-send-email-reinette.chatre@intel.com>
References: <>
 <1225314349-11139-1-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-2-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-3-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-4-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-5-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-6-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 97b4329..ff6a18d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1154,6 +1154,10 @@ static void iwl_bg_statistics_periodic(unsigned long data)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
+	/* dont send host command if rf-kill is on */
+	if (!iwl_is_ready_rf(priv))
+		return;
+
 	iwl_send_statistics_request(priv, CMD_ASYNC);
 }
 
-- 
1.5.4.3

