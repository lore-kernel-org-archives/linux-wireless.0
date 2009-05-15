Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50173 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbZEOXHM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 19:07:12 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/3] iwlwifi: drop iwl3945_tid_data
Date: Fri, 15 May 2009 16:13:44 -0700
Message-Id: <1242429226-8313-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1242429226-8313-2-git-send-email-reinette.chatre@intel.com>
References: <1242429226-8313-1-git-send-email-reinette.chatre@intel.com>
 <1242429226-8313-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch is one of the incremental steps for unifying iwl_station_entry
for all HWs, i.e. removing of iwl3945_station_entry
This patch drops iwl3945_tid_data and use iwl_tid_data instead.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 427489a..b6b8327 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -499,14 +499,10 @@ struct iwl_qos_info {
 #define STA_PS_STATUS_WAKE             0
 #define STA_PS_STATUS_SLEEP            1
 
-struct iwl3945_tid_data {
-	u16 seq_number;
-};
-
 
 struct iwl3945_station_entry {
 	struct iwl3945_addsta_cmd sta;
-	struct iwl3945_tid_data tid[MAX_TID_COUNT];
+	struct iwl_tid_data tid[MAX_TID_COUNT];
 	u8 used;
 	u8 ps_status;
 	struct iwl_hw_key keyinfo;
-- 
1.5.6.3

