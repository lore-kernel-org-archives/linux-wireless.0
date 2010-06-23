Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16909 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab0FWNtp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 09:49:45 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 23 Jun 2010 06:49:45 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Fix bug in starting ani
Date: Wed, 23 Jun 2010 06:49:21 -0700
Message-ID: <1277300961-4173-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are few places where ANI is started without checking
if it is right to start. This might lead to a case where ani
timer would be left undeleted and cause improper memory acccess
during module unload. This bug is clearly exposed with
paprd support where the driver detects tx hang and does a
chip reset. During this reset ani is (re)started without checking
if it needs to be started. This would leave a timer scheduled
even after all the resources are freed and cause a panic.

This patch introduces a bit in sc_flags to indicate if ani
needs to be started in sw_scan_start() and ath_reset().
This would fix the following panic. This issue is easily seen
with ar9003 + paprd.

 BUG: unable to handle kernel paging request at 0000000000003f38
[<ffffffff81075391>] ? __queue_work+0x41/0x50
[<ffffffff8106afaa>] run_timer_softirq+0x17a/0x370
[<ffffffff81088be8>] ? tick_dev_program_event+0x48/0x110
[<ffffffff81061f69>] __do_softirq+0xb9/0x1f0
[<ffffffff810ba060>] ? handle_IRQ_event+0x50/0x160
[<ffffffff8100af5c>] call_softirq+0x1c/0x30
[<ffffffff8100c9f5>] do_softirq+0x65/0xa0
[<ffffffff81061e25>] irq_exit+0x85/0x90
[<ffffffff8155e095>] do_IRQ+0x75/0xf0
[<ffffffff815570d3>] ret_from_intr+0x0/0x11
<EOI>
[<ffffffff812fd67b>] ? acpi_idle_enter_simple+0xe4/0x119
[<ffffffff812fd674>] ? acpi_idle_enter_simple+0xdd/0x119
[<ffffffff81441c87>] cpuidle_idle_call+0xa7/0x140
[<ffffffff81008da3>] cpu_idle+0xb3/0x110
[<ffffffff81550722>] start_secondary+0x1ee/0x1f5

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |   11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 3a14630..6218890 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -516,6 +516,7 @@ void ath_deinit_leds(struct ath_softc *sc);
 #define SC_OP_TSF_RESET              BIT(11)
 #define SC_OP_BT_PRIORITY_DETECTED   BIT(12)
 #define SC_OP_BT_SCAN		     BIT(13)
+#define SC_OP_ANI_RUN		     BIT(14)
 
 /* Powersave flags */
 #define PS_WAIT_FOR_BEACON        BIT(0)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5af2596..41a317d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -451,6 +451,10 @@ static void ath_start_ani(struct ath_common *common)
 {
 	struct ath_hw *ah = common->ah;
 	unsigned long timestamp = jiffies_to_msecs(jiffies);
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
+
+	if (!(sc->sc_flags & SC_OP_ANI_RUN))
+		return;
 
 	common->ani.longcal_timer = timestamp;
 	common->ani.shortcal_timer = timestamp;
@@ -766,11 +770,13 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		/* Reset rssi stats */
 		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
 
+		sc->sc_flags |= SC_OP_ANI_RUN;
 		ath_start_ani(common);
 	} else {
 		ath_print(common, ATH_DBG_CONFIG, "Bss Info DISASSOC\n");
 		common->curaid = 0;
 		/* Stop ANI */
+		sc->sc_flags &= ~SC_OP_ANI_RUN;
 		del_timer_sync(&common->ani.timer);
 	}
 }
@@ -1376,8 +1382,10 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 
 	if (vif->type == NL80211_IFTYPE_AP    ||
 	    vif->type == NL80211_IFTYPE_ADHOC ||
-	    vif->type == NL80211_IFTYPE_MONITOR)
+	    vif->type == NL80211_IFTYPE_MONITOR) {
+		sc->sc_flags |= SC_OP_ANI_RUN;
 		ath_start_ani(common);
+	}
 
 out:
 	mutex_unlock(&sc->mutex);
@@ -1398,6 +1406,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	mutex_lock(&sc->mutex);
 
 	/* Stop ANI */
+	sc->sc_flags &= ~SC_OP_ANI_RUN;
 	del_timer_sync(&common->ani.timer);
 
 	/* Reclaim beacon resources */
-- 
1.7.0.4

