Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44147 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbZB0J2d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 04:28:33 -0500
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 27 Feb 2009 01:28:32 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18855.45396.45156.609477@gargle.gargle.HOWL> (sfid-20090227_102837_743393_BCCE8AC6)
Date: Fri, 27 Feb 2009 14:54:36 +0530
To: Alina Friedrichsen <x-alina@gmx.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: IBSS issues
In-Reply-To: <20090227090140.291190@gmx.net>
References: <18855.26210.618690.891378@gargle.gargle.HOWL>
	<20090227082545.291220@gmx.net>
	<20090227090140.291190@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alina Friedrichsen wrote:
> Hi Sujith!
> 
> > The strange thing is after the ping from peer1 to peer2, the ping from
> > peer2 to peer1 works too. The same is if I start tcpdump on peer1. After
> > stopping tcpdump it keeps working. Looking...
> 
> I found it. :)
> The problem is the following code:
> [drivers/net/wireless/ath9k/main.c, ath9k_configure_filter(), line 2399]
> 
> if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
>         if (*total_flags & FIF_BCN_PRBRESP_PROMISC) {
>                 memcpy(sc->curbssid, ath_bcast_mac, ETH_ALEN);
>                 sc->curaid = 0;
>                 ath9k_hw_write_associd(sc);
>         }
> }
> 
> On scanning the BSSID is set to the broadcast MAC, but never set back.
> 
> Im not sure how to fix it in the cleanest way. I know to less about the handling of multi interface devices. ath9k people can you help please?
> 

Yep, that is the problem. But that chunk of code (and the bug) has been there forever,
so am not sure why it is creating a problem now. And it can be fixed by
making use of the scan start/stop mac80211 callbacks.

Thanks a lot !

Sujith
