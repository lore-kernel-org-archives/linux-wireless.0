Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51960 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755330AbYLVX7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 18:59:48 -0500
Date: Mon, 22 Dec 2008 21:59:43 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Werner Almesberger <werner@openmoko.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: AR6k: to rfkill or not to rfkill ?
Message-ID: <20081222235943.GA17512@khazad-dum.debian.net> (sfid-20081223_005951_791308_6A884CE2)
References: <20081218212234.GI5019@almesberger.net> <20081220201541.GD25001@khazad-dum.debian.net> <20081222195047.GA5020@almesberger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081222195047.GA5020@almesberger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 22 Dec 2008, Werner Almesberger wrote:
> firmware black box on the module. I'll ask Atheros if it's really safe
> or if there's perhaps a better way to do this.

If Atheros gives you the magic needed to ensure it won't emit energy,
you're all set :)

> Hmm, so are you saying that the behaviour of the device is unspecified
> while rfkill is blocking ? That's not the impression I got from reading
> Documentation/rfkill.txt

It has not been specified yet, AFAIK.  Other than the fact that the
rfkill status for the core is not to be confused with other device
status that could cause it to stop transmitting (like tx power), so it
needs to be tracked separatedly.

> E.g., if I rfkill the transmitter and then user space issues an ioctl,
> say, to set the ESSID, is it okay if the ioctl fails because rfkill
> is in force ?

I suggest that you guys should get together and define these
requirements, and then add it to the rfkill.txt documentation, so that
user experience can be enhanced...

> Continuing the above example, once rfkill unblocks the transmitter,
> should the device's state reflect any configuration changes made
> while the transmitter was shut down ? I.e., in the example, the MAC
> would use the new ESSID (as opposed to the previous one or perhaps
> even having been reset completely).

IMHO, that is an easy one: if you accepted any config changes in the
first place, they are what should be used.  Less surprise path for the
user and all that.

> What I'm currently doing is to add yet another layer of blocking
> (on top of SIWTXPOW and the Atheros-specific
> AR6000_XIOCTRL_WMI_SET_WLAN_STATE), transparent to the others, and
> then decide on the combined state what needs to be done when
> unblocking, plus plug the holes created by a few other ioctls that
> could also cause the MAC to unblock behind our back.

I think that's the proper way to go about it, yes.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
