Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 124-197-1-37.callplus.net.nz ([124.197.1.37]:33380 "EHLO
	elm.torus.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab1BBCum (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 21:50:42 -0500
Message-ID: <4D48C67A.7070804@davenport.net.nz>
Date: Wed, 02 Feb 2011 15:50:34 +1300
From: Hugh Davenport <hugh@davenport.net.nz>
MIME-Version: 1.0
To: Wojciech Dubowik <dubowoj@neratec.com>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: ath5k: issues with AHB support on ubiquiti bullet 2 (AR2315)
References: <11370703.28.1296562619576.JavaMail.wlan@CHBU500181>
In-Reply-To: <11370703.28.1296562619576.JavaMail.wlan@CHBU500181>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/02/11 01:17, Wojciech Dubowik wrote:
>> From: "Hugh Davenport" <hugh@davenport.net.nz>
>> To: linville@tuxdriver.com
>> Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org, lrodriguez@atheros.com, me@bobcopeland.com,
>> mickflemm@gmail.com, jirislaby@gmail.com
>> Sent: Tuesday, February 1, 2011 2:41:42 AM
>> Subject: ath5k: issues with AHB support on ubiquiti bullet 2 (AR2315)
>> Hey all,
>>
>> I'm just letting you know that I have been having issues getting the
>> the
>> AHB support with the ath5k driver working (from compat-wireless
>> 2011-01-05).
>>
>> I'm testing it on an ubiquiti bullet 2 device which internally is a
>> AR2315 WiSoC. I am using openwrt backfire with the mac80211 package
>> patched to use a later version of compat-wireless (ie one with AHB
>> support in ath5k). I had to modify some of the patches in openwrt so
>> they applied cleanly, but don't think any affected the ath5k (and
>> would
>> cause the problem i have).
>>
>> Basically the issue is this. When I try to load the module as is in
>> the
>> source tree, the system hangs and module never loads (device restarts
>> itself).
>>
>> I tried a bit of debugging (sorry about any newbie techniques here, im
>> new to kernel debugging) by just printing and returning errors after
>> every main function called. The problem seemed to be with the first
>> time
>> it called ath5k_hw_reg_write, which from my tracing seemed to be in th
>> wisoc reset function in the following chain.
>>
>> ath5k_hw_reg_write (ath5k.h)
>> ath5k_hw_wisoc_reset (reset.c)
>> ath5k_hw_nic_wakeup (reset.c)
>> ath5k_hw_init (attach.c)
>> ath5k_init_softc (base.c)
>> ath_ahb_probe (ahb.c)
>>
>>
>> I then tried out a few things in the vain attempt to get it to load
>> the
>> module, one which seemed to work is taking out the ioremap_nocache
>> call
>> in ath_ahb_probe, and set mem to be res->start (on my system this is
>> 0xb0000000 (the same as what madwifi tells me as well)). With this
>> /fix/
>> the module now loads, gives the output below, but i can't bring the
>> interface up (device crashes again).
>>
>> Atheros AR2315 chip found (MAC: 0x87, PHY: 0x48)
>>
>>
>> continuing traces when bring interface up brings me to another
>> ath5k_hw_reg_write call in the following chain
>>
>> ath5k_hw_reg_write (ath5k.h)
>> ath5k_hw_start_rx_dma (dma.c)
>> ath5k_rx_start (base.c)
>> ath5k_reset (base.c)
>> ath5k_init_hw (base.c)
>> ath5k_start (mac80211-ops.c)
>>
> I have just ran latest openwrt trunk and it works ok with default settings
> on my JJPlus 25APN (Atheros AP48 reference design) with AR2313. You chipset
> is a bit different and I don't have any access to it so I cannot really
> test.
> 
> I have posted already some extra patches to try but maybe you could try
> them again. I have just added extra reset I have found in documentation
> and shamelessly copied some code from madwifi. From what I have noticed 
> the chip will hang as in your description on any access to MAC registers
> if it's not resetted properly.
> 
> So here is the mentioned and untested patch:
> 
> [PATCH] Added extra wakeup form sleep in PCI for AR2315 and up
> 
> Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
> ---
>  drivers/net/wireless/ath/ath5k/ahb.c   |   18 ++++++++++++++++++
>  drivers/net/wireless/ath/ath5k/reg.h   |    9 +++++++++
>  drivers/net/wireless/ath/ath5k/reset.c |    1 +
>  3 files changed, 28 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
> index 707cde1..3a665ba 100644
> --- a/drivers/net/wireless/ath/ath5k/ahb.c
> +++ b/drivers/net/wireless/ath/ath5k/ahb.c
> @@ -132,6 +132,24 @@ static int ath_ahb_probe(struct platform_device *pdev)
>  		reg = __raw_readl((void __iomem *) AR5K_AR2315_BYTESWAP);
>  		reg |= AR5K_AR2315_BYTESWAP_WMAC;
>  		__raw_writel(reg, (void __iomem *) AR5K_AR2315_BYTESWAP);
> +
> +		/* wake up the MAC */
> +		/* NOTE: for the following write to succeed the
> +		 * RST_AHB_ARB_CTL should be set to 0. This driver
> +		 * assumes that the register has been set to 0 by boot loader
> +		 */
> +		reg = __raw_readl((void __iomem *) AR5K_AR2315_PCI_MAC_SCR);
> +		reg = (reg & ~AR5K_AR2315_PCI_MAC_SCR_SLMODE_M) |
> +			(AR5K_AR2315_PCI_MAC_SCR_SLM_FWAKE
> +			 << AR5K_AR2315_PCI_MAC_SCR_SLMODE_S);
> +		__raw_writel(reg, (void __iomem *) AR5K_AR2315_PCI_MAC_SCR);
> +
> +		/* wait for the MAC to wakeup */
> +		while
> +		(
> +			__raw_readl((void __iomem *) AR5K_AR2315_PCI_MCFG)
> +					& AR5K_PCICFG_SPWR_DN
> +		);
>  	} else {
>  		/* Enable WMAC DMA access (assuming 5312 or 231x*/
>  		/* TODO: check other platforms */
> diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
> index 7ad05d4..7763e15 100644
> --- a/drivers/net/wireless/ath/ath5k/reg.h
> +++ b/drivers/net/wireless/ath/ath5k/reg.h
> @@ -2587,3 +2587,12 @@
>  
>  #define AR5K_AR2315_BYTESWAP	0xb100000c
>  #define AR5K_AR2315_BYTESWAP_WMAC	0x00000002
> +
> +#define AR5K_AR2315_PCI				0xb0100000
> +#define AR5K_AR2315_PCI_MAC_SCR	(AR5K_AR2315_PCI + 0x4004)
> +#define AR5K_AR2315_PCI_MAC_SCR_SLMODE_M	0x00030000
> +#define AR5K_AR2315_PCI_MAC_SCR_SLMODE_S	16
> +#define AR5K_AR2315_PCI_MAC_SCR_SLM_FWAKE	0
> +
> +#define AR5K_AR2315_PCI_MCFG	(AR5K_AR2315_PCI + 0x4010)
> +#define AR5K_AR2315_PCI_MCFG_SPWR_DN	0x00010000
> diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
> index 8420689..35e6d2d 100644
> --- a/drivers/net/wireless/ath/ath5k/reset.c
> +++ b/drivers/net/wireless/ath/ath5k/reset.c
> @@ -405,6 +405,7 @@ static int ath5k_hw_wisoc_reset(struct ath5k_hw *ah, u32 flags)
>  	udelay(100);
>  
>  	/* Bring BB/MAC out of reset */
> +	regval = __raw_readl(reg);
>  	__raw_writel(regval & ~val, reg);
>  	regval = __raw_readl(reg);
>  

Thanks for that Wojciech,

I have tried that patch, still has same outcome in same place. Also both
with and without that patch I had it crashes on /loading/ the module
without the patch below (that I made to make it work), let me know if
this is the wrong solution.

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c
b/drivers/net/wireless/ath/ath5k/ahb.c
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -92,12 +92,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		goto err_out;
 	}

