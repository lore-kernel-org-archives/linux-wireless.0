Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1634 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbZJJM7a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Oct 2009 08:59:30 -0400
Date: Sat, 10 Oct 2009 08:58:24 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 2.6.31.[12] ath5k regression
Message-ID: <20091010125824.GA18841@hash.localnet>
References: <20090621134954.GA31505@linux-m68k.org> <20090621180447.GA29469@hash.localnet> <20090623174616.GA3914@linux-m68k.org> <20090623202541.GA3635@hash.localnet> <20090625083636.GA6323@linux-m68k.org> <20090705123105.GE2132@hash.localnet> <20091009143922.GA7848@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091009143922.GA7848@linux-m68k.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 09, 2009 at 04:39:22PM +0200, Richard Zidlicky wrote:
> -       ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
> +       ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, chan != NULL);
>         if (ret) {
>                 ATH5K_ERR(sc, "can't reset hardware (%d)\n", ret);
>                 goto err;

So, this change effectively just ensures we now program the pcu registers
at startup (every other time chan should not be null).  So my guess is
programming the pcu actually causes some problem.  Can you try this patch
instead?

Also, since you're using adhoc there may be a path that's somewhat
different from infrastructure mode, please check dmesg after applying the
patch and be sure that you only see "ath5k: reset with change_channel=true"
once per driver load.


diff --git a/drivers/net/wireless/ath/ath5k/initvals.c b/drivers/net/wireless/ath/ath5k/initvals.c
index 8fa4393..c099fa2 100644
--- a/drivers/net/wireless/ath/ath5k/initvals.c
+++ b/drivers/net/wireless/ath/ath5k/initvals.c
@@ -1376,9 +1376,8 @@ static void ath5k_hw_ini_registers(struct ath5k_hw *ah, unsigned int size,
 	for (i = 0; i < size; i++) {
 		/* On channel change there is
 		 * no need to mess with PCU */
-		if (change_channel &&
-				ini_regs[i].ini_register >= AR5K_PCU_MIN &&
-				ini_regs[i].ini_register <= AR5K_PCU_MAX)
+		if (ini_regs[i].ini_register >= AR5K_PCU_MIN &&
+		    ini_regs[i].ini_register <= AR5K_PCU_MAX)
 			continue;
 
 		switch (ini_regs[i].ini_mode) {
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 3dab3d8..4b8ccbe 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -880,6 +880,9 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 
 	ATH5K_TRACE(ah->ah_sc);
 
+	if (!change_channel)
+		printk(KERN_DEBUG "ath5k: reset with change_channel=true\n");
+
 	s_ant = 0;
 	ee_mode = 0;
 	staid1_flags = 0;

-- 
Bob Copeland %% www.bobcopeland.com

