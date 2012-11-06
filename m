Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41650 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2KFPxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 10:53:31 -0500
Message-ID: <1352217244.9440.16.camel@jlt4.sipsolutions.net> (sfid-20121106_165343_414402_7F00AE58)
Subject: Re: Linux 3.6.5
From: Johannes Berg <johannes@sipsolutions.net>
To: Eddie Chapman <eddie@ehuk.net>
Cc: stable@vger.kernel.org, florian@reitmeir.org,
	linux-wireless@vger.kernel.org, j@w1.fi
Date: Tue, 06 Nov 2012 16:54:04 +0100
In-Reply-To: <50992E0E.3040606@ehuk.net>
References: <20121031173811.GA12970@kroah.com> <509575F4.5020109@ehuk.net>
	   <20121105081757.GA3730@kroah.com> <50979D38.6010002@ehuk.net>
	   (sfid-20121105_121423_464154_72561532) <1352116868.9466.2.camel@jlt4.sipsolutions.net>
	  <509838F4.4010301@ehuk.net>
	 <1352188621.9440.4.camel@jlt4.sipsolutions.net> <50992E0E.3040606@ehuk.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eddie,

> The AP is a Netgear WNR2000v3 running DD-WRT v24-sp2 (03/19/12) std.
> 
> After sshing into it and playing around with the iw command, the phy is 
> phy0 and the device is ath0.
> 
> "iw ath0 scan dump" returns nothing unfortunately.

Yeah, sorry, I guess I confused you. I did want this info from the
client, as you provided:

> In case it helps, on the laptop (the client) I do get output from "iw 
> wlan0 scan dump":
> 
> BSS 82:e1:fa:1a:65:00 (on wlan0) -- associated
[...]
> 	HT operation:
> 		 * primary channel: 9
> 		 * secondary channel offset: above

As you can see, it's using HT40+ on channel 9 (2452 MHz). Your HT40
allow (correctly) map showed:

2452 HT40 -

This is because HT40+ isn't actually allowed on channel 9 by the
standard (cf. 802.11-2012 Table E-1 (US), E-2 (Europe), E-3 (Japan).

I wonder, what is the oldest kernel you tried? I think the fact that we
can connect here was introduced by some older patch, and then reverted
by my patch, so older kernels should have been slower as well?

The problem here is that some devices (notably iwlwifi) will not allow
(by firmware) to connect to such an AP as HT40- if that is not allowed.
So I prevented it generally, but we can make it device dependent. I
don't like it much, but I suppose we can do it. Try this patch:

http://p.sipsolutions.net/0129f39c7d882289.txt

It will still prohibit this configuration when the driver said it's not
allowed, but will allow it when there were other reasons to not allow
it.

johannes

