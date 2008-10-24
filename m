Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:59900 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751542AbYJXGso (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 02:48:44 -0400
From: Reinette Chatre <reinette.chatre@linux.intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Fabrice Bellet <fabrice@bellet.info>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/10] iwl3945: iwl3945_mac_get_tsf() should not return zero
Date: Thu, 23 Oct 2008 23:48:57 -0700
Message-Id: <1224830938-1577-10-git-send-email-reinette.chatre@linux.intel.com> (sfid-20081024_090856_776903_9C941B4B)
In-Reply-To: <1224830938-1577-9-git-send-email-reinette.chatre@linux.intel.com>
References: <>
 <1224830938-1577-1-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-2-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-3-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-4-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-5-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-6-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-7-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-8-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-9-git-send-email-reinette.chatre@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fabrice Bellet <fabrice@bellet.info>

The problem fixed here is that iwl3945_mac_get_tsf() returns 0, as the
function is not implemented, and this is considered as a valid value by
the mac layer in mlme.c:1605. The consequence is that the STA in ad-hoc
mode is inserted/removed quite frequently due to IBSS merging.

This patch fixes :
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1781
and https://bugzilla.redhat.com/show_bug.cgi?id=459401

Signed-off-by: Fabrice Bellet <fabrice@bellet.info>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 2870b61..813662f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -7209,14 +7209,6 @@ static int iwl3945_mac_get_stats(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static u64 iwl3945_mac_get_tsf(struct ieee80211_hw *hw)
-{
-	IWL_DEBUG_MAC80211("enter\n");
-	IWL_DEBUG_MAC80211("leave\n");
-
-	return 0;
-}
-
 static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 {
 	struct iwl3945_priv *priv = hw->priv;
@@ -7859,7 +7851,6 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.get_stats = iwl3945_mac_get_stats,
 	.get_tx_stats = iwl3945_mac_get_tx_stats,
 	.conf_tx = iwl3945_mac_conf_tx,
-	.get_tsf = iwl3945_mac_get_tsf,
 	.reset_tsf = iwl3945_mac_reset_tsf,
 	.bss_info_changed = iwl3945_bss_info_changed,
 	.hw_scan = iwl3945_mac_hw_scan
-- 
1.5.4.3

