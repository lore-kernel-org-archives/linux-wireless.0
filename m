Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58827 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab0ALMrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 07:47:39 -0500
Date: Tue, 12 Jan 2010 13:47:37 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 03/17] mwl8k: don't call SET_AID if we're not associated
Message-ID: <20100112124737.GS1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index f2c4524..67ee3da 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3261,9 +3261,9 @@ mwl8k_bss_info_changed_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	/*
 	 * Get the AP's legacy and MCS rates.
 	 */
-	ap_legacy_rates = 0;
 	if (vif->bss_conf.assoc) {
 		struct ieee80211_sta *ap;
+
 		rcu_read_lock();
 
 		ap = ieee80211_find_sta(vif, vif->bss_conf.bssid);
@@ -3301,8 +3301,9 @@ mwl8k_bss_info_changed_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			goto out;
 	}
 
-	if (((changed & BSS_CHANGED_ASSOC) && vif->bss_conf.assoc) ||
-	    (changed & (BSS_CHANGED_ERP_CTS_PROT | BSS_CHANGED_HT))) {
+	if (vif->bss_conf.assoc &&
+	    (changed & (BSS_CHANGED_ASSOC | BSS_CHANGED_ERP_CTS_PROT |
+			BSS_CHANGED_HT))) {
 		rc = mwl8k_cmd_set_aid(hw, vif, ap_legacy_rates);
 		if (rc)
 			goto out;
-- 
1.5.6.4
