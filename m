Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56394 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0INOMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 10:12:23 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>
Subject: [PATCH 01/10] ath9k: fix power save race conditions
Date: Tue, 14 Sep 2010 10:12:23 -0400
Message-Id: <1284473543-7847-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k has a race on putting the chip into network sleep and
having registers read from hardware. The race occurs because
although ath9k_ps_restore() locks its own callers it makes use
of some variables which get altered in the driver at different
code paths. The variables are the ps_enabled and ps_flags.

This is easily reprodicible in large network environments when
roaming with the wpa_supplicant simple bgscan. You'd get some
0xdeadbeef read out on certain registers such as:

ath: timeout (100000 us) on reg 0x806c: 0xdeadbeef & 0x01f00000 != 0x00000000
ath: RX failed to go idle in 10 ms RXSM=0xdeadbeef

ath: timeout (100000 us) on reg 0x7000: 0xdeadbeef & 0x00000003 != 0x00000000
ath: Chip reset failed

The fix is to protect the ath9k_config(hw, IEEE80211_CONF_CHANGE_PS)
calls with a spin_lock_irqsave() which will disable contendors for
these variables from interrupt context, timers, re-entry from mac80211
on the same callback, and most importantly from ath9k_ps_restore()
which is the only call which will put the device into network sleep.

There are quite a few threads and bug reports on these a few of them are:

https://bugs.launchpad.net/ubuntu/karmic/+source/linux/+bug/407040
http://code.google.com/p/chromium-os/issues/detail?id=5709
http://code.google.com/p/chromium-os/issues/detail?id=5943

Stable fixes apply to [2.6.32+]

Cc: stable@kernel.org
Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

I don't see these posted on the mailing list yet so trying
a manual resend, this is manual resend attempt #2, the second
try removes the cc stable@kernel.org [2.6.32] stuff and
moves the kernel version info for the stable patch to a
separate line.

 drivers/net/wireless/ath/ath9k/main.c |    5 ++++-
 drivers/net/wireless/ath/ath9k/recv.c |    3 +++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1165f90..ba029b2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1562,6 +1562,8 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	 * IEEE80211_CONF_CHANGE_PS is only passed by mac80211 for STA mode.
 	 */
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
+		unsigned long flags;
+		spin_lock_irqsave(&sc->sc_pm_lock, flags);
 		if (conf->flags & IEEE80211_CONF_PS) {
 			sc->ps_flags |= PS_ENABLED;
 			/*
@@ -1576,7 +1578,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			sc->ps_enabled = false;
 			sc->ps_flags &= ~(PS_ENABLED |
 					  PS_NULLFUNC_COMPLETED);
-			ath9k_setpower(sc, ATH9K_PM_AWAKE);
+			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
 			if (!(ah->caps.hw_caps &
 			      ATH9K_HW_CAP_AUTOSLEEP)) {
 				ath9k_hw_setrxabort(sc->sc_ah, 0);
@@ -1591,6 +1593,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 				}
 			}
 		}
+		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index b32c8f0..87e02f5 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1641,6 +1641,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	u8 rx_status_len = ah->caps.rx_status_len;
 	u64 tsf = 0;
 	u32 tsf_lower = 0;
+	unsigned long flags;
 
 	if (edma)
 		dma_type = DMA_BIDIRECTIONAL;
@@ -1749,11 +1750,13 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			sc->rx.rxotherant = 0;
 		}
 
+		spin_lock_irqsave(&sc->sc_pm_lock, flags);
 		if (unlikely(ath9k_check_auto_sleep(sc) ||
 			     (sc->ps_flags & (PS_WAIT_FOR_BEACON |
 					      PS_WAIT_FOR_CAB |
 					      PS_WAIT_FOR_PSPOLL_DATA))))
 			ath_rx_ps(sc, skb);
+		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
 		if (ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB)
 			ath_ant_comb_scan(sc, &rs);
-- 
1.7.0.4

