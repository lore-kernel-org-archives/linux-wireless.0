Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39826 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944AbYKDUVQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 15:21:16 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/3] iwl3945: clear scanning bits upon failure
Date: Tue,  4 Nov 2008 12:21:34 -0800
Message-Id: <1225830096-7052-2-git-send-email-reinette.chatre@intel.com> (sfid-20081104_212122_669617_7807CD82)
In-Reply-To: <1225830096-7052-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1225830096-7052-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

This patch ensures we clear any scan status bit when
an error occurs while sending the scan command. It is
the implementation of patch:
"iwlwifi: clear scanning bits upon failure"
for iwl3945.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Also applies to 2.6.28.

 drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 7222d7c..88465e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6213,6 +6213,14 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	return;
 
  done:
+	/* can not perform scan make sure we clear scanning
+	 * bits from status so next scan request can be performed.
+	 * if we dont clear scanning status bit here all next scan
+	 * will fail
+	*/
+	clear_bit(STATUS_SCAN_HW, &priv->status);
+	clear_bit(STATUS_SCANNING, &priv->status);
+
 	/* inform mac80211 scan aborted */
 	queue_work(priv->workqueue, &priv->scan_completed);
 	mutex_unlock(&priv->mutex);
-- 
1.5.4.3

