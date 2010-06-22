Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:48920 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750729Ab0FVECM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 00:02:12 -0400
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0294119328
	for <linux-wireless@vger.kernel.org>; Tue, 22 Jun 2010 13:02:10 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Jaroslav Fojtik" <jafojtik@seznam.cz>
Subject: Re: ATH5k - Signal measurement reports wrong values
Date: Tue, 22 Jun 2010 13:01:02 +0900
Cc: linux-wireless@vger.kernel.org
References: <4C1E6A13.4259.24AF3C@jafojtik.seznam.cz> <201006211650.50766.br1@einfach.org> <4C1FBD42.20217.106AB2@jafojtik.seznam.cz>
In-Reply-To: <4C1FBD42.20217.106AB2@jafojtik.seznam.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006221301.03254.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue June 22 2010 04:28:02 Jaroslav Fojtik wrote:
> root@dvouramenna:~# dmesg |grep "ath5.*chip"
> [    6.632843] ath5k phy0: Atheros AR2413 chip found (MAC: 0x78, PHY: 0x45)
> [    7.101528] ath5k phy1: Atheros AR5213A chip found (MAC: 0x59, PHY:
> 0x43)
> 
> Both chipsets suffer with a same problem.

hi jara!

thanks, i was able to reproduce the problem here. can you try this patch, it 
should fix it. it's just one line, so you could also change that 1 to a 4 in 
the code directly. please let me know if it helps...

bruno

commit 36c597b80813988f6a9c47ca4a5cb5306bbc67fa
Author: Bruno Randolf <br1@einfach.org>
Date:   Tue Jun 22 12:37:34 2010 +0900

    ath5k: fix antenna div gc for <= AR5K_SREV_PHY_2413
    
    Commit 39d5b2c83ca8904b6826a0713263a4e5a9c0730a "ath5k: update
    AR5K_PHY_RESTART_DIV_GC values to match masks" introduced a regression on 
PHY
    chips older than AR5K_SREV_PHY_5413, which caused signal values to be 
about
    10dB less that before. This patch reverts the AR5K_PHY_RESTART_DIV_GC 
values to
    the same values which were effectively used before (without the bitmask
    mistake). This brings signal levels back to normal on these PHY chips.
    
    Signed-off-by: Bruno Randolf <br1@einfach.org>

diff --git a/drivers/net/wireless/ath/ath5k/phy.c 
b/drivers/net/wireless/ath/ath5k/phy.c
index 82720fc..2254cd1 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1768,7 +1768,7 @@ ath5k_hw_set_fast_div(struct ath5k_hw *ah, u8 ee_mode, 
bool enable)
 
 	if (enable) {
 		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_RESTART,
-				AR5K_PHY_RESTART_DIV_GC, 1);
+				AR5K_PHY_RESTART_DIV_GC, 4);
 
 		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_FAST_ANT_DIV,
 					AR5K_PHY_FAST_ANT_DIV_EN);
