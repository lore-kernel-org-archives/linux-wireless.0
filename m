Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58526 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab0H1HNL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Aug 2010 03:13:11 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, amod.bodas@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 3/3] ath9k: implement the sw scan wait constraints
Date: Sat, 28 Aug 2010 03:13:10 -0400
Message-Id: <1282979590-31113-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
References: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When mac80211 sw scan is triggered this will inform mac80211
to take us to the home channel if we are aware of some
time constraints for scanning. This ensures ath9k will not
loose buffered broadcast and multicast frames when scanning.

Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |   69 ++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f0197a6..89bbcd0 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -588,6 +588,7 @@ struct ath_softc {
 	int led_off_cnt;
 
 	int beacon_interval;
+	u32 scan_wait_counter;
 
 #ifdef CONFIG_ATH9K_DEBUGFS
 	struct ath9k_debug debug;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1165f90..181edea 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2043,6 +2043,74 @@ static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 	mutex_unlock(&sc->mutex);
 }
 
+static void ath9k_ps_flags_dbg(struct ath_softc *sc)
+{
+#define ATH9K_WAIT_DBG(_reason) do { \
+	if (sc->ps_flags & _reason) \
+		ath_print(common, ATH_DBG_PS, \
+			  "  %s\n", #_reason); \
+	} while (0)
+
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	ath_print(common, ATH_DBG_PS, "PS flags:\n");
+
+	ATH9K_WAIT_DBG(PS_WAIT_FOR_BEACON);
+	ATH9K_WAIT_DBG(PS_WAIT_FOR_CAB);
+	ATH9K_WAIT_DBG(PS_WAIT_FOR_PSPOLL_DATA);
+	ATH9K_WAIT_DBG(PS_WAIT_FOR_TX_ACK);
+	ATH9K_WAIT_DBG(PS_BEACON_SYNC);
+	ATH9K_WAIT_DBG(PS_NULLFUNC_COMPLETED);
+	ATH9K_WAIT_DBG(PS_ENABLED);
+
+#undef ATH9K_WAIT_DBG
+}
+
+/*
+ * We expect to be disassociated if the counter gets too high.
+ */
+static int ath9k_sw_scan_wait_constraints(struct ieee80211_hw *hw)
+{
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	int r = 0;
+	u32 wait_for;
+
+	mutex_lock(&sc->mutex);
+
+	wait_for = PS_WAIT_FOR_BEACON |
+		   PS_BEACON_SYNC |
+		   PS_WAIT_FOR_CAB |
+		   PS_WAIT_FOR_PSPOLL_DATA |
+		   PS_WAIT_FOR_TX_ACK |
+		   PS_NULLFUNC_COMPLETED;
+
+	if (sc->ps_flags & wait_for) {
+		sc->scan_wait_counter++;
+		ath_print(common, ATH_DBG_PS,
+			  "Holding on channel change due to a "
+			  "wait constraint, count: %d, ps_flags: 0x%04x\n",
+			  sc->scan_wait_counter,
+			  sc->ps_flags);
+		ath9k_ps_flags_dbg(sc);
+		if (sc->ps_flags & PS_NULLFUNC_COMPLETED)
+			r = -EAGAIN;
+		else
+			r = -EBUSY;
+		goto out;
+	}
+
+	sc->scan_wait_counter = 0;
+	ath_print(common, ATH_DBG_PS,
+		  "No scan wait contraints found, ps_flags: 0x%04x\n",
+		   sc->ps_flags);
+out:
+	mutex_unlock(&sc->mutex);
+
+	return r;
+}
+
 /*
  * XXX: this requires a revisit after the driver
  * scan_complete gets moved to another place/removed in mac80211.
@@ -2089,6 +2157,7 @@ struct ieee80211_ops ath9k_ops = {
 	.ampdu_action       = ath9k_ampdu_action,
 	.get_survey	    = ath9k_get_survey,
 	.sw_scan_start      = ath9k_sw_scan_start,
+	.sw_scan_wait_constraints = ath9k_sw_scan_wait_constraints,
 	.sw_scan_complete   = ath9k_sw_scan_complete,
 	.rfkill_poll        = ath9k_rfkill_poll_state,
 	.set_coverage_class = ath9k_set_coverage_class,
-- 
1.7.0.4

