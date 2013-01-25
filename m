Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:52360 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755084Ab3AYK7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 05:59:21 -0500
Date: Fri, 25 Jan 2013 16:20:50 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 7/7] mwl8k: Do not call STA specific cmds not supported by
 the AP fw
Message-ID: <20130125105050.GA9514@markyou.marvell.com> (sfid-20130125_115924_764231_80810511)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While using STA mode in the AP firmware, avoid
calling some firmware commands which are not
supported by the AP firmware.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 5ca76c8..ee5c7ea 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4881,7 +4881,8 @@ mwl8k_bss_info_changed_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		rcu_read_unlock();
 	}
 
-	if ((changed & BSS_CHANGED_ASSOC) && vif->bss_conf.assoc) {
+	if ((changed & BSS_CHANGED_ASSOC) && vif->bss_conf.assoc &&
+	    !priv->ap_fw) {
 		rc = mwl8k_cmd_set_rate(hw, vif, ap_legacy_rates, ap_mcs_rates);
 		if (rc)
 			goto out;
@@ -4889,6 +4890,25 @@ mwl8k_bss_info_changed_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		rc = mwl8k_cmd_use_fixed_rate_sta(hw);
 		if (rc)
 			goto out;
+	} else {
+		if ((changed & BSS_CHANGED_ASSOC) && vif->bss_conf.assoc &&
+		    priv->ap_fw) {
+			int idx;
+			int rate;
+
+			/* Use AP firmware specific rate command.
+			 */
+			idx = ffs(vif->bss_conf.basic_rates);
+			if (idx)
+				idx--;
+
+			if (hw->conf.channel->band == IEEE80211_BAND_2GHZ)
+				rate = mwl8k_rates_24[idx].hw_value;
+			else
+				rate = mwl8k_rates_50[idx].hw_value;
+
+			mwl8k_cmd_use_fixed_rate_ap(hw, rate, rate);
+		}
 	}
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
@@ -4898,13 +4918,13 @@ mwl8k_bss_info_changed_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			goto out;
 	}
 
-	if (changed & BSS_CHANGED_ERP_SLOT) {
+	if ((changed & BSS_CHANGED_ERP_SLOT) && !priv->ap_fw)  {
 		rc = mwl8k_cmd_set_slot(hw, vif->bss_conf.use_short_slot);
 		if (rc)
 			goto out;
 	}
 
-	if (vif->bss_conf.assoc &&
+	if (vif->bss_conf.assoc && !priv->ap_fw &&
 	    (changed & (BSS_CHANGED_ASSOC | BSS_CHANGED_ERP_CTS_PROT |
 			BSS_CHANGED_HT))) {
 		rc = mwl8k_cmd_set_aid(hw, vif, ap_legacy_rates);
-- 
1.8.0.3

