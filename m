Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851AbZAWVmr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 16:42:47 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 01/15] iwlwifi: add test to determine if interface in monitor mode
Date: Fri, 23 Jan 2009 13:45:09 -0800
Message-Id: <1232747123-7261-2-git-send-email-reinette.chatre@intel.com> (sfid-20090123_224257_165350_9A65F3E5)
In-Reply-To: <1232747123-7261-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232747123-7261-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chatre, Reinette <reinette.chatre@intel.com>

mac80211 sets driver in monitor mode through configuring the
RX filters. We cannot trust priv->iw_mode to be accurate
regarding monitor mode as iw_mode is only set in add_interface,
which is not called by mac80211 when in monitor mode.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 9f284eb..ef4a7c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -699,6 +699,18 @@ static u8 iwl_count_chain_bitmap(u32 chain_bitmap)
 }
 
 /**
+ * iwl_is_monitor_mode - Determine if interface in monitor mode
+ *
+ * priv->iw_mode is set in add_interface, but add_interface is
+ * never called for monitor mode. The only way mac80211 informs us about
+ * monitor mode is through configuring filters (call to configure_filter).
+ */
+static bool iwl_is_monitor_mode(struct iwl_priv *priv)
+{
+	return !!(priv->staging_rxon.filter_flags & RXON_FILTER_PROMISC_MSK);
+}
+
+/**
  * iwl_set_rxon_chain - Set up Rx chain usage in "staging" RXON image
  *
  * Selects how many and which Rx receivers/antennas/chains to use.
-- 
1.5.4.3

