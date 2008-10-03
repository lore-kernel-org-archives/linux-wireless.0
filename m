Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4310 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbYJCOOH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 10:14:07 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Elias Oltmanns" <eo@nebensachen.de>
Cc: jirislaby@gmail.com, toralf.foerster@gmx.de,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
Date: Fri, 3 Oct 2008 10:13:33 -0400
Message-Id: <20081003134648.M45120@bobcopeland.com> (sfid-20081003_161413_189595_27AF681F)
In-Reply-To: <b6c5339f0810021137g3d93c5c8t5fa8fb3784294a86@mail.gmail.com>
References: <200808101401.03339.toralf.foerster@gmx.de> <200810012055.58085.toralf.foerster@gmx.de> <87ej30m376.fsf@denkblock.local> <b6c5339f0810011515n770fa89bs3d09c16411121c79@mail.gmail.com> <87ljx8ndw1.fsf@denkblock.local> <b6c5339f0810011904h1208aa1dr197580780896197d@mail.gmail.com> <87od23mo08.fsf@denkblock.local> <b6c5339f0810020552m7b745a0fr336ae7b245b3b899@mail.gmail.com> <20081002144600.M31352@bobcopeland.com> <87bpy32c1w.fsf@denkblock.local> <b6c5339f0810021137g3d93c5c8t5fa8fb3784294a86@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2 Oct 2008 14:37:17 -0400, Bob Copeland wrote
> On Thu, Oct 2, 2008 at 12:31 PM, Elias Oltmanns <eo@nebensachen.de> wrote:
> > Sorry, but I don't think this is safe. Checking and restoring the
> > started flag has to be protected too, otherwise there can be races
> > against ->stop().
> 
> Yes, it's a bit of a mess.  Even if it were serialized, a ->stop()
> happening between suspend's call to hw_stop and actually powering down
> the device would clear the flag.  Ho hum.

Okay, as usual I'm wrong here; it will clear the flag but we don't care
since then we just wouldn't power up on resume.

Since no one else chimed in, here's take two with more chewing gum and 
baling wire to fix the suspend/stop race.

---
 drivers/net/wireless/ath5k/base.c |   24 +++++++++++++++++-------
 drivers/net/wireless/ath5k/base.h |    3 ++-
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index e09ed2c..7e8fa2e 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -335,7 +335,7 @@ static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah,
u32 rstamp)
 /* Interrupt handling */
 static int 	ath5k_init(struct ath5k_softc *sc);
 static int 	ath5k_stop_locked(struct ath5k_softc *sc);
-static int 	ath5k_stop_hw(struct ath5k_softc *sc);
+static int 	ath5k_stop_hw(struct ath5k_softc *sc, bool update_status);
 static irqreturn_t ath5k_intr(int irq, void *dev_id);
 static void 	ath5k_tasklet_reset(unsigned long data);
 
@@ -629,7 +629,7 @@ ath5k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	ath5k_led_off(sc);
 
-	ath5k_stop_hw(sc);
+	ath5k_stop_hw(sc, false);
 
 	free_irq(pdev->irq, sc);
 	pci_save_state(pdev);
@@ -666,9 +666,12 @@ ath5k_pci_resume(struct pci_dev *pdev)
 		goto err_no_irq;
 	}
 
-	err = ath5k_init(sc);
-	if (err)
-		goto err_irq;
+	if (test_bit(ATH_STAT_STARTED, sc->status)) {
+		err = ath5k_init(sc);
+		if (err)
+			goto err_irq;
+	}
+
 	ath5k_led_enable(sc);
 
 	/*
@@ -2153,6 +2156,8 @@ ath5k_init(struct ath5k_softc *sc)
 
 	mutex_lock(&sc->lock);
 
+	__clear_bit(ATH_STAT_STARTED, sc->status);
+
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "mode %d\n", sc->opmode);
 
 	/*
@@ -2177,6 +2182,8 @@ ath5k_init(struct ath5k_softc *sc)
 	if (ret)
 		goto done;
 
+	__set_bit(ATH_STAT_STARTED, sc->status);
+
 	/* Set ack to be sent at low bit-rates */
 	ath5k_hw_set_ack_bitrate_high(sc->ah, false);
 
@@ -2237,7 +2244,7 @@ ath5k_stop_locked(struct ath5k_softc *sc)
  * stop is preempted).
  */
 static int
-ath5k_stop_hw(struct ath5k_softc *sc)
+ath5k_stop_hw(struct ath5k_softc *sc, bool update_status)
 {
 	int ret;
 
@@ -2269,6 +2276,9 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 	}
 	ath5k_txbuf_free(sc, sc->bbuf);
 	mmiowb();
+
+	if (update_status)
+		__clear_bit(ATH_STAT_STARTED, sc->status);
 	mutex_unlock(&sc->lock);
 
 	del_timer_sync(&sc->calib_tim);
@@ -2670,7 +2680,7 @@ static int ath5k_start(struct ieee80211_hw *hw)
 
 static void ath5k_stop(struct ieee80211_hw *hw)
 {
-	ath5k_stop_hw(hw->priv);
+	ath5k_stop_hw(hw->priv, true);
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


