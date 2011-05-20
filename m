Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1556 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935694Ab1ETTWe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 15:22:34 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, randy.dunlap@oracle.com,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH wireless-2.6.40] iwlagn: dbg_fixed_rate only used when CONFIG_MAC80211_DEBUGFS enabled
Date: Fri, 20 May 2011 11:56:18 -0700
Message-Id: <1305917778-15303-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110520_212238_650002_56E953A3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix compiling error when CONFIG_MAC80211_DEBUGFS is not enabled
drivers/net/wireless/iwlwifi/iwl-agn-rs.c:351: error: 'struct iwl_lq_sta' has no member named 'dbg_fixed_rate'
drivers/net/wireless/iwlwifi/iwl-agn-rs.c:1076: error: 'struct iwl_lq_sta' has no member named 'dbg_fixed_rate'

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
these patches are also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index f95c0a4..2f661df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -334,7 +334,7 @@ static u8 rs_tl_add_packet(struct iwl_lq_sta *lq_data,
 	return tid;
 }
 
-#if defined(CONFIG_MAC80211_DEBUGFS) || defined(CONFIG_IWLWIFI_DEVICE_SVTOOL)
+#ifdef CONFIG_MAC80211_DEBUGFS
 static void rs_program_fix_rate(struct iwl_priv *priv,
 				struct iwl_lq_sta *lq_sta)
 {
@@ -1071,7 +1071,7 @@ done:
 	/* See if there's a better rate or modulation mode to try. */
 	if (sta && sta->supp_rates[sband->band])
 		rs_rate_scale_perform(priv, skb, sta, lq_sta);
-#ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
+#ifdef CONFIG_MAC80211_DEBUGFS
 	if (priv->dbg_fixed_rate != lq_sta->dbg_fixed_rate)
 		rs_program_fix_rate(priv, lq_sta);
 #endif
-- 
1.7.0.4

