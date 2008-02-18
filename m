Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:49278 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752906AbYBRTwk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 14:52:40 -0500
Date: Mon, 18 Feb 2008 20:45:45 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43(legacy): include full timestamp in beacon frames
Message-ID: <20080218204545.06d1aaa7@morte> (sfid-20080218_195243_739229_9B8F5A03)
In-Reply-To: <200802181853.56155.mb@bu3sch.de>
References: <200802181853.56155.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 18 Feb 2008 18:53:55 +0100
Michael Buesch <mb@bu3sch.de> wrote:

> From: Johannes Berg <johannes@sipsolutions.net>
> 
> Having the full RX timestamp in beacons is necessary for IBSS
> merge to work properly so extend the 16-bit timestamp to the
> full 64 bits for beacon frames (as well as when monitor mode
> is active.)

> --- everything.orig/drivers/net/wireless/b43legacy/xmit.c	2008-02-06 17:38:25.416098905 +0100
> +++ everything/drivers/net/wireless/b43legacy/xmit.c	2008-02-18 09:04:40.471819824 +0100
> @@ -546,12 +546,16 @@ void b43legacy_rx(struct b43legacy_wldev
>  	status.antenna = !!(phystat0 & B43legacy_RX_PHYST0_ANT);
>  
>  	/*
> -	 * If monitors are present get full 64-bit timestamp. This
> -	 * code assumes we get to process the packet within 16 bits
> -	 * of timestamp, i.e. about 65 milliseconds after the PHY
> -	 * received the first symbol.
> +	 * All frames on monitor interfaces and beacons always need a full
> +	 * 64-bit timestamp. Monitor interfaces need it for diagnostic
> +	 * purposes and beacons for IBSS merging.
> +	 * This code assumes we get to process the packet within 16 bits
> +	 * of timestamp, i.e. about 65 milliseconds after the PHY received
> +	 * the first symbol.
>  	 */
> -	if (dev->wl->radiotap_enabled) {
> +	if (((fctl & (IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE))
> +	    == (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON)) ||
> +	    dev->wl->radiotap_enabled) {
>  		u16 low_mactime_now;
>  
>  		b43legacy_tsf_read(dev, &status.mactime);

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>


--
Ciao
Stefano
