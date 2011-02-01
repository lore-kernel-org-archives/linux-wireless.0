Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:43372 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab1BAMRH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 07:17:07 -0500
Date: Tue, 1 Feb 2011 13:17:03 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: Hugh Davenport <hugh@davenport.net.nz>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Message-ID: <11370703.28.1296562619576.JavaMail.wlan@CHBU500181>
In-Reply-To: <4D4764D6.5080809@davenport.net.nz>
Subject: Re: ath5k: issues with AHB support on ubiquiti bullet 2 (AR2315)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: "Hugh Davenport" <hugh@davenport.net.nz>
> To: linville@tuxdriver.com
> Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org, lrodriguez@atheros.com, me@bobcopeland.com,
> mickflemm@gmail.com, jirislaby@gmail.com
> Sent: Tuesday, February 1, 2011 2:41:42 AM
> Subject: ath5k: issues with AHB support on ubiquiti bullet 2 (AR2315)
> Hey all,
> 
> I'm just letting you know that I have been having issues getting the
> the
> AHB support with the ath5k driver working (from compat-wireless
> 2011-01-05).
> 
> I'm testing it on an ubiquiti bullet 2 device which internally is a
> AR2315 WiSoC. I am using openwrt backfire with the mac80211 package
> patched to use a later version of compat-wireless (ie one with AHB
> support in ath5k). I had to modify some of the patches in openwrt so
> they applied cleanly, but don't think any affected the ath5k (and
> would
> cause the problem i have).
> 
> Basically the issue is this. When I try to load the module as is in
> the
> source tree, the system hangs and module never loads (device restarts
> itself).
> 
> I tried a bit of debugging (sorry about any newbie techniques here, im
> new to kernel debugging) by just printing and returning errors after
> every main function called. The problem seemed to be with the first
> time
> it called ath5k_hw_reg_write, which from my tracing seemed to be in th
> wisoc reset function in the following chain.
> 
> ath5k_hw_reg_write (ath5k.h)
> ath5k_hw_wisoc_reset (reset.c)
> ath5k_hw_nic_wakeup (reset.c)
> ath5k_hw_init (attach.c)
> ath5k_init_softc (base.c)
> ath_ahb_probe (ahb.c)
> 
> 
> I then tried out a few things in the vain attempt to get it to load
> the
> module, one which seemed to work is taking out the ioremap_nocache
> call
> in ath_ahb_probe, and set mem to be res->start (on my system this is
> 0xb0000000 (the same as what madwifi tells me as well)). With this
> /fix/
> the module now loads, gives the output below, but i can't bring the
> interface up (device crashes again).
> 
> Atheros AR2315 chip found (MAC: 0x87, PHY: 0x48)
> 
> 
> continuing traces when bring interface up brings me to another
> ath5k_hw_reg_write call in the following chain
> 
> ath5k_hw_reg_write (ath5k.h)
> ath5k_hw_start_rx_dma (dma.c)
> ath5k_rx_start (base.c)
> ath5k_reset (base.c)
> ath5k_init_hw (base.c)
> ath5k_start (mac80211-ops.c)
> 
I have just ran latest openwrt trunk and it works ok with default settings
on my JJPlus 25APN (Atheros AP48 reference design) with AR2313. You chipset
is a bit different and I don't have any access to it so I cannot really
test.

I have posted already some extra patches to try but maybe you could try
them again. I have just added extra reset I have found in documentation
and shamelessly copied some code from madwifi. From what I have noticed 
the chip will hang as in your description on any access to MAC registers
if it's not resetted properly.

So here is the mentioned and untested patch:

[PATCH] Added extra wakeup form sleep in PCI for AR2315 and up

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath5k/ahb.c   |   18 ++++++++++++++++++
 drivers/net/wireless/ath/ath5k/reg.h   |    9 +++++++++
 drivers/net/wireless/ath/ath5k/reset.c |    1 +
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index 707cde1..3a665ba 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -132,6 +132,24 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		reg = __raw_readl((void __iomem *) AR5K_AR2315_BYTESWAP);
 		reg |= AR5K_AR2315_BYTESWAP_WMAC;
 		__raw_writel(reg, (void __iomem *) AR5K_AR2315_BYTESWAP);
+
+		/* wake up the MAC */
+		/* NOTE: for the following write to succeed the
+		 * RST_AHB_ARB_CTL should be set to 0. This driver
+		 * assumes that the register has been set to 0 by boot loader
+		 */
+		reg = __raw_readl((void __iomem *) AR5K_AR2315_PCI_MAC_SCR);
+		reg = (reg & ~AR5K_AR2315_PCI_MAC_SCR_SLMODE_M) |
+			(AR5K_AR2315_PCI_MAC_SCR_SLM_FWAKE
+			 << AR5K_AR2315_PCI_MAC_SCR_SLMODE_S);
+		__raw_writel(reg, (void __iomem *) AR5K_AR2315_PCI_MAC_SCR);
+
+		/* wait for the MAC to wakeup */
+		while
+		(
+			__raw_readl((void __iomem *) AR5K_AR2315_PCI_MCFG)
+					& AR5K_PCICFG_SPWR_DN
+		);
 	} else {
 		/* Enable WMAC DMA access (assuming 5312 or 231x*/
 		/* TODO: check other platforms */
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 7ad05d4..7763e15 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -2587,3 +2587,12 @@
 
 #define AR5K_AR2315_BYTESWAP	0xb100000c
 #define AR5K_AR2315_BYTESWAP_WMAC	0x00000002
+
+#define AR5K_AR2315_PCI				0xb0100000
+#define AR5K_AR2315_PCI_MAC_SCR	(AR5K_AR2315_PCI + 0x4004)
+#define AR5K_AR2315_PCI_MAC_SCR_SLMODE_M	0x00030000
+#define AR5K_AR2315_PCI_MAC_SCR_SLMODE_S	16
+#define AR5K_AR2315_PCI_MAC_SCR_SLM_FWAKE	0
+
+#define AR5K_AR2315_PCI_MCFG	(AR5K_AR2315_PCI + 0x4010)
+#define AR5K_AR2315_PCI_MCFG_SPWR_DN	0x00010000
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 8420689..35e6d2d 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -405,6 +405,7 @@ static int ath5k_hw_wisoc_reset(struct ath5k_hw *ah, u32 flags)
 	udelay(100);
 
 	/* Bring BB/MAC out of reset */
+	regval = __raw_readl(reg);
 	__raw_writel(regval & ~val, reg);
 	regval = __raw_readl(reg);
 
-- 
1.7.1


Tell me if it helps.

Wojtek

> 
> I am sorry about the long email, but I thought the more info you guys
> have, the better.
> 
> If you have any ideas I can try, any more testing you may need me to
> do,
> or anything that could help me get it working, let me know, and i'll
> do
> my best to get anything done asap.
> 
> Cheers,
> 
> Hugh Davenport
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
