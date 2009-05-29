Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ip78-183-211-87.adsl2.static.versatel.nl ([87.211.183.78]:33121
	"EHLO god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbZE2WCW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2009 18:02:22 -0400
Date: Sat, 30 May 2009 00:02:22 +0200
From: henk <henk@god.dyndns.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k in AP mode works!! (but sometimes with an oops, and a panic)
Message-ID: <20090529220222.GA22246@god.dyndns.org>
References: <20090524222027.GA32198@god.dyndns.org> <b6c5339f0905270550y50a925fbk4b891db8bbb9d9b@mail.gmail.com> <20090527184956.GA14462@god.dyndns.org> <20090528234702.GA9455@hash.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090528234702.GA9455@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 28, 2009 at 07:47:02PM -0400, Bob Copeland wrote:
> On Wed, May 27, 2009 at 08:49:56PM +0200, henk wrote:
> > 
> > I added some extra checks in ath5k/base.c
> > see http://bugzilla.kernel.org/show_bug.cgi?id=13381#c3
> > 
> > This resolves the panic for now.
> 
> Can you try this patch?  It should reduce to a warning if there is
> still a bug but hopefully you won't see the warning.  
> 
Sure now compiling 

...
> +
>  /*
>   * Transmit a beacon frame at SWBA.  Dynamic updates to the
>   * frame contents are done as needed and the slot time is
> @@ -2758,6 +2765,7 @@ ath5k_remove_interface(struct ieee80211_hw *hw,
>  
>  	ath5k_hw_set_lladdr(sc->ah, mac);
>  	sc->vif = NULL;
> +	ath5k_beacon_disable(sc);

Wouldn't it be better to reverse the deinitialisation? To make sure we
dont hit an interrupt in between? Like:

	ath5k_beacon_disable(sc);
	ec->vif = NULL;

Cheers
Henk
