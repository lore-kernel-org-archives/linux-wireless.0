Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3919 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbYJGBfu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 21:35:50 -0400
Date: Mon, 6 Oct 2008 21:35:29 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: jirislaby@gmail.com, toralf.foerster@gmx.de,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
Message-ID: <20081007013529.GA9691@hash.localnet> (sfid-20081007_033555_558270_89D8F5AF)
References: <b6c5339f0810011904h1208aa1dr197580780896197d@mail.gmail.com> <87od23mo08.fsf@denkblock.local> <b6c5339f0810020552m7b745a0fr336ae7b245b3b899@mail.gmail.com> <20081002144600.M31352@bobcopeland.com> <87bpy32c1w.fsf@denkblock.local> <b6c5339f0810021137g3d93c5c8t5fa8fb3784294a86@mail.gmail.com> <20081003134648.M45120@bobcopeland.com> <87fxnd2112.fsf@denkblock.local> <20081003193739.M19356@bobcopeland.com> <877i8nky65.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <877i8nky65.fsf@denkblock.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 05, 2008 at 02:45:54PM +0200, Elias Oltmanns wrote:
> ath5k_init() is declared statically, so I don't see why adding an
> argument which may well be dropped again later should be too much
> trouble.

Ok here's take 3, I gave it a brief bit of testing, seems to work fine.
If you agree can I get your signed-off-by, Elias?  Toralf, do you want 
to add your reported-by?

Subject: [PATCH] ath5k: correct hardware startup sequence in resume

Based on a patch by Elias Oltmanns, we call ath5k_init in resume even
if we didn't previously open the device.  Besides starting up the
device unnecessarily, this also causes an oops on rmmod because
mac80211 will not invoke ath5k_stop and softirqs are left running after
the module has been unloaded.  Add a new state bit, ATH_STAT_STARTED,
to indicate that we have been started up.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |   28 ++++++++++++++++++++--------
 drivers/net/wireless/ath5k/base.h |    3 ++-
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index c151588..5388de8 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -340,9 +340,9 @@ static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
 }
 
 /* Interrupt handling */
-static int 	ath5k_init(struct ath5k_softc *sc);
+static int 	ath5k_init(struct ath5k_softc *sc, bool is_resume);
 static int 	ath5k_stop_locked(struct ath5k_softc *sc);
-static int 	ath5k_stop_hw(struct ath5k_softc *sc);
+static int 	ath5k_stop_hw(struct ath5k_softc *sc, bool is_suspend);
 static irqreturn_t ath5k_intr(int irq, void *dev_id);
 static void 	ath5k_tasklet_reset(unsigned long data);
 
@@ -640,7 +640,7 @@ ath5k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	ath5k_led_off(sc);
 
-	ath5k_stop_hw(sc);
+	ath5k_stop_hw(sc, true);
 
 	free_irq(pdev->irq, sc);
 	pci_save_state(pdev);
@@ -677,9 +677,10 @@ ath5k_pci_resume(struct pci_dev *pdev)
 		goto err_no_irq;
 	}
 
-	err = ath5k_init(sc);
+	err = ath5k_init(sc, true);
 	if (err)
 		goto err_irq;
+
 	ath5k_led_enable(sc);
 
 	/*
@@ -2158,12 +2159,17 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 \********************/
 
 static int
-ath5k_init(struct ath5k_softc *sc)
+ath5k_init(struct ath5k_softc *sc, bool is_resume)
 {
 	int ret;
 
 	mutex_lock(&sc->lock);
 
+	if (is_resume && !test_bit(ATH_STAT_STARTED, sc->status))
+		goto out_ok;
+
+	__clear_bit(ATH_STAT_STARTED, sc->status);
+
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "mode %d\n", sc->opmode);
 
 	/*
@@ -2188,12 +2194,15 @@ ath5k_init(struct ath5k_softc *sc)
 	if (ret)
 		goto done;
 
+	__set_bit(ATH_STAT_STARTED, sc->status);
+
 	/* Set ack to be sent at low bit-rates */
 	ath5k_hw_set_ack_bitrate_high(sc->ah, false);
 
 	mod_timer(&sc->calib_tim, round_jiffies(jiffies +
 			msecs_to_jiffies(ath5k_calinterval * 1000)));
 
+out_ok:
 	ret = 0;
 done:
 	mmiowb();
@@ -2248,7 +2257,7 @@ ath5k_stop_locked(struct ath5k_softc *sc)
  * stop is preempted).
  */
 static int
-ath5k_stop_hw(struct ath5k_softc *sc)
+ath5k_stop_hw(struct ath5k_softc *sc, bool update_status)
 {
 	int ret;
 
@@ -2280,6 +2289,9 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 	}
 	ath5k_txbuf_free(sc, sc->bbuf);
 	mmiowb();
+
+	if (update_status)
+		__clear_bit(ATH_STAT_STARTED, sc->status);
 	mutex_unlock(&sc->lock);
 
 	del_timer_sync(&sc->calib_tim);
@@ -2676,12 +2688,12 @@ ath5k_reset_wake(struct ath5k_softc *sc)
 
 static int ath5k_start(struct ieee80211_hw *hw)
 {
-	return ath5k_init(hw->priv);
+	return ath5k_init(hw->priv, false);
 }
 
 static void ath5k_stop(struct ieee80211_hw *hw)
 {
-	ath5k_stop_hw(hw->priv);
+	ath5k_stop_hw(hw->priv, false);
 }
 
 static int ath5k_add_interface(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index 9d0b728..06d1054 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -128,11 +128,12 @@ struct ath5k_softc {
 	size_t			desc_len;	/* size of TX/RX descriptors */
 	u16			cachelsz;	/* cache line size */
 
-	DECLARE_BITMAP(status, 4);
+	DECLARE_BITMAP(status, 5);
 #define ATH_STAT_INVALID	0		/* disable hardware accesses */
 #define ATH_STAT_MRRETRY	1		/* multi-rate retry support */
 #define ATH_STAT_PROMISC	2
 #define ATH_STAT_LEDSOFT	3		/* enable LED gpio status */
+#define ATH_STAT_STARTED	4		/* opened & irqs enabled */
 
 	unsigned int		filter_flags;	/* HW flags, AR5K_RX_FILTER_* */
 	unsigned int		curmode;	/* current phy mode */
-- 
1.5.4.2.182.gb3092


-- 
Bob Copeland %% www.bobcopeland.com

