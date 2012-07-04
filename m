Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41714 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab2GDJqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 05:46:14 -0400
Message-ID: <1341395171.4482.10.camel@jlt3.sipsolutions.net> (sfid-20120704_114618_455741_41EF0E8A)
Subject: Re: Kernel oops in __netif_schedule() for at76c50x-usb
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Date: Wed, 04 Jul 2012 11:46:11 +0200
In-Reply-To: <4FF225AC.8020205@lwfinger.net> (sfid-20120703_005025_974399_3EFA8A16)
References: <4FF1BC71.4070002@lwfinger.net>
	   (sfid-20120702_172127_238924_ED185EFD) <1341243087.19642.20.camel@jlt3.sipsolutions.net>
	  <4FF1C887.8090009@lwfinger.net>
	 (sfid-20120702_181310_720968_3FE88ADC) <1341250736.19642.22.camel@jlt3.sipsolutions.net>
	 <4FF225AC.8020205@lwfinger.net> (sfid-20120703_005025_974399_3EFA8A16)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-02 at 17:50 -0500, Larry Finger wrote:
> On 07/02/2012 12:38 PM, Johannes Berg wrote:
> >
> >>> I'm not sure which fix is correct though. Should we have software QoS
> >>> queues for these drivers, but we'll never use them? Then this would
> >>> work:
> >>> http://p.sipsolutions.net/e015bf7db9a05887.txt
> >>>
> >>> Or we could change the enable code path. Hmm.
> >>
> >> That patch does prevent the oops. I was not able to make a connection with the
> >> device, but I just acquired it, and I'm not sure of its quality, or that of the
> >> driver.
> >
> > I don't think that device works today -- IIRC it requires the BSSID
> > before authentication and that wasn't possible before the auth redesign.
> >
> >> It does scan OK, and I think the patch is OK. I'll do more tests with
> >> b43legacy later as the machine with that iface is busy. I will also test b43 on
> >> the PPC using the open-source firmware.
> >>
> >> Although you may want to change the enable code path, some patch will be needed
> >> to prevent a regression in 3.5. If this is the one, you may add a "Tested-by"
> >> for me.
> >
> > Thanks. Could you try this patch instead? I think it makes more sense.
> >
> > http://p.sipsolutions.net/c3e9b814a409ca11.txt
> 
> That one fails and gives the oops in __netif_schedule.

Hmmm, that's odd. I'll try to reproduce this to be able to track it
better.

johannes

