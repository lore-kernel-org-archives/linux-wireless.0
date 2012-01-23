Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44804 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab2AWU6I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 15:58:08 -0500
Message-ID: <4F1DC9D4.8090008@hauke-m.de> (sfid-20120123_215815_279556_C9AB8039)
Date: Mon, 23 Jan 2012 21:57:56 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <greg@kroah.com>, ralf@linux-mips.org,
	linux-mips@linux-mips.org, USB list <linux-usb@vger.kernel.org>,
	zajec5@gmail.com, linux-wireless@vger.kernel.org, m@bues.ch,
	george@znau.edu.ua
Subject: Re: [PATCH 4/7] USB: EHCI: Add a generic platform device driver
References: <Pine.LNX.4.44L0.1201231115280.1372-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1201231115280.1372-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/23/2012 05:29 PM, Alan Stern wrote:
> On Sun, 22 Jan 2012, Greg KH wrote:
> 
>> On Sun, Jan 22, 2012 at 04:02:13PM +0100, Hauke Mehrtens wrote:
>>> On 01/22/2012 04:41 AM, Alan Stern wrote:
>>>> On Sat, 21 Jan 2012, Hauke Mehrtens wrote:
>>>>
>>>>> This adds a generic driver for platform devices. It works like the PCI
>>>>> driver and is based on it. This is for devices which do not have an own
>>>>> bus but their EHCI controller works like a PCI controller. It will be
>>>>> used for the Broadcom bcma and ssb USB EHCI controller.
>>>>
>>>> Before adding a generic platform driver for EHCI, you should give some
>>>> to thought to how it might be generalized.  There are a lot of EHCI
>>>> platform drivers, all differing in various major or minor respects.  
>>>> It should be possible to replace a lot of them with the generic driver, 
>>>> but first it will need some way to cope with a few minor quirks.
>>>>
>>>> Please consider this, and think about which of the existing drivers 
>>>> could be replaced.
>>>
>>> For now I just build this for bcma and ssb based SoCs. Yes there are
>>> some drivers which could be replaced with this one, but most (all ??) of
>>> them do something special in the device probing and this have to be
>>> moved to somewhere else e.g. where the platform device is created.
>>> I could rename it so it would not be generic any more, but I think it is
>>> the wrong approach. ;-)
>>> I am not able and do not have the time to convert all EHCI platform
>>> drivers, where it is possible  to this generic platform driver, as I do
>>> not have the devices to test this and time is limited.
>>
>> Time is not limited for us, sorry, this seems like the correct thing to
>> do, and because of that, we (well I at least) will not accept this patch
>> as-is.
>>
>> Please go rework it to be as Alan suggested.
>>
>>> If someone else wants to improve something on these "generic" platform
>>> drivers to make them work with an other device I am totally fine with it.
>>
>> I think that someone just became you :)
>>
>> Yes, this isn't fair, but it's how Linux kernel development works,
>> sorry.
> 
> The work doesn't have to be all done right away.  Still, I think it 
> makes sense to separate out the "generic platform" drivers from the 
> rest of this patch series.
Ok, but how should these patches being merged as my plan is to get them
all into 3.4 in some way? The bcma hcd driver depends on changes in
drivers/bcma and will also depend on these generic platform driver.

> Some platform drivers require additional storage for things like
> pointers to clocks or OTG transceivers.  For example see ehci-mv.c,
> which allocates its own ehci_hcd_mv structure along with ehci_hcd.  
> Some other drivers even define their own private version of ehci_hcd,
> such as ehci-fsl.c.  If you can figure out a good way to expend the
> ehci_hcd structure so that it can accomodate the extra fields needed by
> all these drivers in a generic way, that would be an excellent start
> and well worth merging.  Maybe just adding a "void *platform_data"
> field would be enough.
Yes I will have a look at most/all these drivers and will come up with a
new version of the generic platform driver in some days. Thanks for
these examples you mentioned.

> As for special activities during device probing...  Many of these can 
> be handled later on, easily enough, by adding appropriate quirk flags.  
> We don't have to worry about that part right now.
Yes I also thought about such flags.

> Alan Stern
> 

Hauke