-	mem = ioremap_nocache(res->start, res->end - res->start + 1);
-	if (mem == NULL) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENOMEM;
-		goto err_out;
-	}
+	mem = res->start;

 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (res == NULL) {

I have also tried the patch from Bob Copeland and one from Bruno
Randolf, both below (and were posted to the list). They looked like they
may possibly fix the problem, they didn't though :(
Would there be any more that you would suggest.

Bob's:
diff --git a/drivers/net/wireless/ath/ath5k/dma.c
b/drivers/net/wireless/ath/ath5k/dma.c
index 0064be7..e828b98 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -838,7 +838,7 @@ int ath5k_hw_dma_stop(struct ath5k_hw *ah)
 	for (i = 0; i < qmax; i++) {
 		err = ath5k_hw_stop_tx_dma(ah, i);
 		/* -EINVAL -> queue inactive */
-		if (err != -EINVAL)
+		if (err && err != -EINVAL)
 			return err;
 	}


Bruno's:
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h
b/drivers/net/wireless/ath/ath5k/ath5k.h
index 407e39c..e43175a 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -210,14 +210,9 @@
 /* Initial values */
 #define	AR5K_INIT_CYCRSSI_THR1			2

-/* Tx retry limits */
-#define AR5K_INIT_SH_RETRY			10
-#define AR5K_INIT_LG_RETRY			AR5K_INIT_SH_RETRY
-/* For station mode */
-#define AR5K_INIT_SSH_RETRY			32
-#define AR5K_INIT_SLG_RETRY			AR5K_INIT_SSH_RETRY
-#define AR5K_INIT_TX_RETRY			10
-
+/* Tx retry limit defaults from standard */
+#define AR5K_INIT_RETRY_SHORT			7
+#define AR5K_INIT_RETRY_LONG			4

 /* Slot time */
 #define AR5K_INIT_SLOT_TIME_TURBO		6
@@ -1057,7 +1052,9 @@ struct ath5k_hw {
 #define ah_modes		ah_capabilities.cap_mode
 #define ah_ee_version		ah_capabilities.cap_eeprom.ee_version

-	u32			ah_limit_tx_retries;
+	u8			ah_retry_long;
+	u8			ah_retry_short;
+
 	u8			ah_coverage_class;
 	bool			ah_ack_bitrate_high;
 	u8			ah_bwmode;
@@ -1067,7 +1064,6 @@ struct ath5k_hw {
 	u8			ah_ant_mode;
 	u8			ah_tx_ant;
 	u8			ah_def_ant;
-	bool			ah_software_retry;

 	struct ath5k_capabilities ah_capabilities;

@@ -1250,6 +1246,8 @@ int ath5k_hw_set_tx_queueprops(struct ath5k_hw
*ah, int queue,
 int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah,
 			    enum ath5k_tx_queue queue_type,
 			    struct ath5k_txq_info *queue_info);
+void ath5k_hw_set_tx_retry_limits(struct ath5k_hw *ah,
+				  unsigned int queue);
 u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue);
 void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue);
 int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue);
