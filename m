Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50549 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbbHXUAn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2015 16:00:43 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/6] iwlwifi: mvm: update wakeup reason enum
Date: Mon, 24 Aug 2015 23:00:33 +0300
Message-Id: <1440446437-29188-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150824_220046_461642_8702380F)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E827CB7@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E827CB7@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

when waking from d0i3 there is a wakeup reason.
Enum in driver is not up to date with FW api - fix it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
index d7658d1..20521be 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
@@ -339,8 +339,13 @@ enum iwl_wowlan_wakeup_reason {
 	IWL_WOWLAN_WAKEUP_BY_FOUR_WAY_HANDSHAKE			= BIT(8),
 	IWL_WOWLAN_WAKEUP_BY_REM_WAKE_LINK_LOSS			= BIT(9),
 	IWL_WOWLAN_WAKEUP_BY_REM_WAKE_SIGNATURE_TABLE		= BIT(10),
-	/* BIT(11) reserved */
+	IWL_WOWLAN_WAKEUP_BY_REM_WAKE_TCP_EXTERNAL		= BIT(11),
 	IWL_WOWLAN_WAKEUP_BY_REM_WAKE_WAKEUP_PACKET		= BIT(12),
+	IWL_WOWLAN_WAKEUP_BY_IOAC_MAGIC_PACKET			= BIT(13),
+	IWL_WOWLAN_WAKEUP_BY_D3_WAKEUP_HOST_TIMER		= BIT(14),
+	IWL_WOWLAN_WAKEUP_BY_RXFRAME_FILTERED_IN		= BIT(15),
+	IWL_WOWLAN_WAKEUP_BY_BEACON_FILTERED_IN			= BIT(16),
+
 }; /* WOWLAN_WAKE_UP_REASON_API_E_VER_2 */
 
 struct iwl_wowlan_gtk_status {
-- 
2.1.4

