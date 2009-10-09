Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:18946 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761278AbZJIUWY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:22:24 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/17] iwlwifi: fix userspace setting of sleep_level_override
Date: Fri,  9 Oct 2009 13:20:25 -0700
Message-Id: <1255119634-3060-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

The sleep_level_override debugfs file is used by the user to request a
static power index instead of the dynamic sleep values. Users are expected
to provide value from 1 to 5 as an index or -1 to disable it.

The problem at the moment is that users can also provide 0 to this file
which, together with the value 1, is translated to index 1. This is
confusing and even more so when users write 0 to sleep_level_override and
then read 1 from it afterwards.

Modify checking to treat 0 as invalid.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 1794b9c..aa62357 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -801,7 +801,9 @@ static ssize_t iwl_dbgfs_sleep_level_override_write(struct file *file,
 	 * valid here. However, let's not confuse them and present
 	 * IWL_POWER_INDEX_1 as "1", not "0".
 	 */
-	if (value > 0)
+	if (value == 0)
+		return -EINVAL;
+	else if (value > 0)
 		value -= 1;
 
 	if (value != -1 && (value < 0 || value >= IWL_POWER_NUM))
-- 
1.5.6.3

