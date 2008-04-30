Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:41889 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078AbYD3DFe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2008 23:05:34 -0400
Message-ID: <4817E1FE.30407@lwfinger.net> (sfid-20080430_050530_672702_022657FE)
Date: Tue, 29 Apr 2008 22:05:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Gautam Iyer <gi1242@stanford.edu>, linux-wireless@vger.kernel.org
Subject: Re: b43 LED status (was Re: b43 reduced performance in Linux-2.6.25)
References: <20080429215629.GC17790@stanford.edu> <4817A28E.2050309@lwfinger.net> <20080429233045.GA26484@stanford.edu> <4817B548.30303@lwfinger.net> <20080430010502.GA17871@stanford.edu>
In-Reply-To: <20080430010502.GA17871@stanford.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gautam Iyer wrote:
> On Tue, Apr 29, 2008 at 06:54:48PM -0500, Larry Finger wrote:
> 
>>> I don't have Windows so can't compare to it. But even though I use b43
>>> by default, I sometimes have to revert to ndiswrapper on weak signals or
>>> large file transfers. Also ndiswrapper has the power management and
>>> LED's working correctly, which I could not get working with the b43
>>> driver.
>> What LEDS does your interface, and what do they not do? If the only
>> LED you have is the one attached to the rfkill switch, then you have
>> not properly configured the LED parameters.
> 
> Yes, the only LED I have is attached to my rfkill switch. It becomes
> blue when I load the b43 kernel module, and becomes red when I unload
> it. I was hoping I could set it so that it becomes blue when in use
> (i.e. associated), and red otherwise. (This happens with ndiswrapper).
> 
> I remember messing with the LED power / brightness files in /sys. But
> nothing I echoed in there changed the state of the LED. Is there some
> parameter I'm missing?

You need the following LED- and rfkill-related parameters in your configuration:

CONFIG_MAC80211_LEDS=y
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y
CONFIG_B43_LEDS=y
CONFIG_B43_RFKILL=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m
CONFIG_LEDS_TRIGGERS=y

The last one may not be necessary, but the others are. With this setup, the 
LED will be blue when b43 is loaded _AND_ the rfkill switch is on, and red 
when the rfkill switch is off, or b43 is unloaded.

Larry

