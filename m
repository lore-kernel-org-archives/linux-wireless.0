Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:7737 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751449AbYJXGsm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 02:48:42 -0400
From: Reinette Chatre <reinette.chatre@linux.intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/10] iwlwifi: clear scanning bits upon failure
Date: Thu, 23 Oct 2008 23:48:54 -0700
Message-Id: <1224830938-1577-7-git-send-email-reinette.chatre@linux.intel.com> (sfid-20081024_084855_730047_70FF8C5D)
In-Reply-To: <1224830938-1577-6-git-send-email-reinette.chatre@linux.intel.com>
References: <>
 <1224830938-1577-1-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-2-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-3-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-4-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-5-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-6-git-send-email-reinette.chatre@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

In iwl_bg_request_scan function, if we could not send a
scan command it will go to done.
In done it does the right thing to call mac80211 with
scan complete, but the problem is STATUS_SCAN_HW is still
set causing any future scan to fail. Fix by clearing the scanning status
bits if scan fails.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 86b7457..8e262d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -873,6 +873,13 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	return;
 
  done:
+	/* Cannot perform scan. Make sure we clear scanning
+	* bits from status so next scan request can be performed.
+	* If we don't clear scanning status bit here all next scan
+	* will fail
+	*/
+	clear_bit(STATUS_SCAN_HW, &priv->status);
+	clear_bit(STATUS_SCANNING, &priv->status);
 	/* inform mac80211 scan aborted */
 	queue_work(priv->workqueue, &priv->scan_completed);
 	mutex_unlock(&priv->mutex);
-- 
1.5.4.3

