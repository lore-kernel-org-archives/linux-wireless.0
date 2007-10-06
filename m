Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.224]:25692 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbXJFBS5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2007 21:18:57 -0400
Received: by wx-out-0506.google.com with SMTP id h31so633981wxd
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2007 18:18:53 -0700 (PDT)
Date: Fri, 5 Oct 2007 21:20:17 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 5/6] ath5k: Add documenation for atheros bssid_mask
Message-ID: <20071006012017.GE25022@pogo> (sfid-20071006_021900_330401_BFB6BA14)
References: <20071006010449.GA25022@pogo> <20071006011657.GA24862@pogo> <20071006011837.GB25022@pogo> <20071006011923.GC25022@pogo> <20071006011949.GD25022@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071006011949.GD25022@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds extensive documenation for the atheros bssid_mask. Credit
to David Kimdon for figuring this out. I am just documenting it.

No need to check for ath5k_hw_hasbssidmask() as
ath5k_hw_set_bssid_mask() will do the check itself.

Also add link to Atheros patent 6677779 B1 about buffer registers and
control registers. Hope this helps.

Changes to base.c
Changes-licensed-under: 3-clause-BSD

Changes to hw.c, reg.h
Changes-licensed-under: ISC

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/base.c |    7 +--
 drivers/net/wireless/ath5k/hw.c   |   96 +++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath5k/reg.h  |   17 ++++--
 3 files changed, 107 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 325965a..caf9562 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2268,10 +2268,9 @@ static int ath_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 
 	ath5k_hw_get_lladdr(ah, mac);
 	SET_IEEE80211_PERM_ADDR(hw, mac);
-	if (ath5k_hw_hasbssidmask(ah)) {
-		memset(sc->bssidmask, 0xff, ETH_ALEN);
-		ath5k_hw_set_bssid_mask(ah, sc->bssidmask);
-	}
+	/* All MAC address bits matter for ACKs */
+	memset(sc->bssidmask, 0xff, ETH_ALEN);
+	ath5k_hw_set_bssid_mask(sc->ah, sc->bssidmask);
 
 	ret = ieee80211_register_hw(hw);
 	if (ret) {
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 6a8a278..445fa96 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -2366,9 +2366,99 @@ void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id)
 
 	ath5k_hw_enable_pspoll(hal, NULL, 0);
 }
