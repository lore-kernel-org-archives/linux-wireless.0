Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35638 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbZHJPBH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 11:01:07 -0400
Date: Mon, 10 Aug 2009 10:59:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: gregkh@suse.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] crap/rtl8187se: Fix comment-out-typo
Message-ID: <20090810145925.GA2733@tuxdriver.com>
References: <200908091802.31166.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200908091802.31166.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 09, 2009 at 06:02:30PM +0200, Michael Buesch wrote:
> This fixes a comment-out-typo that resulted in a dangling if-branch.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> Completely untested, but looks sane.
> 
> 
>  drivers/staging/rtl8187se/r8180_core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- wireless-testing.orig/drivers/staging/rtl8187se/r8180_core.c
> +++ wireless-testing/drivers/staging/rtl8187se/r8180_core.c
> @@ -3394,21 +3394,21 @@ short rtl8180_tx(struct net_device *dev,
>  			if(remain == 4 && i+4 >= buflen) break;
>  			/* ensure the last desc has at least 4 bytes payload */
>  
>  		}
>  		txbuf = txbuf + i;
>  		*(tail+3)=*(tail+3) &~ 0xfff;
>  		*(tail+3)=*(tail+3) | i; // buffer lenght
>  		// Use short preamble or not
>  		if (priv->ieee80211->current_network.capability&WLAN_CAPABILITY_SHORT_PREAMBLE)
>  			if (priv->plcp_preamble_mode==1 && rate!=0)	//  short mode now, not long!
> -			//	*tail |= (1<<16);				// enable short preamble mode.
> +			;//	*tail |= (1<<16);				// enable short preamble mode.
>  
>  #ifdef CONFIG_RTL8185B
>  		if(bCTSEnable) {
>  			*tail |= (1<<18);
>  		}
>  
>  		if(bRTSEnable) //rts enable
>  		{
>  			*tail |= ((ieeerate2rtlrate(priv->ieee80211->basic_rate))<<19);//RTS RATE
>  			*tail |= (1<<23);//rts enable

Thanks for the reminder of why rtl8187se remains abandoned...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
