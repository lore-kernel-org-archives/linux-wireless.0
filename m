Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53763 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1J0PEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 11:04:51 -0400
Received: by ggnb1 with SMTP id b1so2725162ggn.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Oct 2011 08:04:50 -0700 (PDT)
Message-ID: <4EA97323.50004@lwfinger.net> (sfid-20111027_170454_411318_64442BD2)
Date: Thu, 27 Oct 2011 10:05:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Roman Proud <setamagiga@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8188RU no injection?
References: <CAF7qGM4BL10gn2786kW73sAk8f-y8CzX0rx2BQsY_Q96W=pfog@mail.gmail.com> <4EA89B8D.7060104@lwfinger.net> <CAF7qGM7hfaz0SGiZVZ62r_nPO8viMT5F2_Kd1uRxN9Ha3mRO+Q@mail.gmail.com>
In-Reply-To: <CAF7qGM7hfaz0SGiZVZ62r_nPO8viMT5F2_Kd1uRxN9Ha3mRO+Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/27/2011 08:17 AM, Roman Proud wrote:
> Hi peops
>
> thx for all youre responses!
>
> Well i didnt really thought about g and n -.-
>
> Im using the latest 8192cu driver from Realtek now, it works just
> fine. Also monitor mode works like a charm (yes if i use airmon-ng for
> it). My Kernel is (now the default) Arch kernel, on Linux Version
> 3.0.4
>
> My last problem is the Package injection. Im surprised you are
> thinking it could work (ive found many resources that say something
> different, but hey its an OpenSource driver ;)

Well, I tested with Packetspammer and it worked. As in many cases, the resources 
that say otherwise are wrong.

> Pls excuse my "stupidness" but im really not sure if i am using
> "mac80211", i think so, its leaded in the System.

The drivers for most devices without a hardware MAC use mac80211 and friends. In 
fact, it is a prerequisite for getting a driver included in the mainline 
drivers/net/wireless/ tree. If the driver implements its own MAC layer, then it 
resides in drivers/staging/. Yes, it is loaded on your system, and it handles a 
lot of things for the drivers that use it.

> And yes its Aircrack im trying to work with, and its Aircrack which
> tells me i cant use Packet Injection.
> I will try Packetspammer as soon as i am at home. If this works i have
> to contact Aircrack, am i right?

If Aircrack adds the socket method used by Packetspammer, it will work with 
nearly every driver in the kernel that supports monitor mode. Whether they want 
to do that will be their decision, of course.

Larry
