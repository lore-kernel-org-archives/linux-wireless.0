Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate04.web.de ([217.72.192.242]:58847 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbZHIVpE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2009 17:45:04 -0400
Date: Sun, 09 Aug 2009 23:45:02 +0200
Message-Id: <1756630366@web.de>
MIME-Version: 1.0
From: Chunkeey@web.de
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Deauthentications with p54usb
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Larry Finger" <Larry.Finger@lwfinger.net> wrote:
> Chunkeey@web.de wrote:
> > Ahh, wait... screw up: I failed to explain the difference between:
> > vs.  
> >  - hibernation (soft rfkill that went in with "[PATCH] p54: implement rfkill")
> >    In this mode: the device's radio is completely shutdown... so
> >    it only makes sense to enter this mode when there's really nothing
> >    to do (=> the device is not scanning or associating/associated)
> >    
> >    mac80211 will printk (with CONFIG_MAC80211_VERBOSE_DEBUG set)
> >    whenever the IEEE80211_CONF_IDLE changes. e.g: 
> >        phy0: device no longer idle - REASON
> >     or:
> >        phy0: device now idle
> >     in the kernel logs.
> > 
> >> Turning off CONFIG_CFG80211_DEFAULT_PS stopped the messages,
> >> thus it certainly looks like a power saving event.
> > so hibernation (rfkill) is fine, just powersave is playing tricks...
> > weirdly, intel disabled ps in their driver _again_ not too long ago,
> > maybe a coincident, maybe not... do you think you can send me
> > a kismet/wireshark/airodump dump whenever the AP kicks the device?
> 
> We don't know that hibernation is OK. I just never make my machine
> hibernate (suspend to disk) or sleep (suspend to RAM).
> The last time I tried it had one or more drivers that would not cooperate,
> and I have not tried recently.

meh, overloaded words ;-)

that hibernation paragraph is about the hibernation _filter_ state:
#define P54_FILTER_TYPE_HIBERNATE       BIT(5) <-- lmac.h

this operation mode silence the device (no frames will be send, or received),
which makes it ideal for soft - rfkill.

but yeah, that name is definitely misleading. We don't want to
hibernate/(suspend) the whole machine... just the p54 device,
when it's not connected. 

> > BTW: you can set different PS modes with the old iwconfig utility:
> > iwconfig wlanX power off <-- disables PS
> > (just like turning off the CONFIG_CFG80211_DEFAULT_PS option)
> > 
> > iwconfig wlanX power timeout 0 <--- most aggressive PS setting,
> > (only uses PS-POLL to retrieve data).
> > 
> > AFAIK the current default is just "1", maybe your link would be
> > totally reliable with a more  _relaxed_ 200, 500 setting...
> 
> I'll re-enable CONFIG_CFG80211_DEFAULT_PS and try a more relaxed value
> for the power timeout. In any case, with it disabled, there have been
> no deauthentications nor disassociations. The link is rock solid.

Thanks for confirming my thoughts!

So, the rfkill changes are not to blame for this problem and we can
take them out of the equation.

The weird thing is that the driver's PS code (relevant to STA mode)
has not changed since you did the exhaustive tests last month.

Regards,
    Chr
________________________________________________________________
Neu: WEB.DE Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
für nur 19,99 Euro/mtl.!* http://produkte.web.de/go/02/

