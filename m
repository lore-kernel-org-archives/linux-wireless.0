Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.openmoko.org ([88.198.124.205]:46934 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbYLVTvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 14:51:19 -0500
Date: Mon, 22 Dec 2008 17:50:47 -0200
From: Werner Almesberger <werner@openmoko.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless@vger.kernel.org
Subject: Re: AR6k: to rfkill or not to rfkill ?
Message-ID: <20081222195047.GA5020@almesberger.net> (sfid-20081222_205123_128732_DEB2E2B5)
References: <20081218212234.GI5019@almesberger.net> <20081220201541.GD25001@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081220201541.GD25001@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:
> There is one screening rule that does help:
> 
> Is that a way you can program the device that *ENSURES* without any doubt,
> that it will never emit energy off the transmitter?

Heh, I knew there would be a catch :-) All the magic happens in the
firmware black box on the module. I'll ask Atheros if it's really safe
or if there's perhaps a better way to do this.

> If your rfkill controller has been set to "block the radio", you must NOT
> allow any energy to be emmited by the transmitter.  This is all that
> matters.

Hmm, so are you saying that the behaviour of the device is unspecified
while rfkill is blocking ? That's not the impression I got from reading
Documentation/rfkill.txt

E.g., if I rfkill the transmitter and then user space issues an ioctl,
say, to set the ESSID, is it okay if the ioctl fails because rfkill
is in force ?

Continuing the above example, once rfkill unblocks the transmitter,
should the device's state reflect any configuration changes made
while the transmitter was shut down ? I.e., in the example, the MAC
would use the new ESSID (as opposed to the previous one or perhaps
even having been reset completely).

What I'm currently doing is to add yet another layer of blocking
(on top of SIWTXPOW and the Atheros-specific
AR6000_XIOCTRL_WMI_SET_WLAN_STATE), transparent to the others, and
then decide on the combined state what needs to be done when
unblocking, plus plug the holes created by a few other ioctls that
could also cause the MAC to unblock behind our back.

Thanks,
- Werner
