Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:38958 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763Ab0CHXik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 18:38:40 -0500
Received: by bwz1 with SMTP id 1so3375313bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 08 Mar 2010 15:38:39 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Deauthentications with p54usb
Date: Tue, 9 Mar 2010 00:38:34 +0100
References: <1756555272@web.de> <4A7F314E.7050808@lwfinger.net>
In-Reply-To: <4A7F314E.7050808@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201003090038.34884.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Larry,

Remember?

On Sunday 09 August 2009 22:27:58 Larry Finger wrote:
> Chunkeey@web.de wrote:
> > Ahh, wait... screw up: I failed to explain the difference between:
> > 
> > - powersave (=> responsible for your connection problems)
> >    In this mode: the device goes into a lower power state,
> >    but continues to listen for dtim beacons and multicast frames,
> >    from the AP.
> > 
> >    mac80211 does not have printks for these ps events,
> >    since the device power state may chance every second.
> > 
> >    howeve, it's possible to trace them through the generic _trace_
> >    framework with MAC80211_DRIVER_API_TRACER Kconfig
> >    option enabled.
> >    
> > vs. 
> > 
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
> hibernate (suspend to disk) or sleep (suspend to RAM). The last time I
> tried it had one or more drivers that would not cooperate, and I have
> not tried recently.
> 
> I'll try to collect a dump.
> 
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

Obviously, there has been a lot of progress on power saving.
Can you please retest if p54(usb) link is still dying when
PSM is enabled?

(NB: the easiest way to enable/disable PSM: iwconfig wlanX power on/off,
 no need to recompile/rebuild the module)

Regards,
	Chr
