Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:41680 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbYJGUwe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 16:52:34 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: Bob Copeland <me@bobcopeland.com>
Cc: jirislaby@gmail.com, toralf.foerster@gmx.de,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
References: <b6c5339f0810020552m7b745a0fr336ae7b245b3b899@mail.gmail.com>
	<20081002144600.M31352@bobcopeland.com>
	<87bpy32c1w.fsf@denkblock.local>
	<b6c5339f0810021137g3d93c5c8t5fa8fb3784294a86@mail.gmail.com>
	<20081003134648.M45120@bobcopeland.com>
	<87fxnd2112.fsf@denkblock.local>
	<20081003193739.M19356@bobcopeland.com>
	<877i8nky65.fsf@denkblock.local> <20081007013529.GA9691@hash.localnet>
	<873aj8vg45.fsf@denkblock.local>
	<20081007130613.GB10693@hash.localnet>
Date: Tue, 07 Oct 2008 22:52:22 +0200
In-Reply-To: <20081007130613.GB10693@hash.localnet> (Bob Copeland's message of
	"Tue, 7 Oct 2008 09:06:13 -0400")
Message-ID: <87ljx0t9fd.fsf@denkblock.local> (sfid-20081007_225237_886805_A0B3A629)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> wrote:
> On Tue, Oct
> Not sure 07, 2008 at 12:44:58PM +0200, Elias Oltmanns wrote:
>> Looking through the code, I'm wondering about the atomicity requirements
>
>> of sc->status. In my opinion, __set_bit() is not permissible in various
>> places (including your use case). But since this is a problem that has
>> been around before, I will send a separate patch once yours has been
>> merged.
>
> Ok, I don't see why it's a problem in this case, but I'll look for 
> your patch.  Note we should be doing sc->status updates under a mutex
> already; if not that's a bug.

Alright, in that case __set_bit() is quite sufficient, of course. In
order to enforce this policy, I'd suggest the following patch.

Regards,

Elias
---
From: Elias Oltmanns <eo@nebensachen.de>
Subject: [PATCH] ath5k: Ensure atomicity of bitops on sc->status

Bitops on sc->status have to be protected by the sc->lock as soon as
ieee80211_register_hw() has been called.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 drivers/net/wireless/ath5k/base.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 0676c6d..2c737da 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -490,6 +490,9 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto err_ah;
 
+	mutex_lock(&sc->lock);
+	ath5k_init_leds(sc);
+
 	ATH5K_INFO(sc, "Atheros AR%s chip found (MAC: 0x%x, PHY: 0x%x)\n",
 			ath5k_chip_name(AR5K_VERSION_VER,sc->ah->ah_mac_srev),
 					sc->ah->ah_mac_srev,
@@ -541,6 +544,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 
 	/* ready to process interrupts */
 	__clear_bit(ATH_STAT_INVALID, sc->status);
+	mutex_unlock(&sc->lock);
 
 	return 0;
 err_ah:
@@ -749,8 +753,6 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 		goto err_queues;
 	}
 
-	ath5k_init_leds(sc);
-
 	return 0;
 err_queues:
 	ath5k_txq_release(sc);
@@ -2881,12 +2883,14 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 		AR5K_RX_FILTER_MCAST);
 
 	if (changed_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
+		mutex_lock(&sc->lock);
 		if (*new_flags & FIF_PROMISC_IN_BSS) {
 			rfilt |= AR5K_RX_FILTER_PROM;
 			__set_bit(ATH_STAT_PROMISC, sc->status);
 		}
 		else
 			__clear_bit(ATH_STAT_PROMISC, sc->status);
+		mutex_unlock(&sc->lock);
 	}
 
 	/* Note, AR5K_RX_FILTER_MCAST is already enabled */
