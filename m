Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41219
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbXCWU0Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:26:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH] bcm43xx-mac80211: fix radio_set_tx_iq
Date: Fri, 23 Mar 2007 21:25:59 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <20070323202343.0e7ea0e7@localhost>
In-Reply-To: <20070323202343.0e7ea0e7@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703232125.59781.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 March 2007 20:23, Stefano Brivio wrote:
> Fix a duplicated leftshift in bcm43xx_radio_set_tx_iq. data_high values are
> already leftshifted. Thanks to Michael Buesch for spotting this.
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

I think you should probably write your APHY stuff against the development
tree, as only that has proper support for multiple 802.11 cores (4309).

> diff --git a/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c b/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
> index 10a82b1..a2c52f6 100644
> --- a/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
> +++ b/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
> @@ -3802,7 +3802,7 @@ void bcm43xx_radio_set_tx_iq(struct bcm4
>  
>  	for (i = 0; i < 5; i++) {
>  		for (j = 0; j < 5; j++) {
> -			if (tmp == (data_high[i] << 4 | data_low[j])) {
> +			if (tmp == (data_high[i] | data_low[j])) {
>  				bcm43xx_phy_write(dev, 0x0069, (i - j) << 8 | 0x00C0);
>  				return;
>  			}

-- 
Greetings Michael.
