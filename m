Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:39289 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaEWOvf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 10:51:35 -0400
Received: by mail-oa0-f47.google.com with SMTP id i7so5686908oag.34
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 07:51:34 -0700 (PDT)
Message-ID: <537F606E.6030808@lwfinger.net> (sfid-20140523_165138_530053_F952EB02)
Date: Fri, 23 May 2014 09:51:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Marc_St=FCrmer?= <mail@marc-stuermer.de>,
	linux-wireless@vger.kernel.org
Subject: Re: Rtl8192CU: regular disconnect in managed mode after a short while
References: <537F0A21.5070102@marc-stuermer.de>
In-Reply-To: <537F0A21.5070102@marc-stuermer.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2014 03:43 AM, Marc Stürmer wrote:
> Greetings,
>
> I've recently bought myself an USB device, based on the RTL8192CU chipset,
> running under 64bit kernel 3.15.0-rc6 at the moment.
>
> Firmware is installed where it should be.
>
> Debuglog of the kernel is here: http://pastebin.com/Eh6pBbra
>
> The problem is this: I am running the device in managed mode and let it connect
> to my AP.
>
> First all works as intended, but after a short while the device always stops
> working altogether.
>
> No output in the kernel log, not even about deauthenticating but it just stops
> working at all, no traffic anymore, I've got to unplug it or unload and reload
> the driver and then the same starts all over again.
>
> This seems to be a long lasting regression
> (https://www.google.com/#q=linux+rtl8192cu+disconnects+linux+) and there's also
> a repository on Github containing the original Realtek driver ported up to
> kernel version 3.11 (https://github.com/pvaret/rtl8192cu-fixes), because the
> kernel driver seemed to be not working flawlessly until then.
>
> So my question is: what else could/should I do to get a stable, working wifi
> connection with that device on my linux box that lasts more than just a few
> minutes?

Looking at your kernel log, the first thing I see is

[  295.926536] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
[  295.926578] usbcore: registered new interface driver rtl8192cu
[  295.949364] usb 3-9: Direct firmware load failed with error -2
[  295.949366] usb 3-9: Falling back to user helper
[  295.955563] rtlwifi: Loading alternative firmware rtlwifi/rtl8192cufw.bin

You should try the newest firmware. If you have updated your code base recently, 
then your distro apparently does not supply it. You should get the latest copy 
of firmware with

git clone git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
sudo cp linux-firmware/rtlwifi/rtl8192cufw_TMSC.bin /lib/firmware/rtlwifi/.

Yes, there are a number of users that are unhappy with this driver. Realtek 
provided it, and then abandoned it. I have no knowledge of its internals and the 
only documentation I have is what is in the driver code.

In the past, I have tried to solve problems that users have posted, but all of 
those efforts eventually have stalled because those users have failed to answer 
NEEDINFO queries, or the equivalent, in a timely fashion. I either have 
forgotten what we were trying to do, or I have had to move onto a more pressing 
problem. At the moment, I do have some time.

Load the driver with 'modprobe -v rtl8192cu debug=3' and post the from when the 
driver is loaded until it fails.

Larry

