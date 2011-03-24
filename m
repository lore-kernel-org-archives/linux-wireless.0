Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4442 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755Ab1CXNdL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 09:33:11 -0400
To: "John Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] mac80211: rename RX_FLAG_TSFT
References: <1298469968.4122.8.camel@jlt3.sipsolutions.net>
Date: Thu, 24 Mar 2011 14:32:20 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vsunv6ae3ri7v4@arend-laptop>
In-Reply-To: <1298469968.4122.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 23 Feb 2011 15:06:08 +0100, Johannes Berg  
<johannes@sipsolutions.net> wrote:

>  drivers/staging/brcm80211/sys/wlc_mac80211.c  |    5 ++++-

Hi Johannes,

2.6.38 has landed in staging-2.6 repository and I built our driver. It  
gives build warning on above mentioned file.

>
> --- wireless-testing.orig/include/net/mac80211.h	2011-02-23  
> -	RX_FLAG_TSFT		= 1<<7,
> +	RX_FLAG_MACTIME_MPDU	= 1<<7,

> wireless-testing.orig/drivers/staging/brcm80211/sys/wlc_mac80211.c	2011-02-23  
> 15:03:58.000000000 +0100
> +++  
> wireless-testing/drivers/staging/brcm80211/sys/wlc_mac80211.c	2011-02-23  
> 15:04:48.000000000 +0100
> @@ -6818,11 +6818,14 @@ prep_mac80211_status(struct wlc_info *wl
>  	ratespec_t rspec;
>  	unsigned char *plcp;
> +#if 0
> +	/* Clearly, this is bogus -- reading the TSF now is wrong */
>  	wlc_read_tsf(wlc, &tsf_l, &tsf_h);	/* mactime */
>  	rx_status->mactime = tsf_h;
>  	rx_status->mactime <<= 32;
>  	rx_status->mactime |= tsf_l;
> -	rx_status->flag |= RX_FLAG_TSFT;
> +	rx_status->flag |= RX_FLAG_MACTIME_MPDU; /* clearly wrong */
> +#endif

This piece of code has been '#if 0'-ed by you. Could you elaborate why  
this is clearly wrong? Because of this the variables tsf_l and tsf_h are  
not being used hence the warning.

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

