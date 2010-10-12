Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:38775 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756450Ab0JLCRj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 22:17:39 -0400
Received: from vs3009.wh2.ocn.ne.jp (125.206.180.237)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0910929856
	for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 11:17:37 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "kivuli" <taofeiid@gmail.com>
Subject: Re: add delays in pcu.c and qcu.c of ath5k when creating mesh-network on routerstation pro with ar71xx board and atheros 5213A
Date: Tue, 12 Oct 2010 11:17:45 +0900
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <201010090959043021161@gmail.com>
In-Reply-To: <201010090959043021161@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010121117.45101.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat October 9 2010 10:59:08 kivuli wrote:
> Hello,
> I'm trying to create mesh-network on routerstation pro with ar71xx and
> atheros 5213A,using openwrt backfire and ath5k. After "iw dev wlan0
> interface add mesh type mp mesh_id mymesh","ifconfig mesh up" paralyse the
> all network orders, I can see "ifconfig" "iwconfig" are dead with "ps",and
> I cannot kill them. I look up errors in "dmesg", It says the last
> functions is ath5k_hw_init_beacon() .I add some mdelay(1) between
> "ath5k_hw_reg_write(ah, 0, AR5K_TIMER0);" and "ath5k_hw_reg_write(ah,
> next_beacon, AR5K_TIMER0);", "ath5k_hw_reg_write(ah, timer3,
> AR5K_TIMER3);" and  "if (interval &
> AR5K_BEACON_RESET_TSF)","ath5k_hw_reg_write(ah, AR5K_ISR_BMISS,
> AR5K_PISR);" and "AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1,
> AR5K_STA_ID1_PWR_SV);"   in it tentatively and compile it againthen tried
> again, and then add "mdelay(10);" between 
> "AR5K_QUEUE_DFS_LOCAL_IFS(queue));" and "AR5K_REG_ENABLE_BITS(ah,
> AR5K_QUEUE_MISC(queue),AR5K_QCU_MISC_DCU_EARLY);" in
> "ath5k_hw_reset_tx_queue()" in qcu.c .Finally the mesh-network is OK! I'm
> not sure what is exactly wrong with ath5k,is this a bug? or did I do
> something wrong? Here is the patch I used:
> 
> diff -ruN a/config.mk b/config.mk
> --- a/config.mk	2010-03-17 21:42:58.000000000 +0000
> +++ b/config.mk	2010-09-24 13:31:30.000000000 +0000
> @@ -1,5 +1,8 @@
>  export
> 
> +# add by zheng
> +# CONFIG_ATH5K_DEBUG=y
> +
>  ## NOTE
>  ## Make sure to have each variable declaration start
>  ## in the first column, no whitespace allowed.
> diff -ruN a/drivers/net/wireless/ath/ath5k/pcu.c
> b/drivers/net/wireless/ath/ath5k/pcu.c ---
> a/drivers/net/wireless/ath/ath5k/pcu.c	2010-03-26 18:25:50.000000000 
+0000
> +++ b/drivers/net/wireless/ath/ath5k/pcu.c	2010-09-29 21:21:03.915143556
> +0000 @@ -25,6 +25,7 @@
>  \*********************************/
> 
>  #include <asm/unaligned.h>
> +#include <linux/delay.h>
> 
>  #include "ath5k.h"
>  #include "reg.h"
> @@ -618,11 +619,15 @@
>  	    ah->ah_sc->opmode == NL80211_IFTYPE_MESH_POINT)
>  		ath5k_hw_reg_write(ah, 0, AR5K_TIMER0);
> 
> +	mdelay(1);
> +
>  	ath5k_hw_reg_write(ah, next_beacon, AR5K_TIMER0);
>  	ath5k_hw_reg_write(ah, timer1, AR5K_TIMER1);
>  	ath5k_hw_reg_write(ah, timer2, AR5K_TIMER2);
>  	ath5k_hw_reg_write(ah, timer3, AR5K_TIMER3);
> 
> +	mdelay(1);
> +
>  	/* Force a TSF reset if requested and enable beacons */
>  	if (interval & AR5K_BEACON_RESET_TSF)
>  		ath5k_hw_reset_tsf(ah);
> @@ -641,6 +646,8 @@
>  	else
>  		ath5k_hw_reg_write(ah, AR5K_ISR_BMISS, AR5K_PISR);
> 
> +	mdelay(1);
> +
>  	/* TODO: Set enchanced sleep registers on AR5212
>  	 * based on vif->bss_conf params, until then
>  	 * disable power save reporting.*/
> diff -ruN a/drivers/net/wireless/ath/ath5k/qcu.c
> b/drivers/net/wireless/ath/ath5k/qcu.c ---
> a/drivers/net/wireless/ath/ath5k/qcu.c	2010-03-26 18:25:50.000000000 
+0000
> +++ b/drivers/net/wireless/ath/ath5k/qcu.c	2010-09-29 21:19:04.863143555
> +0000 @@ -24,6 +24,7 @@
>  #include "reg.h"
>  #include "debug.h"
>  #include "base.h"
> +#include <linux/delay.h> /* add by zheng */
> 
>  /*
>   * Get properties for a transmit queue
> @@ -331,6 +332,8 @@
>  				AR5K_DCU_LCL_IFS_AIFS),
>  			AR5K_QUEUE_DFS_LOCAL_IFS(queue));
> 
> +		mdelay(10);
> +
>  		/*
>  		 * Set misc registers
>  		 */
>

hello!

i haven't used mesh mode myself, so i cannot comment on that further. but 
adding random delays does not seem to be the right solution.

can you try to see if this patch helps?:

diff --git a/drivers/net/wireless/ath/ath5k/pcu.c 
b/drivers/net/wireless/ath/ath5k/pcu.c
index 095d30b..6dc01d6 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -615,8 +615,9 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 
next_beacon, u32 
        if (ah->ah_sc->opmode == NL80211_IFTYPE_AP ||
            ah->ah_sc->opmode == NL80211_IFTYPE_MESH_POINT)                             
                ath5k_hw_reg_write(ah, 0, AR5K_TIMER0);                                 
+       else                                                                            
+               ath5k_hw_reg_write(ah, next_beacon, AR5K_TIMER0);                       
                                                                                        
-       ath5k_hw_reg_write(ah, next_beacon, AR5K_TIMER0);                               
        ath5k_hw_reg_write(ah, timer1, AR5K_TIMER1);                                    
        ath5k_hw_reg_write(ah, timer2, AR5K_TIMER2);                                    
        ath5k_hw_reg_write(ah, timer3, AR5K_TIMER3); 

please cc: ath5k-devel mailing list.

bruno
