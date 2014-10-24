Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38938 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbaJXCFG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 22:05:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1XhUFU-0001n1-8D
	for linux-wireless@vger.kernel.org; Fri, 24 Oct 2014 04:05:04 +0200
Received: from 61.150.43.68 ([61.150.43.68])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2014 04:05:04 +0200
Received: from ivycx1992 by 61.150.43.68 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2014 04:05:04 +0200
To: linux-wireless@vger.kernel.org
From: Tsaixiong <ivycx1992@gmail.com>
Subject: Re: [RFCv2 07/10] ath9k: enable control frame reception
Date: Fri, 24 Oct 2014 02:00:11 +0000 (UTC)
Message-ID: <loom.20141024T035214-81@post.gmane.org> (sfid-20141024_040510_612446_F050F0C8)
References: <1405246704-7489-1-git-send-email-lorenzo.bianconi83@gmail.com> <1405246704-7489-8-git-send-email-lorenzo.bianconi83@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi83@...> writes:

> 
> Enable control frame reception if dynamic ack processing is enabled
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@...>
> ---
>  drivers/net/wireless/ath/ath9k/recv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c 
b/drivers/net/wireless/ath/ath9k/recv.c
> index ad317a4..cc5ba4a 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>  <at>  <at>  -398,7 +398,7  <at>  <at>  u32 ath_calcrxfilter(struct ath_softc 
*sc)
>  	if (sc->sc_ah->is_monitoring)
>  		rfilt |= ATH9K_RX_FILTER_PROM;
> 
> -	if (sc->rx.rxfilter & FIF_CONTROL)
> +	if ((sc->rx.rxfilter & FIF_CONTROL) || sc->sc_ah->dynack.enabled)
>  		rfilt |= ATH9K_RX_FILTER_CONTROL;
> 
>  	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) &&

Dear Lorenzo:

Thank you your patch!But I want to know where can I get the RTS/CTS and ACK in 
MAC80211 or ATH9K after adopting this change,using the function 
ieee80211_rx_h_ctrl(/net/mac80211/rx.c)?

Any reply will be much appreciated!!

