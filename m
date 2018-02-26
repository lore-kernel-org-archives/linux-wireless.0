Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:50729 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751794AbeBZWZH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 17:25:07 -0500
Received: by mail-wm0-f66.google.com with SMTP id w128so14463482wmw.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Feb 2018 14:25:07 -0800 (PST)
Subject: Re: [PATCH 2/3] mwifiex: support sysfs initiated device coredump
To: Brian Norris <briannorris@chromium.org>,
        Johannes Berg <johannes@sipsolutions.net>
References: <1519210220-22437-1-git-send-email-arend.vanspriel@broadcom.com>
 <1519210220-22437-3-git-send-email-arend.vanspriel@broadcom.com>
 <20180221225903.GA42395@rodete-desktop-imager.corp.google.com>
 <5A8EB4F4.2030103@broadcom.com>
 <20180222193547.GA78462@rodete-desktop-imager.corp.google.com>
 <5A8FEF68.5080900@broadcom.com> <1519383062.2231.5.camel@sipsolutions.net>
 <CA+ASDXNogjhRvB_yGO7t4um5KbkJiMVLeed6TTe7um59aS3vDg@mail.gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless@vger.kernel.org,
        Linux Bluetooth mailing list
        <linux-bluetooth@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A948942.6090102@broadcom.com> (sfid-20180226_232535_195392_679D0ACA)
Date: Mon, 26 Feb 2018 23:25:06 +0100
MIME-Version: 1.0
In-Reply-To: <CA+ASDXNogjhRvB_yGO7t4um5KbkJiMVLeed6TTe7um59aS3vDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/26/2018 11:06 PM, Brian Norris wrote:
> Hi,
>
> On Fri, Feb 23, 2018 at 2:51 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Fri, 2018-02-23 at 11:39 +0100, Arend van Spriel wrote:
>>
>>>>> Well, that depends on the eye of the beholder I guess. From user-space
>>>>> perspective it is asynchronous regardless. A write access to the coredump
>>>>> sysfs file eventually results in a uevent when the devcoredump entry is
>>>>> created, ie. after driver has made a dev_coredump API call. Whether the
>>>>> driver does that synchronously or asynchronously is irrelevant as far as
>>>>> user-space is concerned.
>>>>
>>>> Is it really? The driver infrastructure seems to guarantee that the
>>>> entirety of a driver's ->coredump() will complete before returning from
>>>> the write. So it might be reasonable for some user to assume (based on
>>>> implementation details, e.g., of brcmfmac) that the devcoredump will be
>>>> ready by the time the write() syscall returns, absent documentation that
>>>> says otherwise. But then, that's not how mwifiex works right now, so
>>>> they might be surprised if they switch drivers.
>>
>> I can see how you might want to have that kind of behaviour, but you'd
>> have to jump through some hoops to see if the coredump you saw is
>> actually the right one - you probably want an asynchronous coredump
>> "collector" and then wait for it to show up (with some reasonable
>> timeout) on the actual filesystem, not on sysfs?
>>
>> Otherwise you have to trawl sysfs for the right coredump I guess, which
>> too is possible.
>
> It's not that I want that interface. It's that I want the *lack* of
> such an interface to be guaranteed in the documentation. When the
> questions like "where? when?" are not answered in the doc, users are
> totally allowed to speculate ;) Perhaps the "where" can be deferred to
> other documentation (which should probably exist someday), but the
> "when" should be listed as "eventually; or not at all; listen for a
> uevent."

Agree. Will extend/improve the ABI documentation.

>>>>> You are right. Clearly I did not reach the end my learning curve here. I
>>>>> assumed referring to the existing dev_coredump facility was sufficient, but
>>>>> maybe it is worth a patch to be more explicit and mention the uevent
>>>>> behavior. Also dev_coredump facility may be disabled upon which the trigger
>>>>> will have no effect in sysfs. In the kernel the data passed by the driver is
>>>>> simply freed by dev_coredump facility.
>>>>
>>>> Is there any other documentation for the coredump feature? I don't
>>>> really see much.
>>>
>>> Any other than the code itself you mean? I am not sure. Maybe Johannes
>>> knows.
>>
>> There isn't really, it originally was really simple, but then somebody
>> (Kees perhaps?) requested a way to turn it off forever for security or
>> privacy concerns and it became more complicated.
>
> Then I don't think when adding a new sysfs ABI, we should be deferring
> to "existing dev_coredump facility [documentation]" (which doesn't
> exist). And just a few words about the user-facing interface would be
> nice for the documentation. There previously wasn't any official way
> to trigger a dump from userspace -- only from random debugfs files, I
> think, or from unspecified device failures.

That was my main motivation to have this. The debugfs method did not 
feel quite right as there is no kconfig dependency between dev_coredump 
and debugfs. Now I discussed with Johannes about adding code into the 
dev_coredump facility, but that seemed to add a lot of complexity. So I 
looking into the device driver core and found it to be the simpler solution.

>>>> static ssize_t coredump_store(struct device *dev, struct device_attribute *attr,
>>>>                          const char *buf, size_t count)
>>>> {
>>>>      device_lock(dev);
>>>>      if (dev->driver->coredump)
>>>>              dev->driver->coredump(dev);
>>>>      device_unlock(dev);
>>>>
>>>>      return count;
>>>> }
>>>> static DEVICE_ATTR_WO(coredump);
>>>>
>>>> Is that a bug or a feature?
>>>
>>> Yeah. Let's call it a bug. Just not sure what to go for. Return the
>>> error or change coredump callback to void return type.
>>
>> I'm not sure it matters all that much - the underlying devcoredump
>> calls all have no return value (void), and given the above complexities
>> with the ability to turn off devcoredumping entirely you cannot rely on
>> this return value to tell you if a dump was created or not, at least
>> not without much more infrastructure work.
>
> Then perhaps it makes sense to remove the return code before you
> create users of it.

Yup. Will sent out a patch for that as well.

Thanks,
Arend
