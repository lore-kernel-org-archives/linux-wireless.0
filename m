Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4987 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbYKUXQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 18:16:25 -0500
Date: Fri, 21 Nov 2008 18:15:27 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: set mac address in add_interface
Message-ID: <20081121231527.GA27720@hash.localnet> (sfid-20081122_001629_120551_D78DAD3D)
References: <20081118044037.GA18983@hash.localnet> <492710E6.7020506@gmail.com> <b6c5339f0811211201i384ee31dyb5b3998fe02136af@mail.gmail.com> <49271FD1.101@gmail.com> <49272BEE.2020106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49272BEE.2020106@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 21, 2008 at 11:45:18PM +0200, Maxim Levitsky wrote:
>> I double check that I use right kernel (install it again).
> 
> compiled kernel again, and installed it, same results.

Can you confirm that the proper mac address shows up if you do ifconfig
or macchanger -s?  I think it's just not associating.  

Also can you try specifying the ap again to trigger a probe after 
ifconfig up:

    $ iwconfig wlan0 ap <your AP's mac address>

Though I did forget about this gem, try this too:

diff --git a/drivers/net/wireless/ath5k/pcu.c b/drivers/net/wireless/ath5k/pcu.c
index d7f0c10..f401691 100644
--- a/drivers/net/wireless/ath5k/pcu.c
+++ b/drivers/net/wireless/ath5k/pcu.c
@@ -267,24 +267,23 @@ void ath5k_hw_get_lladdr(struct ath5k_hw *ah, u8 *mac)
  * @mac: The card's mac address
  *
  * Set station id on hw using the provided mac address
- *
- * NOTE: This is only called during attach, don't call it
- * on reset because it overwrites all AR5K_STA_ID1 settings.
- * We have set_opmode (above) for reset.
  */
 int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac)
 {
 	u32 low_id, high_id;
+	u32 pcu_reg;
 
 	ATH5K_TRACE(ah->ah_sc);
 	/* Set new station ID */
 	memcpy(ah->ah_sta_id, mac, ETH_ALEN);
 
+	pcu_reg = ath5k_hw_reg_read(ah, AR5K_STA_ID1) & 0xffff0000;
+
 	low_id = AR5K_LOW_ID(mac);
 	high_id = AR5K_HIGH_ID(mac);
 
 	ath5k_hw_reg_write(ah, low_id, AR5K_STA_ID0);
-	ath5k_hw_reg_write(ah, high_id, AR5K_STA_ID1);
+	ath5k_hw_reg_write(ah, pcu_reg | high_id, AR5K_STA_ID1);
 
 	return 0;
 }

-- 
Bob Copeland %% www.bobcopeland.com

