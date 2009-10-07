Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33190 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758615AbZJGBTs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 21:19:48 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, vasanth@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 5/6] ath9k: move ath_cleanup() below helpers to avoid forward declarations
Date: Tue,  6 Oct 2009 21:19:10 -0400
Message-Id: <1254878351-32433-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1254878351-32433-1-git-send-email-lrodriguez@atheros.com>
References: <1254878351-32433-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

Reported-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   31 ++++++++++++++-----------------
 1 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 39b2780..c541516 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1313,23 +1313,6 @@ static void ath_start_rfkill_poll(struct ath_softc *sc)
 		wiphy_rfkill_start_polling(sc->hw->wiphy);
 }
 
-static void ath_clean_core(struct ath_softc *sc);
-static void ath9k_uninit_hw(struct ath_softc *sc);
-
-void ath_cleanup(struct ath_softc *sc)
-{
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	ath_clean_core(sc);
-	free_irq(sc->irq, sc);
-	ath_bus_cleanup(common);
-	kfree(sc->sec_wiphy);
-	ieee80211_free_hw(sc->hw);
-
-	ath9k_uninit_hw(sc);
-}
-
 static void ath9k_uninit_hw(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -1388,6 +1371,20 @@ void ath_detach(struct ath_softc *sc)
 	ath9k_uninit_hw(sc);
 }
 
+void ath_cleanup(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	ath_clean_core(sc);
+	free_irq(sc->irq, sc);
+	ath_bus_cleanup(common);
+	kfree(sc->sec_wiphy);
+	ieee80211_free_hw(sc->hw);
+
+	ath9k_uninit_hw(sc);
+}
+
 static int ath9k_reg_notifier(struct wiphy *wiphy,
 			      struct regulatory_request *request)
 {
-- 
1.6.0.4

