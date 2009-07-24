Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23614 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbZGXSNS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 14:13:18 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 14/14] iwlagn: fix sparse warning when compiling without debug
Date: Fri, 24 Jul 2009 11:13:13 -0700
Message-Id: <1248459194-10239-15-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
References: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

C [M]  drivers/net/wireless/iwlwifi/iwl-core.o
drivers/net/wireless/iwlwifi/iwl-core.c:1341: warning:
‘iwl_dump_nic_error_log’ defined but not used

Reported-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index edfdbe8..b6db955 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1295,7 +1295,6 @@ static void iwl_print_rx_config_cmd(struct iwl_priv *priv)
 	IWL_DEBUG_RADIO(priv, "u8[6] bssid_addr: %pM\n", rxon->bssid_addr);
 	IWL_DEBUG_RADIO(priv, "u16 assoc_id: 0x%x\n", le16_to_cpu(rxon->assoc_id));
 }
-#endif
 
 static const char *desc_lookup_text[] = {
 	"OK",
@@ -1500,6 +1499,7 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv)
 	iwl_print_event_log(priv, 0, next_entry, mode);
 
 }
+#endif
 /**
  * iwl_irq_handle_error - called for HW or SW error interrupt from card
  */
-- 
1.5.6.3

