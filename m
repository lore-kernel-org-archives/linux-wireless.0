Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42627 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761319AbZB0Kg0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 05:36:26 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 27 Feb 2009 02:36:25 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18855.49469.357603.258110@gargle.gargle.HOWL> (sfid-20090227_113639_436536_7D575971)
Date: Fri, 27 Feb 2009 16:02:29 +0530
To: Alina Friedrichsen <x-alina@gmx.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: IBSS issues
In-Reply-To: <20090227101911.291200@gmx.net>
References: <18855.26210.618690.891378@gargle.gargle.HOWL>
	<20090227082545.291220@gmx.net>
	<20090227090140.291190@gmx.net>
	<18855.45396.45156.609477@gargle.gargle.HOWL>
	<20090227101911.291200@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alina Friedrichsen wrote:
> Maybe because the scanning code was changed? But I have discovered this bug
> at the end of the last year before the scanning code was changed the last time.

Not sure, but this is a bug for sure.

> > And it can be fixed by
> > making use of the scan start/stop mac80211 callbacks.
> 
> I think a much cleaner way would be if the ath9k_hw_write_associd() honor the FIF_BCN_PRBRESP_PROMISC flag and determine with it if sc->curbssid should be set or ath_bcast_mac. So the the old sc->curbssid setting is saved. And then remove the following code...
> 
> if (*total_flags & FIF_BCN_PRBRESP_PROMISC) {
>         memcpy(sc->curbssid, ath_bcast_mac, ETH_ALEN);
>         sc->curaid = 0;
> 
> ...so that ath9k_hw_write_associd() is called if the FIF_BCN_PRBRESP_PROMISC is cleared at the end of the scanning, too. So that it can set the BSSID in the hardware back to sc->curbssid.
> 

Sure, either way works, since FIF_BCN_PRBRESP_PROMISC is set only during scanning
anyway.

Sujith
