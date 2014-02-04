Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:42825 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaBDDIe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 22:08:34 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	stable@vger.kernel.org
Subject: [PATCH 2/3] ath9k: Do not support PowerSave by default
Date: Tue,  4 Feb 2014 08:37:53 +0530
Message-Id: <1391483274-20331-3-git-send-email-sujith@msujith.org> (sfid-20140204_040841_741809_140FC24E)
In-Reply-To: <1391483274-20331-1-git-send-email-sujith@msujith.org>
References: <1391483274-20331-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Even though we make sure PowerSave is not enabled by default
by disabling the flag, WIPHY_FLAG_PS_ON_BY_DEFAULT on init,
PS could be enabled by userspace based on various factors
like battery usage etc. Since PS in ath9k is just broken
and has been untested for years, remove support for it, but
allow a user to explicitly enable it using a module parameter.

Cc: stable@vger.kernel.org
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c36de30..1fc2e5a 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -57,6 +57,10 @@ static int ath9k_bt_ant_diversity;
 module_param_named(bt_ant_diversity, ath9k_bt_ant_diversity, int, 0444);
 MODULE_PARM_DESC(bt_ant_diversity, "Enable WLAN/BT RX antenna diversity");
 
+static int ath9k_ps_enable;
+module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
+MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
+
 bool is_ath9k_unloaded;
 /* We use the hw_value as an index into our private channel structure */
 
@@ -903,13 +907,15 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_PS_NULLFUNC_STACK |
 		IEEE80211_HW_SPECTRUM_MGMT |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		IEEE80211_HW_SUPPORTS_RC_TABLE |
 		IEEE80211_HW_SUPPORTS_HT_CCK_RATES;
 
+	if (ath9k_ps_enable)
+		hw->flags |= IEEE80211_HW_SUPPORTS_PS;
+
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
 		hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
 
-- 
1.8.5.3