diff --git a/drivers/net/wireless/ath/ath5k/attach.c
b/drivers/net/wireless/ath/ath5k/attach.c
index cdac5cf..c71fdbb 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -118,8 +118,8 @@ int ath5k_hw_init(struct ath5k_softc *sc)
 	ah->ah_bwmode = AR5K_BWMODE_DEFAULT;
 	ah->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
 	ah->ah_imr = 0;
-	ah->ah_limit_tx_retries = AR5K_INIT_TX_RETRY;
-	ah->ah_software_retry = false;
+	ah->ah_retry_short = AR5K_INIT_RETRY_SHORT;
+	ah->ah_retry_long = AR5K_INIT_RETRY_LONG;
 	ah->ah_ant_mode = AR5K_ANTMODE_DEFAULT;
 	ah->ah_noise_floor = -95;	/* until first NF calibration is run */
 	sc->ani_state.ani_mode = ATH5K_ANI_MODE_AUTO;
diff --git a/drivers/net/wireless/ath/ath5k/base.c
b/drivers/net/wireless/ath/ath5k/base.c
index dae0bdc..e6e68fd 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2399,7 +2399,8 @@ ath5k_init_softc(struct ath5k_softc *sc, const
struct ath_bus_ops *bus_ops)
 	/* set up multi-rate retry capabilities */
 	if (sc->ah->ah_version == AR5K_AR5212) {
 		hw->max_rates = 4;
-		hw->max_rate_tries = 11;
+		hw->max_rate_tries = max(AR5K_INIT_RETRY_SHORT,
+					 AR5K_INIT_RETRY_LONG);
 	}

 	hw->vif_data_size = sizeof(struct ath5k_vif);
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index d76d68c..36a5199 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -226,6 +226,7 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ath5k_hw *ah = sc->ah;
 	struct ieee80211_conf *conf = &hw->conf;
 	int ret = 0;
