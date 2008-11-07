Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61438 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbYKGR6R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 12:58:17 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/13] iwl3945 : Fix Sparse Warnings
Date: Fri,  7 Nov 2008 09:58:42 -0800
Message-Id: <1226080726-24860-10-git-send-email-reinette.chatre@intel.com> (sfid-20081107_185826_611934_3A1E5485)
In-Reply-To: <1226080726-24860-9-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-2-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-3-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-4-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-5-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-6-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-7-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-8-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kolekar, Abhijeet <abhijeet.kolekar@intel.com>

Patch fixes sparse warnings. No need to convert u8 variable
to 32.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 3e4c652..51f1c81 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4751,7 +4751,7 @@ static void iwl3945_free_channel_map(struct iwl3945_priv *priv)
 #define IWL_PASSIVE_DWELL_BASE      (100)
 #define IWL_CHANNEL_TUNE_TIME       5
 
-#define IWL_SCAN_PROBE_MASK(n)	 cpu_to_le32((BIT(n) | (BIT(n) - BIT(1))))
+#define IWL_SCAN_PROBE_MASK(n)	 (BIT(n) | (BIT(n) - BIT(1)))
 
 static inline u16 iwl3945_get_active_dwell_time(struct iwl3945_priv *priv,
 						enum ieee80211_band band,
-- 
1.5.4.3

