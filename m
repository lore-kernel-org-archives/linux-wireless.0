Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4993 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbZDSOls (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 10:41:48 -0400
Date: Sun, 19 Apr 2009 10:40:48 -0400
From: Bob Copeland <me@bobcopeland.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Subject: Re: [PATCH 4/7] ath5k: Beaconing fixes
Message-ID: <20090419144048.GA866@hash.localnet> (sfid-20090419_164150_837294_8458764C)
References: <20090416002951.GD4138@makis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090416002951.GD4138@makis>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 16, 2009 at 03:29:51AM +0300, Nick Kossifidis wrote:
>  * Fix num_tx_pending function, we never read the register :P that's why we
>  got all those "beacon queue 7 didn't stop messages".
> 
> @@ -160,7 +160,8 @@ u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue)
>  	if (ah->ah_version == AR5K_AR5210)
>  		return false;

This was pre-existing code, but what's with ath5k_hw_num_tx_pending
returning true and false in some cases when it's supposed to return a 
u32?

> -	pending = (AR5K_QUEUE_STATUS(queue) & AR5K_QCU_STS_FRMPENDCNT);
> +	pending = ath5k_hw_reg_read(ah, AR5K_QUEUE_STATUS(queue));
> +	pending &= AR5K_QCU_STS_FRMPENDCNT;

Heh, oops.

-- 
Bob Copeland %% www.bobcopeland.com

