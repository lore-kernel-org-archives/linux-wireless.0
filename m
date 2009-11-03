Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37215 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753923AbZKCUZo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 15:25:44 -0500
Message-ID: <4AF09028.1000100@gmx.net>
Date: Tue, 03 Nov 2009 21:18:48 +0100
From: Frank Schaefer <schaefer.frank@gmx.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB
 N devices in cdrom mode
References: <200910171606.02961.oliver@neukum.org>	 <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org>	 <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net>	 <4AEDCCA0.8050709@gmx.net> <4AEDD380.40408@draisberghof.de>	 <4AEDEB85.5080105@gmx.net> <20091102005144.GE24436@one-eyed-alien.net>	 <4AEF3CAD.10809@gmx.net> <1257193115.1027.24.camel@localhost.localdomain>
In-Reply-To: <1257193115.1027.24.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams schrieb:
> On Mon, 2009-11-02 at 21:10 +0100, Frank Schaefer wrote:
>   
>> Matthew Dharm schrieb:
>>     
>>> On Sun, Nov 01, 2009 at 09:11:49PM +0100, Frank Schaefer wrote:
>>>       
>>>> Josua Dietze schrieb:
>>>>         
>>>>> Frank Schaefer schrieb:
>>>>>       
>>>>>           
>>>>>> I really think the mode-switching should be done in the kernel and not
>>>>>> in user-space for reasons of usability.
>>>>>>             
>>>>> What is wrong with an udev rule entry? By the way, did the "eject"
>>>>> command line tool work as well?
>>>>>           
>>>> It returns an error but the device is ejected.
>>>> But do you really want the users to open a terminal window and call
>>>> "eject" each time they plug their device in ;) ?
>>>>         
>>> If 'eject' worked, then why not use a simple udev entry?  That way nobody
>>> has to call anything by hand...
>>>
>>> Matt
>>>       
>> And who will create this udev-entry ;) ? How can you make sure that this
>> is done on all systems ?
>>     
>
> You can't.  The distros have to make sure it works.
Right, and here the trouble begins.
The driver and the mode-switch needed to use it must come from the same
source.
Otherwise we will always have inconsistencies.
>   Personally, I think
> these should all be in the kernel, but the kernel doesn't contain
> policy.  And unfortunately, for some devices (3G modems specifically)
> ejecting the driver CD thing *is* policy.  
Hmm, policy...
Talking about the large group of devices with a driver-disk-mode only:
Isn't an installed driver for the device the policy itself, because it
makes the driver-disk obsolete !?
> Option for example protested
> mightily when I sent a patch to auto-eject their driver CD, because they
> apparently do use the driver CD thing to send Linux drivers and software
> to a few clients.  But by and large, the driver CD is completely
> useless.
>
> Devices with fake driver CDs and how they are handled currently:
>
> Zydas WLAN   - kernel
> Huawei 3G    - kernel  (unusual_devs entry)
> Sierra 3G    - kernel  (drivers/usb/serial/sierra.c)
> Option 3G    - udev rules, 'rezero', or usb_modeswitch
> ZTE 3G       - udev rules, simple 'eject'
>
> Dan
>   
I can't see any real problems having device-(group-)specific policies
and switching-solutions.
Of course, it would be nice to have a common solution for all, but the
devices are too different.
Therefore the compromises we have to make should be individual (to a
certain degree).

Frank

