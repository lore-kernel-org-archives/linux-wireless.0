Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:59350 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaL0UG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2014 15:06:28 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so19119711wiw.16
        for <linux-wireless@vger.kernel.org>; Sat, 27 Dec 2014 12:06:26 -0800 (PST)
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: Unable to disable WiFi with 3.19-rc1 - iwlwifi 7260
Date: Sat, 27 Dec 2014 21:06:24 +0100
Message-ID: <2280989.3hu2uPCZ1b@xps13> (sfid-20141227_210632_257559_08931A4D)
In-Reply-To: <1419709679.5162.2.camel@egrumbacBox>
References: <3095419.huSVmtL0ib@xps13> <CA+icZUVsmoPE8Le4XeyBratXe23BFtgOEoyd6dBFC9x+MVaJFw@mail.gmail.com> <1419709679.5162.2.camel@egrumbacBox>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 27 December 2014 19:47:59 Grumbach, Emmanuel wrote:
> Hi,
> 
> On Sat, 2014-12-27 at 20:17 +0100, Sedat Dilek wrote:
> > On Sat, Dec 27, 2014 at 8:08 PM, Gabriele Mazzotta
> > <gabriele.mzt@gmail.com> wrote:
> > > Hi,
> > >
> > > since v3.19-rc1 I have problems with WiFi (Intel Corporation Dual Band
> > > Wireless-AC 7260) on my laptop. Trying to disable all the radio devices
> > > (WiFi and BT) with the function key of my laptop, which should hard
> > > block the rfkills, causes the following message to be repeated over and
> > > over until I re-enable them again with the function key:
> > >
> > > [  593.746001] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
> > > [  593.746468] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
> > > [  593.746781] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
> > > [  593.747091] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
> > >
> > > Sometimes my laptop hangs when I try to toggle the state of the radio
> > > devices and have to forcefully reboot it.
> > >
> > > Reverting 522713c81e ("iwlwifi: pcie: properly reset the device") seems
> > > to fix the problem. I haven't tried anything else since this was the
> > > first thing I tried.
> > >
> > > Does anyone know what's the problem with that specific commit?
> > > I will gladly provide any additional information, just tell me what
> > > is needed.
> > >
> > 
> > I cannot say much to the "internals" of your problem
> 
> Thanks for jumping in :)
> 
> > 
> > Just two things...
> > 
> > There is a new firmware for 7260 around see [0].
> > 
> 
> This won't help.
> 
> > 2nd try to pull in the new wireless-drivers.git tree, the changelog
> > mentions a race with rfkill on iwlwifi [1].
> > 
> 
> This will help :) Precisely commit:
> https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/iwlwifi-fixes.git/commit/?id=03d6c3b0fa4f5f0379cede079ec828a6c999fe43

Somehow I missed it, the commit is even mentioned there.
I should have tried to pull the new changes first. I confirm that
everything works with wireless-drivers-for-davem-2014-12-26.

Thank you both for the quick replies.

> > Have fun!
> > 
> > - Sedat -
> > 
> > [0] http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/commit/?id=a876c69f042cf4732755b325d3b709125bb51a06
> > [1] http://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers.git/tag/?id=wireless-drivers-for-davem-2014-12-26
> 
> 
