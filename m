Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:15161 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbYGUNxG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 09:53:06 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2008 06:53:06 -0700
From: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
To: Pavel Roskin <proski@gnu.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 21 Jul 2008 06:53:04 -0700
Subject: RE: [PATCH] ath9k: fix build errors and warnings on 64-bit systems
Message-ID: <15B47C78534E094AA9A41F58FB8D74F3D6EF4A7EEE@SC1EXMB-MBCL.global.atheros.com> (sfid-20080721_155314_058589_A95ED77B)
References: <20080721000313.24845.10866.stgit@dv.roinet.com>
In-Reply-To: <20080721000313.24845.10866.stgit@dv.roinet.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Thanks, I split this into two patches. I've updated the patch series for wireless-testing as well:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/

  Luis
________________________________________
From: Pavel Roskin [proski@gnu.org]
Sent: Monday, July 21, 2008 5:33 AM
To: ath9k-devel@lists.ath9k.org; Luis Rodriguez
Subject: [PATCH] ath9k: fix build errors and warnings on 64-bit systems

Use skb_end_pointer(skb), not skb->end.  The later is not portable.
Avoid comparison of incompatible types.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 ksrc/hw.c   |    6 ++++--
 ksrc/recv.c |    5 +++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/ksrc/hw.c b/ksrc/hw.c
index b8a9321..5a24cbe 100644
--- a/ksrc/hw.c
+++ b/ksrc/hw.c
@@ -852,9 +852,11 @@ static inline enum hal_status ath9k_hw_check_eeprom(struct ath_hal *ah)
        else
                el = ahp->ah_eeprom.baseEepHeader.length;

+       if (el < sizeof(struct ar5416_eeprom) / sizeof(u_int16_t))
+               el = sizeof(struct ar5416_eeprom) / sizeof(u_int16_t);
+
        eepdata = (u_int16_t *) (&ahp->ah_eeprom);
-       for (i = 0; i <
-               min(el, sizeof(struct ar5416_eeprom)) / sizeof(u_int16_t); i++)
+       for (i = 0; i < el; i++)
                sum ^= *eepdata++;

        if (need_swap) {
diff --git a/ksrc/recv.c b/ksrc/recv.c
index a48c9e9..e111e9d 100644
--- a/ksrc/recv.c
+++ b/ksrc/recv.c
@@ -1380,7 +1380,7 @@ dma_addr_t ath_skb_map_single(struct ath_softc *sc,
         * Use skb's entire data area instead.
         */
        *pa = pci_map_single(sc->pdev, skb->data,
-               skb->end - skb->head, direction);
+               skb_end_pointer(skb) - skb->head, direction);
        return *pa;
 }

@@ -1390,5 +1390,6 @@ void ath_skb_unmap_single(struct ath_softc *sc,
                          dma_addr_t *pa)
 {
        /* Unmap skb's entire data area */
-       pci_unmap_single(sc->pdev, *pa, skb->end - skb->head, direction);
+       pci_unmap_single(sc->pdev, *pa,
+                        skb_end_pointer(skb) - skb->head, direction);
 }
