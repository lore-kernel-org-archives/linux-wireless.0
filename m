Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:1264 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab3FXNTk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 09:19:40 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.9 1/4] iwlwifi: mvm: adjust firmware D3 configuration API
Date: Mon, 24 Jun 2013 16:19:02 +0300
Message-Id: <1372079945-7445-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130624_152122_116803_CA5CB0ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

commit dfcb4c3aacedee6838e436fb575b31e138505203 upstream.

The D3 firmware API changed to include a new field, adjust
the driver to it to avoid getting an NMI when configuring.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
index cf6f9a0..937665f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
@@ -75,13 +75,15 @@ enum iwl_d3_wakeup_flags {
  * struct iwl_d3_manager_config - D3 manager configuration command
  * @min_sleep_time: minimum sleep time (in usec)
  * @wakeup_flags: wakeup flags, see &enum iwl_d3_wakeup_flags
+ * @wakeup_host_timer: force wakeup after this many seconds
  *
  * The structure is used for the D3_CONFIG_CMD command.
  */
 struct iwl_d3_manager_config {
 	__le32 min_sleep_time;
 	__le32 wakeup_flags;
-} __packed; /* D3_MANAGER_CONFIG_CMD_S_VER_3 */
+	__le32 wakeup_host_timer;
+} __packed; /* D3_MANAGER_CONFIG_CMD_S_VER_4 */
 
 
 /* TODO: OFFLOADS_QUERY_API_S_VER_1 */
-- 
1.7.10.4

