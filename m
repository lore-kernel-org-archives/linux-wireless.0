Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate04.web.de ([217.72.192.242]:54151 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbZHIUCS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2009 16:02:18 -0400
Date: Sun, 09 Aug 2009 22:02:17 +0200
Message-Id: <1756555272@web.de>
MIME-Version: 1.0
From: Chunkeey@web.de
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Deauthentications with p54usb
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Larry Finger" <Larry.Finger@lwfinger.net> wrote
> Christian Lamparter wrote:
> > 
> > reason 7 must be:
> > WLAN_REASON_CLASS3_FRAME_FROM_NONASSOC_STA
> > 
> > and class 3 frames are (according to 802.11-2007 11.3.c)
> > 	- "normal" data frames
> > 	(- some MLMEs - probably not relevant )
> > 	- control frame:
> > 		=> especially: Power Save Poll.
> > 
> > your log doesn't hold any records about a disassoc event from the AP.
> > so, my first guess would be that you're hitting yet another
> > power saving related issue.  And as far as I know b43 does not do that yet.
> > So, can you please give the device another go without ps?
> > 
> > (BTW: mac80211 prints a debug text (if enabled in kconfig),
> >  whenever the device goes or leaves the hibernation mode...
> >  do you see any of those too?) 
> 
> Once I got that debug mode set with PS enabled, I still got the deauth
> events, but no messages from mac80211. I may not have had the debug
> value set correctly.
Ahh, wait... screw up: I failed to explain the difference between:

- powersave (=> responsible for your connection problems)
   In this mode: the device goes into a lower power state,
   but continues to listen for dtim beacons and multicast frames,
   from the AP.

   mac80211 does not have printks for these ps events,
   since the device power state may chance every second.

   howeve, it's possible to trace them through the generic _trace_
   framework with MAC80211_DRIVER_API_TRACER Kconfig
   option enabled.
   
vs. 

 - hibernation (soft rfkill that went in with "[PATCH] p54: implement rfkill")
   In this mode: the device's radio is completely shutdown... so
   it only makes sense to enter this mode when there's really nothing
   to do (=> the device is not scanning or associating/associated)
   
   mac80211 will printk (with CONFIG_MAC80211_VERBOSE_DEBUG set)
   whenever the IEEE80211_CONF_IDLE changes. e.g: 
       phy0: device no longer idle - REASON
    or:
       phy0: device now idle
    in the kernel logs.

> Turning off CONFIG_CFG80211_DEFAULT_PS stopped the messages,
> thus it certainly looks like a power saving event.
so hibernation (rfkill) is fine, just powersave is playing tricks...
weirdly, intel disabled ps in their driver _again_ not too long ago,
maybe a coincident, maybe not... do you think you can send me
a kismet/wireshark/airodump dump whenever the AP kicks the device?

BTW: you can set different PS modes with the old iwconfig utility:
iwconfig wlanX power off <-- disables PS
(just like turning off the CONFIG_CFG80211_DEFAULT_PS option)

iwconfig wlanX power timeout 0 <--- most aggressive PS setting,
(only uses PS-POLL to retrieve data).

AFAIK the current default is just "1", maybe your link would be
totally reliable with a more  _relaxed_ 200, 500 setting...

Regards,
    Chr
________________________________________________________________
Neu: WEB.DE Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
für nur 19,99 Euro/mtl.!* http://produkte.web.de/go/02/

