Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51821 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbZJFDx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2009 23:53:58 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: vasanth@atheros.com, linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 2/4] ath9k: fix oops during unload -- initialize hw prior to debugfs
Date: Mon,  5 Oct 2009 23:53:19 -0400
Message-Id: <1254801201-15893-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1254801201-15893-1-git-send-email-lrodriguez@atheros.com>
References: <1254801201-15893-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

debugfs uses the hardware for several debugfs files as such the
hardware must be initialized and available prior to its usage. The
same applies to when we free the hw structs -- free debufs file
entries prior to free'ing the hardware.

This should fix the oops which occurs during module unload
due to the dereferencig of ah upon debugfs exit.

IP: [<46412d6b>] 0x46412d6b
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/class/power_supply/BAT0/energy_full
Modules linked in: ath9k(-) ath9k_hw mac80211 ath cfg80211 <bleh>

Pid: 3112, comm: rmmod Not tainted (2.6.32-rc2-wl #101) 9461DUU
EIP: 0060:[<46412d6b>] EFLAGS: 00010246 CPU: 0
EIP is at 0x46412d6b
EAX: f5870004 EBX: f6700d94 ECX: 00000000 EDX: c14313a7
ESI: f5870000 EDI: fb58ce70 EBP: f6661eb4 ESP: f6661ea8
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process rmmod (pid: 3112, ti=f6660000 task=f6579380 task.ti=f6660000)
Stack:
 fb57e5e5 f5ca5d50 fb58ce70 f6661ebc fb58629a f6661ec8 c11b715e f5ca5da8
<0> f6661ed8 c1223d98 f5ca5da8 f5ca5ddc f6661eec c1223e6f fb58ce70 fb58ce70
<0> c14958a0 f6661f00 c1222edb fb58ce70 fb58ce70 fb58cebc f6661f1c c12243c9
Call Trace:
 [<fb57e5e5>] ? ath_cleanup+0x35/0x50 [ath9k]
 [<fb58629a>] ? ath_pci_remove+0x1a/0x20 [ath9k]
 [<c11b715e>] ? pci_device_remove+0x1e/0x40
 [<c1223d98>] ? __device_release_driver+0x58/0xa0
 [<c1223e6f>] ? driver_detach+0x8f/0xa0
 [<c1222edb>] ? bus_remove_driver+0x7b/0xb0
 [<c12243c9>] ? driver_unregister+0x49/0x80
 [<c1158cf2>] ? sysfs_remove_file+0x12/0x20
 [<c11b73b5>] ? pci_unregister_driver+0x35/0x90
 [<fb586172>] ? ath_pci_exit+0x12/0x20 [ath9k]
 [<fb5883ec>] ? ath9k_exit+0x10/0x3d [ath9k]
 [<c131971d>] ? mutex_unlock+0xd/0x10
 [<c1088c0f>] ? sys_delete_module+0x16f/0x220
 [<c10e3d5d>] ? do_munmap+0x23d/0x290
 [<c11a629c>] ? trace_hardirqs_off_thunk+0xc/0x10
 [<c11a628c>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1003b41>] ? sysenter_exit+0xf/0x1a
 [<c1003b08>] ? sysenter_do_call+0x12/0x3c
Code:  Bad EIP value.
EIP: [<46412d6b>] 0x46412d6b SS:ESP 0068:f6661ea8
CR2: 0000000046412d6b
---[ end trace 847f3b05ff3dcb19 ]---

Reported-by: Vasanthakumar Thiagarajan" <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath.h        |    6 ++++++
 drivers/net/wireless/ath/ath9k/hw.c   |   11 ++++++++++-
 drivers/net/wireless/ath/ath9k/main.c |   28 ++++++++++++++--------------
 3 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index b6cd752..5e19a73 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -23,6 +23,11 @@
 
 static const u8 ath_bcast_mac[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
+enum ath_device_state {
+	ATH_HW_UNAVAILABLE,
+	ATH_HW_INITIALIZED,
+};
+
 struct reg_dmn_pair_mapping {
 	u16 regDmnEnum;
 	u16 reg_5ghz_ctl;
@@ -59,6 +64,7 @@ struct ath_common {
 	void *priv;
 	struct ieee80211_hw *hw;
 	int debug_mask;
+	enum ath_device_state state;
 
 	u16 cachelsz;
 	u16 curaid;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 692fd1d..cab17c6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -999,6 +999,8 @@ int ath9k_hw_init(struct ath_hw *ah)
 
 	ath9k_init_nfcal_hist_buffer(ah);
 
+	common->state = ATH_HW_INITIALIZED;
+
 	return 0;
 }
 
@@ -1239,11 +1241,18 @@ const char *ath9k_hw_probe(u16 vendorid, u16 devid)
 
 void ath9k_hw_detach(struct ath_hw *ah)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (common->state <= ATH_HW_INITIALIZED)
+		goto free_hw;
+
 	if (!AR_SREV_9100(ah))
 		ath9k_hw_ani_disable(ah);
 
-	ath9k_hw_rf_free(ah);
 	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
+
+free_hw:
+	ath9k_hw_rf_free(ah);
 	kfree(ah);
 	ah = NULL;
 }
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7f90cb8..0fe915a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1365,8 +1365,8 @@ void ath_detach(struct ath_softc *sc)
 	    ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 		ath_gen_timer_free(ah, sc->btcoex.no_stomp_timer);
 
-	ath9k_hw_detach(ah);
 	ath9k_exit_debug(ah);
+	ath9k_hw_detach(ah);
 	sc->sc_ah = NULL;
 }
 
@@ -1626,10 +1626,8 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 		     (unsigned long)sc);
 
 	ah = kzalloc(sizeof(struct ath_hw), GFP_KERNEL);
-	if (!ah) {
-		r = -ENOMEM;
-		goto bad_no_ah;
-	}
+	if (!ah)
+		return -ENOMEM;
 
 	ah->hw_version.devid = devid;
 	ah->hw_version.subsysid = subsysid;
@@ -1651,15 +1649,18 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	/* XXX assert csz is non-zero */
 	common->cachelsz = csz << 2;	/* convert to bytes */
 
-	if (ath9k_init_debug(ah) < 0)
-		dev_err(sc->dev, "Unable to create debugfs files\n");
-
 	r = ath9k_hw_init(ah);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to initialize hardware; "
 			  "initialization status: %d\n", r);
-		goto bad;
+		goto bad_free_hw;
+	}
+
+	if (ath9k_init_debug(ah) < 0) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to create debugfs files\n");
+		goto bad_free_hw;
 	}
 
 	/* Get the hardware key cache size. */
@@ -1848,12 +1849,11 @@ bad2:
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
-bad:
+
+	ath9k_exit_debug(ah);
+bad_free_hw:
 	ath9k_hw_detach(ah);
-bad_no_ah:
-	ath9k_exit_debug(sc->sc_ah);
 	sc->sc_ah = NULL;
-
 	return r;
 }
 
@@ -1966,8 +1966,8 @@ error_attach:
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 
-	ath9k_hw_detach(ah);
 	ath9k_exit_debug(ah);
+	ath9k_hw_detach(ah);
 	sc->sc_ah = NULL;
 
 	return error;
-- 
1.6.0.4

