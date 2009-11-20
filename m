Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42088 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbZKTUFK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:10 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 15/19] iwlwifi: Tell the ucode immediately when association state changes
Date: Fri, 20 Nov 2009 12:05:06 -0800
Message-Id: <1258747510-21233-16-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
References: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@intel.com>

When we get a state change of associated or not, we need to tell the
ucode via the RX_ON command using the filter flags.  This will prevent
the ucode from sending any packets when not associated, specifically not
sending NULL QOS packets after a deauthentication which causes the AP to
repeatedly send deauth's in some situations.

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b62267e..159d555 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2479,6 +2479,16 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 		} else {
 			priv->assoc_id = 0;
 			iwl_led_disassociate(priv);
+
+			/*
+			 * inform the ucode that there is no longer an
+			 * association and that no more packets should be
+			 * send
+			 */
+			priv->staging_rxon.filter_flags &=
+				~RXON_FILTER_ASSOC_MSK;
+			priv->staging_rxon.assoc_id = 0;
+			iwlcore_commit_rxon(priv);
 		}
 	}
 
-- 
1.5.6.3

