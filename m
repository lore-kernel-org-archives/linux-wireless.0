Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:1372 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020AbYJBPCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 11:02:42 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Elias Oltmanns" <eo@nebensachen.de>, jirislaby@gmail.com,
	mickflemm@gmail.com, johannes@sipsolutions.net,
	toralf.foerster@gmx.de
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
Date: Thu, 2 Oct 2008 11:02:02 -0400
Message-Id: <20081002144600.M31352@bobcopeland.com> (sfid-20081002_170246_650116_07F8A6C3)
In-Reply-To: <b6c5339f0810020552m7b745a0fr336ae7b245b3b899@mail.gmail.com>
References: <200808101401.03339.toralf.foerster@gmx.de> <b6c5339f0808101124x6f9359dct9ad828db1e6d1b2c@mail.gmail.com> <200810012055.58085.toralf.foerster@gmx.de> <87ej30m376.fsf@denkblock.local> <b6c5339f0810011515n770fa89bs3d09c16411121c79@mail.gmail.com> <87ljx8ndw1.fsf@denkblock.local> <b6c5339f0810011904h1208aa1dr197580780896197d@mail.gmail.com> <87od23mo08.fsf@denkblock.local> <b6c5339f0810020552m7b745a0fr336ae7b245b3b899@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2 Oct 2008 08:52:58 -0400, Bob Copeland wrote
> > Not sure I agree there. Why should calibration take place regularly even
> > though the interface appears to be shut down from user-space's point of
> > view? It simply doesn't make sense  to start the interface if nobody
> > intends to use it.
> 
> Hmm, yeah, you're right.  So, I guess we can just do your patch except
> with another status bit that says it's active instead of changing
> mac80211 (b43 does something along those lines).

Something like this?  It's kind of ugly, but the state bit needs
to be in the _init/_stop critical section to avoid the race there.
This makes it match other drivers' suspend methods, but is only a 
stop-gap until we have mac80211 suspend callbacks.

Jiri, Nick, any comments?  

Based on a patch by Elias Oltmanns.  We call ath5k_init in resume even
if we didn't previously open the device.  Besides starting up the
device unnecessarily, this also causes an OOPS on rmmod because
mac80211 will not invoke ath5k_stop and softirqs are left running after
the module has been unloaded.  Add a new state bit, ATH5K_STAT_STARTED,
to indicate that we have been started up.

---
 drivers/net/wireless/ath5k/base.c |   21 ++++++++++++++++++---
 drivers/net/wireless/ath5k/base.h |    3 ++-
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index e09ed2c..a40b75f 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -626,11 +626,17 @@ ath5k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath5k_softc *sc = hw->priv;
+	int is_started;
 
 	ath5k_led_off(sc);
 
+	is_started = test_bit(ATH_STAT_STARTED, sc->status);
 	ath5k_stop_hw(sc);
 
+	/* restore started flag for resume */
+	if (is_started)
+		set_bit(ATH_STAT_STARTED, sc->status);
+
 	free_irq(pdev->irq, sc);
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
@@ -666,9 +672,12 @@ ath5k_pci_resume(struct pci_dev *pdev)
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
@@ -2153,6 +2162,8 @@ ath5k_init(struct ath5k_softc *sc)
 
 	mutex_lock(&sc->lock);
 
+	__clear_bit(ATH_STAT_STARTED, sc->status);
+
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "mode %d\n", sc->opmode);
 
 	/*
@@ -2177,6 +2188,8 @@ ath5k_init(struct ath5k_softc *sc)
 	if (ret)
 		goto done;
 
+	__set_bit(ATH_STAT_STARTED, sc->status);
+
 	/* Set ack to be sent at low bit-rates */
 	ath5k_hw_set_ack_bitrate_high(sc->ah, false);
 
@@ -2269,6 +2282,8 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 	}
 	ath5k_txbuf_free(sc, sc->bbuf);
 	mmiowb();
+
+	__clear_bit(ATH_STAT_STARTED, sc->status);
 	mutex_unlock(&sc->lock);
 
 	del_timer_sync(&sc->calib_tim);
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



