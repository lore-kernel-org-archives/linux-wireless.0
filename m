Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35857 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab1IQBtS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 21:49:18 -0400
Received: by yxm8 with SMTP id 8so3292851yxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 18:49:17 -0700 (PDT)
Message-ID: <4E73FC9A.8090901@lwfinger.net> (sfid-20110917_034923_164622_3CAFAACB)
Date: Fri, 16 Sep 2011 20:49:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Simeon Nifos <archwndas@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: deactivating one of the two wireless connections
References: <CAL1uj0zX5gGHkQny7fE3xrVm9HgP3PvC+ff2g7sunzNvXzgu=g@mail.gmail.com>
In-Reply-To: <CAL1uj0zX5gGHkQny7fE3xrVm9HgP3PvC+ff2g7sunzNvXzgu=g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/16/2011 08:33 PM, Simeon Nifos wrote:
> Dear all,
>
> I have a USB wireless card apart from the laptops one. The Gnome
> NetworkManager sees both when I plugin the USB wireless adapter. The
> problem is that for saving power I would like to turn off the wireless
> adapter of my laptop. However, if I use the laptops switch that turns
> off laptops wireless, the Network Manager, turns off both connections
> saying: Deactivated by Hardware switch or something similar.
>
> The problem is that I usually want to connect with my wireless USB
> adapter which has a directional antenna and provides better signal and
> higher download speeds. However, after some minutes automatically by
> itself the laptops adapter connects to the same access point and then
> I lose the connection. I can do something like:
>
> # ifconfig wlan0 down
>
> and deactivate the laptops adapter, but this is a simple ad-hoc solution.
>
> My impression is that the hardware switch on the keyboard of the
> laptop should not control all wireless connections. It is entirely
> wrong. If I wnt my USB connection to be deactivated I just unplug it.
> If I want to use it I just plug it in. This is how things should be.
> Removable devices should be powered on when connected and powered off
> when disconnected. For as long as it remains connected that means I
> want it to function as it is supposed to do so. I do not see why
> switching off my laptop's device switches off every other wireless
> device.
>
> Is there any easy fix for that?

I usually have several wireless devices plugged into my computer at one time. 
When I use the NM applet to select one of them, it will stay selected unless it 
goes offline. Does dmesg show any disconnects?

The switch is doing exactly what it should. Any RF blocking switch should 
disable ALL radios to enforce radio safety.

Downing the interface is a perfectly good solution. If you want to minimize the 
power usage, you can unload the driver for the built-in wireless adapter using 
"modprobe -r" to disable it. If you never want to use it, then blacklist that 
driver.

Larry
