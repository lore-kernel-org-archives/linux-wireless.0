Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.188]:37217 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYKPFsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2008 00:48:14 -0500
Received: by rn-out-0910.google.com with SMTP id k40so1692229rnd.17
        for <linux-wireless@vger.kernel.org>; Sat, 15 Nov 2008 21:48:13 -0800 (PST)
Message-ID: <43e72e890811152148q5f65aa43u49555a3977c205ff@mail.gmail.com> (sfid-20081116_064826_980533_97F87EB2)
Date: Sat, 15 Nov 2008 21:48:13 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Dan McGee" <dpmcgee@gmail.com>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Cc: "Bob Copeland" <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org, "Michael Buesch" <mb@bu3sch.de>
In-Reply-To: <449c10960811151838m3fcae118n65139be735c10665@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com>
	 <43e72e890811132217k160db63ch77e7d03c38e81d5f@mail.gmail.com>
	 <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com>
	 <449c10960811151811s32fdd2b6p361d2ec9dd674fcc@mail.gmail.com>
	 <449c10960811151838m3fcae118n65139be735c10665@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 15, 2008 at 6:38 PM, Dan McGee <dpmcgee@gmail.com> wrote:
> On Sat, Nov 15, 2008 at 8:11 PM, Dan McGee <dpmcgee@gmail.com> wrote:
>> On Fri, Nov 14, 2008 at 11:02 AM, Bob Copeland <me@bobcopeland.com> wrote:
>>> On Fri, Nov 14, 2008 at 1:17 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>>> If our offsets are the same then its probably on line 791:
>>> [...]
>>>> 790             name = wiphy_dev(local->hw.wiphy)->driver->name;
>>>> 791             local->hw.workqueue = create_freezeable_workqueue(name);
>>>
>>> I agree, having looked at the objdump output.  Hmm, maybe ->driver pointer
>>> is bad even though I can't see that happening.  Dan, can you try adding a
>>> printk before line 790 to see if any of the pointers are null?
>>
>> So I went back and added a few things to the original unpatched code
>> to see what was NULL pointering, just to be sure we were thinking
>> right. Here is the relevant code:
>>        printk(KERN_DEBUG "wiphy_dev() : %p\n", wiphy_dev(local->hw.wiphy));
>>        printk(KERN_DEBUG "driver      : %p\n",
>> wiphy_dev(local->hw.wiphy)->driver);
>>        printk(KERN_DEBUG "driver->name: %p\n",
>> wiphy_dev(local->hw.wiphy)->driver->name);
>>        name = wiphy_dev(local->hw.wiphy)->driver->name;
>>        local->hw.workqueue = create_freezeable_workqueue(name);
>>
>> And the dmesg output:
>> ath5k_pci xxx: registered as ''
>> wiphy_dev() : b730b408
>> driver       : 00000001
>> BUG: unalbe to handle kernel NULL pointer dereference at 00000001
>>
>> So we bugged out on trying to print driver->name, which is the same
>> problem we would have hit in the 'name =' line.
>
> I should clarify here- the real bug was when trying to access
> '->driver', as we got the 00000001 poison pointer returned (this is a
> poison value, right?).

Not sure why its 00000001, nor do I know if its poison. One thing I am
fairly positive about is that the reason why this was wrong all along
was because we were trying to get the device's ->driver structure to
get driver->name but the device won't get its ->driver pointer
assigned until *after* a successful probe. Lets review the PCI probe:

/**
 * __pci_device_probe()
 * @drv: driver to call to check if it wants the PCI device
 * @pci_dev: PCI device being probed
 *
 * returns 0 on success, else error.
 * side-effect: pci_dev->driver is set to drv when drv claims pci_dev.
 */
static int
__pci_device_probe(struct pci_driver *drv, struct pci_dev *pci_dev)
{
        const struct pci_device_id *id;
        int error = 0;

        if (!pci_dev->driver && drv->probe) {
                error = -ENODEV;

                id = pci_match_device(drv, pci_dev);
                if (id)
                        error = pci_call_probe(drv, pci_dev, id);
                if (error >= 0) {
                        pci_dev->driver = drv;
                        error = 0;
                }
        }
        return error;
}

So unless probe was successful (pci_call_probe which calls
drv->probe()) we don't update pci_dev->driver pointer.

> The above sequence of events was what took place when trying to load
> the module on startup. To see if other things had an effect, I
> disabled module autoloading during the boot sequence and got slightly
> different results but it looks to be the same type of problem:
>
> registered as ''
> wiphy_dev: b730d740
> driver: 7fffffff
> driver->name: ffffffff
> BUG: unable to handle kernel paging request at ffffffff
>
> One more note- booting with the 2.6.27.6 shipped wireless modules
> (mac80211 and ath5k) has always been working fine. It is only when I
> try to run compat-wireless on top of this kernel that we are seeing
> issues.

This is interesting, but then again the fact that it was working *all
along* for other devices is interesting too as it shouldn't have.

> Theoretically that means this should be bisectable if we
> really can't figure it out, but I'm not sure how practical that is.

Yeah don't bother, the issue on this e-mail was fixed, another issue
has come up though so that is separate.

  Luis
