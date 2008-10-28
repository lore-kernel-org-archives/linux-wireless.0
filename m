Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from basicbox7.server-home.net ([195.137.212.29]:54677 "EHLO
	basicbox7.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbYJ1IGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 04:06:21 -0400
Message-ID: <4906C7FA.8040804@leemhuis.info> (sfid-20081028_090626_355983_6BC2191B)
Date: Tue, 28 Oct 2008 09:06:18 +0100
From: Thorsten Leemhuis <fedora@leemhuis.info>
MIME-Version: 1.0
To: Luis Correia <luis.f.correia@gmail.com>
CC: Thorsten Leemhuis <fedora@leemhuis.info>, Greg KH <greg@kroah.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: rtl2860 driver in mainline?
References: <20081028004915.GA3442@kroah.com> <4906B944.4010105@leemhuis.info> <efe7343f0810280048j57158020n67176d7a56f0bbea@mail.gmail.com>
In-Reply-To: <efe7343f0810280048j57158020n67176d7a56f0bbea@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28.10.2008 08:48, Luis Correia wrote:
> On Tue, Oct 28, 2008 at 07:03, Thorsten Leemhuis <fedora@leemhuis.info> wrote:
>> On 28.10.2008 01:49, Greg KH wrote:
>>> So, on my quest to suck up every out-of-tree driver and get it into the
>>> main kernel tree (drivers/staging/ to start with), I've been pointed at
>>> the rtl2860 driver.
>> Does it really make sense to include a driver when a different one for
>> mainline inclusion is being actively developed? It might give some
>> developers the impression that it's worth spending time improving the
>> rtl2860/2870 drivers -- which might be wasted time in the end.
> 
> Is it just me or you are suggesting we use the Ralink supplied driver,
> with its own wireless stack, rather then work with the rt2x00 team?

No, I'm definitely not suggesting that! In fact it's the other way 
around: I wondering if it's more harm- than helpful to include the 
current Ralink supplied driver as staging driver.

Or, to say it more directly: I think the Ralink drivers should not get 
included as staging driver, as that might track away resources from the 
rt2x00 effort (just my 2 cent as LKML and linux-wlan lurker of course).

 > [...]
>>> Does anyone know of a "cleaned up" version of this driver that is
>>> newer/better than the one on ralink's web site?  I found the
>>> 2008_0918_RT2860_Linux_STA_v1.8.0.0.tar.bz2 version there, and will
>>> start with that if no one else has yet.
>>>
>>> Any pointers are appreciated.
>> You can find a few patches (needed for 2.6.26 and 2.6.27 iirc; not sure if
>> they are enough to make it work on current mainline) for both rt2860 and
>> rt2870 in CVS for RPM Fusion:
>>
>> http://cvs.rpmfusion.org/viewvc/rpms/rt2860-kmod/devel/?root=free
>> http://cvs.rpmfusion.org/viewvc/rpms/rt2870-kmod/devel/?root=free
> 
> This seems to be only a set of 'mixed-up-lets-just-use-ralink-code' patchset.

Sure -- nevertheless those patches might be helpful for Greg, that's why 
I pointed him there.

BTW, RPM Fusion provides the drivers just as a interim solution for 
Fedora users, as there was quite some demand for it (even from one well 
known kernel developer who actually created the initial rt2860 package 
for Livna/RPM Fusion); soon after a working and stable driver with a 
similar featureset is in mainline and shipped as update by Fedora we'll 
stop providing those drivers from Ralink.

> p.s. I apologize in advance if I misunderstood the meaning of the
> original reply.

np ;-)

CU
knurd
