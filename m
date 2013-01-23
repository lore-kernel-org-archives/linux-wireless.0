Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:59161 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab3AWKTe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 05:19:34 -0500
Received: by mail-bk0-f48.google.com with SMTP id jk14so1711255bkc.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 02:19:33 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org, Marco Porsch <marco@cozybit.com>
Subject: [RFC 3/3] ath9k: mesh powersave support
Date: Wed, 23 Jan 2013 11:19:20 +0100
Message-Id: <1358936360-7795-4-git-send-email-marco@cozybit.com> (sfid-20130123_111940_449840_CFA6867A)
In-Reply-To: <1358936360-7795-1-git-send-email-marco@cozybit.com>
References: <1358936360-7795-1-git-send-email-marco@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Register mesh PS ops on interface add and de-register on
removal.

When enabling mesh PS, do not enable the hardware's TIM timer
interrupt.

React to mac80211 doze/wakeup calls.
Add a PS status flag PS_MAC80211_CTL to store last mesh PS
command from mac80211.

Signed-off-by: Marco Porsch <marco@cozybit.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |   46 +++++++++++++++++++++++++++++---
 2 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8250330..f11c210 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -651,6 +651,7 @@ enum sc_op_flags {
 #define PS_WAIT_FOR_TX_ACK        BIT(3)
 #define PS_BEACON_SYNC            BIT(4)
 #define PS_WAIT_FOR_ANI           BIT(5)
+#define PS_MAC80211_CTL           BIT(6)
 
 struct ath_rate_table;
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 0fb53d6..2929808 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -132,7 +132,8 @@ void ath9k_ps_restore(struct ath_softc *sc)
 				     PS_WAIT_FOR_CAB |
 				     PS_WAIT_FOR_PSPOLL_DATA |
 				     PS_WAIT_FOR_TX_ACK |
-				     PS_WAIT_FOR_ANI))) {
+				     PS_WAIT_FOR_ANI |
+				     PS_MAC80211_CTL))) {
 		mode = ATH9K_PM_NETWORK_SLEEP;
 		if (ath9k_hw_btcoex_is_enabled(sc->sc_ah))
 			ath9k_btcoex_stop_gen_timer(sc);
@@ -824,6 +825,38 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	ath_dbg(common, CONFIG, "Driver halt\n");
 }
 
+static void ath9k_mesh_doze(struct ieee80211_hw *hw)
+{
+	struct ath_softc *sc = hw->priv;
+	unsigned long flags;
+
+	ath9k_ps_wakeup(sc);
+	spin_lock_irqsave(&sc->sc_pm_lock, flags);
+	/* in mesh mode mac80211 checks beacons and CAB */
+	sc->ps_flags &= ~(PS_WAIT_FOR_BEACON |
+			  PS_WAIT_FOR_CAB |
+			  PS_MAC80211_CTL);
+	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+	ath9k_ps_restore(sc);
+}
+
+static void ath9k_mesh_wakeup(struct ieee80211_hw *hw)
+{
+	struct ath_softc *sc = hw->priv;
+	unsigned long flags;
+
+	ath9k_ps_wakeup(sc);
+	spin_lock_irqsave(&sc->sc_pm_lock, flags);
+	sc->ps_flags |= PS_MAC80211_CTL;
+	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+	ath9k_ps_restore(sc);
+}
+
+static const struct ieee80211_mps_ops ath9k_mesh_ps_ops = {
+	.hw_doze = ath9k_mesh_doze,
+	.hw_wakeup = ath9k_mesh_wakeup,
+};
+
 bool ath9k_uses_beacons(int type)
 {
 	switch (type) {
@@ -934,6 +967,11 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 			ah->opmode = NL80211_IFTYPE_ADHOC;
 		else
 			ah->opmode = NL80211_IFTYPE_STATION;
+
+		if (ah->opmode == NL80211_IFTYPE_MESH_POINT)
+			ieee80211_mps_init(hw, &ath9k_mesh_ps_ops);
+		else if (old_opmode == NL80211_IFTYPE_MESH_POINT)
+			ieee80211_mps_init(hw, NULL);
 	}
 
 	ath9k_hw_setopmode(ah);
@@ -1037,7 +1075,9 @@ static void ath9k_enable_ps(struct ath_softc *sc)
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	sc->ps_enabled = true;
-	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
+	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP) &&
+	    sc->sc_ah->opmode != NL80211_IFTYPE_MESH_POINT) {
+		/* in mesh mode we trigger wakeups from mac80211 */
 		if ((ah->imask & ATH9K_INT_TIM_TIMER) == 0) {
 			ah->imask |= ATH9K_INT_TIM_TIMER;
 			ath9k_hw_set_interrupts(ah);
@@ -1178,7 +1218,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	 * We just prepare to enable PS. We have to wait until our AP has
 	 * ACK'd our null data frame to disable RX otherwise we'll ignore
 	 * those ACKs and end up retransmitting the same null data frames.
-	 * IEEE80211_CONF_CHANGE_PS is only passed by mac80211 for STA mode.
+	 * IEEE80211_CONF_CHANGE_PS is passed by mac80211 for STA or mesh mode.
 	 */
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		unsigned long flags;
-- 
1.7.9.5

