Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58303 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510Ab1KRBAa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 20:00:30 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 5/5] iwlwifi: remove redundancy
Date: Thu, 17 Nov 2011 16:05:13 -0800
Message-Id: <1321574713-12076-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111118_020038_799820_754C22B0)
In-Reply-To: <1321574713-12076-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1321574713-12076-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

just use iwl_bus, remove the redundancy

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 3ffa8e6..3464cad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -143,7 +143,7 @@ u32 iwl_read_direct32(struct iwl_bus *bus, u32 reg)
 
 	spin_lock_irqsave(&bus->reg_lock, flags);
 	iwl_grab_nic_access(bus);
-	value = iwl_read32(bus(bus), reg);
+	value = iwl_read32(bus, reg);
 	iwl_release_nic_access(bus);
 	spin_unlock_irqrestore(&bus->reg_lock, flags);
 
-- 
1.7.0.4

