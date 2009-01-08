Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18869 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871AbZAHSSZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 13:18:25 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <sameo@linux.intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/11] iwlwifi: Fix get_cmd_string() for REPLY_3945_RX
Date: Thu,  8 Jan 2009 10:20:00 -0800
Message-Id: <1231438802-10991-10-git-send-email-reinette.chatre@intel.com> (sfid-20090108_191839_397749_FD87231F)
In-Reply-To: <1231438802-10991-9-git-send-email-reinette.chatre@intel.com>
References: <>
 <1231438802-10991-1-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-2-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-3-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-4-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-5-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-6-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-7-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-8-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

0x1b is a 3945 specific command, we should print it too when debugging.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-hcmd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index c35805c..af14d8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -51,6 +51,7 @@ const char *get_cmd_string(u8 cmd)
 		IWL_CMD(REPLY_REMOVE_STA);
 		IWL_CMD(REPLY_REMOVE_ALL_STA);
 		IWL_CMD(REPLY_WEPKEY);
+		IWL_CMD(REPLY_3945_RX);
 		IWL_CMD(REPLY_TX);
 		IWL_CMD(REPLY_RATE_SCALE);
 		IWL_CMD(REPLY_LEDS_CMD);
-- 
1.5.4.3