+	int i;

 	mutex_lock(&sc->lock);

@@ -243,6 +244,14 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
 		ath5k_hw_set_txpower_limit(ah, (conf->power_level * 2));
 	}

+	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
+		ah->ah_retry_long = conf->long_frame_max_tx_count;
+		ah->ah_retry_short = conf->short_frame_max_tx_count;
+
+		for (i = 0; i < ah->ah_capabilities.cap_queues.q_tx_num; i++)
+			ath5k_hw_set_tx_retry_limits(ah, i);
+	}
+
 	/* TODO:
 	 * 1) Move this on config_interface and handle each case
 	 * separately eg. when we have only one STA vif, use
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c
b/drivers/net/wireless/ath/ath5k/qcu.c
index 2c9c9e7..3343fb9 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -228,24 +228,9 @@ int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah,
enum ath5k_tx_queue queue_type,
 /*
  * Set tx retry limits on DCU
  */
-static void ath5k_hw_set_tx_retry_limits(struct ath5k_hw *ah,
-					unsigned int queue)
+void ath5k_hw_set_tx_retry_limits(struct ath5k_hw *ah,
+				  unsigned int queue)
 {
-	u32 retry_lg, retry_sh;
-
-	/*
-	 * Calculate and set retry limits
-	 */
-	if (ah->ah_software_retry) {
-		/* XXX Need to test this */
-		retry_lg = ah->ah_limit_tx_retries;
-		retry_sh = retry_lg = retry_lg > AR5K_DCU_RETRY_LMT_SH_RETRY ?
-			AR5K_DCU_RETRY_LMT_SH_RETRY : retry_lg;
-	} else {
-		retry_lg = AR5K_INIT_LG_RETRY;
-		retry_sh = AR5K_INIT_SH_RETRY;
-	}
-
 	/* Single data queue on AR5210 */
 	if (ah->ah_version == AR5K_AR5210) {
 		struct ath5k_txq_info *tq = &ah->ah_txq[queue];
@@ -255,25 +240,26 @@ static void ath5k_hw_set_tx_retry_limits(struct
ath5k_hw *ah,

 		ath5k_hw_reg_write(ah,
 			(tq->tqi_cw_min << AR5K_NODCU_RETRY_LMT_CW_MIN_S)
-			| AR5K_REG_SM(AR5K_INIT_SLG_RETRY,
-				AR5K_NODCU_RETRY_LMT_SLG_RETRY)
-			| AR5K_REG_SM(AR5K_INIT_SSH_RETRY,
-				AR5K_NODCU_RETRY_LMT_SSH_RETRY)
-			| AR5K_REG_SM(retry_lg, AR5K_NODCU_RETRY_LMT_LG_RETRY)
-			| AR5K_REG_SM(retry_sh, AR5K_NODCU_RETRY_LMT_SH_RETRY),
+			| AR5K_REG_SM(ah->ah_retry_long,
+				      AR5K_NODCU_RETRY_LMT_SLG_RETRY)
+			| AR5K_REG_SM(ah->ah_retry_short,
+				      AR5K_NODCU_RETRY_LMT_SSH_RETRY)
+			| AR5K_REG_SM(ah->ah_retry_long,
+				      AR5K_NODCU_RETRY_LMT_LG_RETRY)
+			| AR5K_REG_SM(ah->ah_retry_short,
+				      AR5K_NODCU_RETRY_LMT_SH_RETRY),
 			AR5K_NODCU_RETRY_LMT);
 	/* DCU on AR5211+ */
 	} else {
 		ath5k_hw_reg_write(ah,
-			AR5K_REG_SM(AR5K_INIT_SLG_RETRY,
-				AR5K_DCU_RETRY_LMT_SLG_RETRY) |
-			AR5K_REG_SM(AR5K_INIT_SSH_RETRY,
-				AR5K_DCU_RETRY_LMT_SSH_RETRY) |
-			AR5K_REG_SM(retry_lg, AR5K_DCU_RETRY_LMT_LG_RETRY) |
-			AR5K_REG_SM(retry_sh, AR5K_DCU_RETRY_LMT_SH_RETRY),
+			AR5K_REG_SM(ah->ah_retry_long,
+				    AR5K_DCU_RETRY_LMT_RTS)
+			| AR5K_REG_SM(ah->ah_retry_long,
+				      AR5K_DCU_RETRY_LMT_STA_RTS)
+			| AR5K_REG_SM(max(ah->ah_retry_long, ah->ah_retry_short),
+				      AR5K_DCU_RETRY_LMT_STA_DATA),
 			AR5K_QUEUE_DFS_RETRY_LIMIT(queue));
 	}
-	return;
 }

 /**
diff --git a/drivers/net/wireless/ath/ath5k/reg.h
b/drivers/net/wireless/ath/ath5k/reg.h
index fd14b91..e1c9abd 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -686,16 +686,15 @@

 /*
  * DCU retry limit registers
+ * all these fields don't allow zero values
  */
 #define AR5K_DCU_RETRY_LMT_BASE		0x1080			/* Register Address -Queue0
DCU_RETRY_LMT */
-#define AR5K_DCU_RETRY_LMT_SH_RETRY	0x0000000f	/* Short retry limit mask */
-#define AR5K_DCU_RETRY_LMT_SH_RETRY_S	0
-#define AR5K_DCU_RETRY_LMT_LG_RETRY	0x000000f0	/* Long retry limit mask */
-#define AR5K_DCU_RETRY_LMT_LG_RETRY_S	4
-#define AR5K_DCU_RETRY_LMT_SSH_RETRY	0x00003f00	/* Station short retry
limit mask (?) */
-#define AR5K_DCU_RETRY_LMT_SSH_RETRY_S	8
-#define AR5K_DCU_RETRY_LMT_SLG_RETRY	0x000fc000	/* Station long retry
limit mask (?) */
-#define AR5K_DCU_RETRY_LMT_SLG_RETRY_S	14
+#define AR5K_DCU_RETRY_LMT_RTS		0x0000000f	/* RTS failure limit.
Transmission fails if no CTS is received for this number of times */
+#define AR5K_DCU_RETRY_LMT_RTS_S	0
+#define AR5K_DCU_RETRY_LMT_STA_RTS	0x00003f00	/* STA RTS failure limit.
If exceeded CW reset */
+#define AR5K_DCU_RETRY_LMT_STA_RTS_S	8
+#define AR5K_DCU_RETRY_LMT_STA_DATA	0x000fc000	/* STA data failure
limit. If exceeded CW reset. */
+#define AR5K_DCU_RETRY_LMT_STA_DATA_S	14
 #define	AR5K_QUEUE_DFS_RETRY_LIMIT(_q)
AR5K_QUEUE_REG(AR5K_DCU_RETRY_LMT_BASE, _q)

 /*

