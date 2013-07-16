Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:42644 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab3GPHjI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 03:39:08 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 03/10] ath10k: allow deferred regd update
Date: Tue, 16 Jul 2013 09:38:52 +0200
Message-ID: <1373960339-8525-4-git-send-email-michal.kazior@tieto.com> (sfid-20130716_093917_384006_1632A0EA)
In-Reply-To: <1373960339-8525-1-git-send-email-michal.kazior@tieto.com>
References: <1371041642-20273-1-git-send-email-michal.kazior@tieto.com>
 <1373960339-8525-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Regulatory domain notification hook can be called
regardless of the hw state (i.e. before start
mac80211 callback).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |    7 +++++++
 drivers/net/wireless/ath/ath10k/mac.c  |   26 +++++++++++++++++++-------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 5a0b2ce..d5b2533 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -247,6 +247,11 @@ struct ath10k_debug {
 	struct completion event_stats_compl;
 };
 
+enum ath10k_state {
+	ATH10K_STATE_OFF = 0,
+	ATH10K_STATE_ON,
+};
+
 struct ath10k {
 	struct ath_common ath_common;
 	struct ieee80211_hw *hw;
@@ -344,6 +349,8 @@ struct ath10k {
 	struct completion offchan_tx_completed;
 	struct sk_buff *offchan_tx_skb;
 
+	enum ath10k_state state;
+
 #ifdef CONFIG_ATH10K_DEBUGFS
 	struct ath10k_debug debug;
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5082503..4627c16 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1310,23 +1310,19 @@ static int ath10k_update_channel_list(struct ath10k *ar)
 	return ret;
 }
 
-static void ath10k_reg_notifier(struct wiphy *wiphy,
-				struct regulatory_request *request)
+static void ath10k_regd_update(struct ath10k *ar)
 {
-	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct reg_dmn_pair_mapping *regpair;
-	struct ath10k *ar = hw->priv;
 	int ret;
 
-	mutex_lock(&ar->conf_mutex);
-
-	ath_reg_notifier_apply(wiphy, request, &ar->ath_common.regulatory);
+	lockdep_assert_held(&ar->conf_mutex);
 
 	ret = ath10k_update_channel_list(ar);
 	if (ret)
 		ath10k_warn("could not update channel list (%d)\n", ret);
 
 	regpair = ar->ath_common.regulatory.regpair;
+
 	/* Target allows setting up per-band regdomain but ath_common provides
 	 * a combined one only */
 	ret = ath10k_wmi_pdev_set_regdomain(ar,
@@ -1337,7 +1333,19 @@ static void ath10k_reg_notifier(struct wiphy *wiphy,
 					    regpair->reg_5ghz_ctl);
 	if (ret)
 		ath10k_warn("could not set pdev regdomain (%d)\n", ret);
+}
 
+static void ath10k_reg_notifier(struct wiphy *wiphy,
+				struct regulatory_request *request)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct ath10k *ar = hw->priv;
+
+	ath_reg_notifier_apply(wiphy, request, &ar->ath_common.regulatory);
+
+	mutex_lock(&ar->conf_mutex);
+	if (ar->state == ATH10K_STATE_ON)
+		ath10k_regd_update(ar);
 	mutex_unlock(&ar->conf_mutex);
 }
 
@@ -1732,6 +1740,9 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		ath10k_warn("could not init WMI_PDEV_PARAM_DYNAMIC_BW (%d)\n",
 			    ret);
 
+	ar->state = ATH10K_STATE_ON;
+	ath10k_regd_update(ar);
+
 	mutex_unlock(&ar->conf_mutex);
 	return 0;
 }
@@ -1742,6 +1753,7 @@ static void ath10k_stop(struct ieee80211_hw *hw)
 
 	mutex_lock(&ar->conf_mutex);
 	ath10k_offchan_tx_purge(ar);
+	ar->state = ATH10K_STATE_OFF;
 	mutex_unlock(&ar->conf_mutex);
 
 	cancel_work_sync(&ar->offchan_tx_work);
-- 
1.7.9.5

