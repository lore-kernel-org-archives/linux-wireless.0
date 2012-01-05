Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3257 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab2AEO47 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 09:56:59 -0500
Message-ID: <4F05BA2B.7040504@broadcom.com> (sfid-20120105_155703_928725_8B59CEE0)
Date: Thu, 5 Jan 2012 15:56:43 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: Fabioamd87 <fabioamd87@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Brcm80211 drivers situation
References: <CAHghS26SkhET0y0RGVrATg+OUcFX7NVwTfAXvbHF2s0wrSijiQ@mail.gmail.com>
 <4F059780.8040700@broadcom.com>
 <CAHghS275Fy3dafGH_NcfnsFG9B_5aH4Rw8ruTeHvtk3688gFNA@mail.gmail.com>
In-Reply-To: <CAHghS275Fy3dafGH_NcfnsFG9B_5aH4Rw8ruTeHvtk3688gFNA@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2012 03:10 PM, Fabioamd87 wrote:
> Hi, thanks for the reply.
> 
> The driver are located in AUR package database: https://aur.archlinux.org/packages.php?ID=21690 that is not that confortable to install because you need to create packages and care about depndencies, but is ok, I succeeded to install it.
> So there is no chance to have an "out of the box" support?

That is up to the particular distro.

> My primary problem is with my laptop hp 6735b that use not phisical button but a sensible to finger area to activate/deactivate the wireless card.
> 
> On windows I can deactivate and then reactivate it correctly, On linux if I disactive it I can't reactivate. (and I need to reboot in windows, activate it, and re-reboot in linux with all boring consequences, expecially if you inaccurately disable the card passing on that area with your finger)
> 
> I tried also with rfkill but with no results.
> 
> I hope that you know how to help me.

Sorry to say, but nope. The physical RFKILL switches are pretty obscure.
They intend to disable all RF sources in the laptop. The RFKILL
subsystem within linux handles the physical switches and notifies all
wireless devices when it changes and the driver disables/enables its RF.

You could try 'rfkill event' and look what happens when you touch the
'button'. This is what I get with a switch on my laptop:

$ rfkill event
1325775232.353767: idx 0 type 1 op 0 soft 0 hard 0
1325775232.353907: idx 1 type 2 op 0 soft 0 hard 0
>> disable RF
1325775239.701387: idx 0 type 1 op 2 soft 1 hard 1
>> enable RF
1325775242.701371: idx 0 type 1 op 2 soft 0 hard 0

Gr. AvS