-
-/*
- * Set BSSID mask on 5212
+/**
+ * ath5k_hw_set_bssid_mask - set common bits we should listen to
+ *
+ * The bssid_mask is a utility used by AR5212 hardware to inform the hardware
+ * which bits of the interface's MAC address should be looked at when trying
+ * to decide which packets to ACK. In station mode every bit matters. In AP
+ * mode with a single BSS every bit matters as well. In AP mode with 
+ * multiple BSSes not every bit matters.
+ *
+ * @hal: the &struct ath_hw
+ * @mask: the bssid_mask, a u8 array of size ETH_ALEN
+ *
+ * Note that this is a simple filter and *does* not filter out all
+ * relevant frames. Some non-relevant frames will get through, probability
+ * jocks are welcomed to compute.
+ *
+ * When handling multiple BSSes (or VAPs) you can get the BSSID mask by 
+ * computing the set of:
+ * 
+ *     ~ ( MAC XOR BSSID )
+ *
+ * When you do this you are essentially computing the common bits. Later it 
+ * is assumed the harware will "and" (&) the BSSID mask with the MAC address
+ * to obtain the relevant bits which should match on the destination frame.
+ * 
+ * Simple example: on your card you have have two BSSes you have created with
+ * BSSID-01 and BSSID-02. Lets assume BSSID-01 will not use the MAC address.
+ * There is another BSSID-03 but you are not part of it. For simplicity's sake,
+ * assuming only 4 bits for a mac address and for BSSIDs you can then have:
+ *
+ *                  \
+ * MAC:                0001 |
+ * BSSID-01:   0100 | --> Belongs to us
+ * BSSID-02:   1001 |
+ *                  /
+ * -------------------
+ * BSSID-03:   0110  | --> External
+ * -------------------
+ *
+ * Our bssid_mask would then be:  
+ *
+ *             On loop iteration for BSSID-01:
+ *             ~(0001 ^ 0100)  -> ~(0101)
+ *                             ->   1010
+ *             bssid_mask      =    1010
+ *
+ *             On loop iteration for BSSID-02:
+ *             bssid_mask &= ~(0001   ^   1001)
+ *             bssid_mask =   (1010)  & ~(0001 ^ 1001)
+ *             bssid_mask =   (1010)  & ~(1001)
+ *             bssid_mask =   (1010)  &  (0110)
+ *             bssid_mask =   0010
+ *
+ * A bssid_mask of 0010 means "only pay attention to the second least 
+ * significant bit". This is because its the only bit common
+ * amongst the MAC and all BSSIDs we support. To findout what the real
+ * common bit is we can simply "&" the bssid_mask now with any BSSID we have
+ * or our MAC address (we assume the hardware uses the MAC address).
+ *
+ * Now, suppose there's an incoming frame for BSSID-03:
+ *
+ * IFRAME-01:  0110
+ *
+ * An easy eye-inspeciton of this already should tell you that this frame 
+ * will not pass our check. This is beacuse the bssid_mask tells the 
+ * hardware to only look at the second least significant bit and the 
+ * common bit amongst the MAC and BSSIDs is 0, this frame has the 2nd LSB 
+ * as 1, which does not match 0.
+ *
+ * So with IFRAME-01 we *assume* the hardware will do:
+ *
+ *     allow = (IFRAME-01 & bssid_mask) == (bssid_mask & MAC) ? 1 : 0;
+ *  --> allow = (0110 & 0010) == (0010 & 0001) ? 1 : 0;
+ *  --> allow = (0010) == 0000 ? 1 : 0;
+ *  --> allow = 0
+ *
+ *  Lets now test a frame that should work:
+ *
+ * IFRAME-02:  0001 (we should allow)
+ *
+ *     allow = (0001 & 1010) == 1010
+ *
+ *     allow = (IFRAME-02 & bssid_mask) == (bssid_mask & MAC) ? 1 : 0;
+ *  --> allow = (0001 & 0010) ==  (0010 & 0001) ? 1 :0;
+ *  --> allow = (0010) == (0010)
+ *  --> allow = 1
+ *
+ * Other examples:
+ *
+ * IFRAME-03:  0100 --> allowed
+ * IFRAME-04:  1001 --> allowed
+ * IFRAME-05:  1101 --> allowed but its not for us!!!
+ *
  */
 int ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask)
 {
diff --git a/drivers/net/wireless/ath5k/reg.h b/drivers/net/wireless/ath5k/reg.h
index 0a7b312..1537517 100644
--- a/drivers/net/wireless/ath5k/reg.h
+++ b/drivers/net/wireless/ath5k/reg.h
@@ -1252,10 +1252,13 @@
 #define	AR5K_RX_FILTER_RADARERR_5212 	0x00000200	/* Don't filter phy radar errors [5212+] */
 #define AR5K_RX_FILTER_PHYERR_5211	0x00000040	/* [5211] */
 #define AR5K_RX_FILTER_RADARERR_5211	0x00000080	/* [5211] */
-#define AR5K_RX_FILTER_PHYERR	(ah->ah_version == AR5K_AR5211 ? \
-				AR5K_RX_FILTER_PHYERR_5211 : AR5K_RX_FILTER_PHYERR_5212)
-#define	AR5K_RX_FILTER_RADARERR	(ah->ah_version == AR5K_AR5211 ? \
-				AR5K_RX_FILTER_RADARERR_5211 : AR5K_RX_FILTER_RADARERR_5212)
+#define AR5K_RX_FILTER_PHYERR  \
+	((ah->ah_version == AR5K_AR5211 ? \
+	AR5K_RX_FILTER_PHYERR_5211 : AR5K_RX_FILTER_PHYERR_5212))
+#define        AR5K_RX_FILTER_RADARERR \
+	((ah->ah_version == AR5K_AR5211 ? \
+	AR5K_RX_FILTER_RADARERR_5211 : AR5K_RX_FILTER_RADARERR_5212))
+
 /*
  * Multicast filter register (lower 32 bits)
  */
@@ -1755,8 +1758,10 @@
  * packet, i have no idea. So i'll name them BUFFER_CONTROL_X registers
  * for now. It's interesting that they are also used for some other operations.
  *
- * Also check out ath5k_hw.h and U.S. Patent 6677779 B1 (about buffer
- * registers and control registers)
+ * Also check out hw.h and U.S. Patent 6677779 B1 (about buffer
+ * registers and control registers):
+ *
+ * http://www.google.com/patents?id=qNURAAAAEBAJ
  */
 
 #define AR5K_RF_BUFFER			0x989c
-- 
1.5.2.5

