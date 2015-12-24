Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37622 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbbLXWiF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 17:38:05 -0500
Received: by mail-wm0-f44.google.com with SMTP id p187so193615372wmp.0
        for <linux-wireless@vger.kernel.org>; Thu, 24 Dec 2015 14:38:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <wrfjpoxxxvjq.fsf@redhat.com>
References: <1450664916-25205-1-git-send-email-dlenski@gmail.com>
 <1450664916-25205-2-git-send-email-dlenski@gmail.com> <56783C98.1080700@lwfinger.net>
 <CAOw_LSF6cPVCxqOS1eQ+iqESZGRdG46048M15r5s0huVJVHwjg@mail.gmail.com> <wrfjpoxxxvjq.fsf@redhat.com>
From: Daniel Lenski <dlenski@gmail.com>
Date: Thu, 24 Dec 2015 14:37:24 -0800
Message-ID: <CAOw_LSHr-gcrOCrGe8+K6=ndQx21O_HzrxLXJDXnZV5EBJeeyQ@mail.gmail.com> (sfid-20151224_233810_074796_95DC7AF0)
Subject: Re: [PATCH] enable setting MAC address for r8723au
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 23, 2015 at 3:18 AM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> Daniel Lenski <dlenski@gmail.com> writes:
>> On Mon, Dec 21, 2015 at 9:53 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>> On 12/20/2015 08:28 PM, Dan Lenski wrote:
>>>>
>>>> Signed-off-by: Dan Lenski <dlenski@gmail.com>
>>>
>>>
>>> The commit message should be in this patch rather than in the non-patch
>>> previous mail. If this patch were to be accepted, all that explanation would
>>> be lost!
>>>
>>> Rather than issuing a warning when the MAC is changed after the interface
>>> has been brought up, have you considered changing the value of
>>> rtw_adapter->bup to zero whenever the connection goes down? Would that help
>>> with the confusion in the user-space tools?
>>
>> No. rtw_adapter isn't visible to userspace at all. NetworkManager, for
>> instance, seems to get confused when *any* up interface changes its
>> MAC address.
>>
>> bup should *not* be reset to zero when the device is closed.
>> netdev_open23a() checks or bup==0 and calls rtl8723au_hal_init() to do
>> hw initialization and firmware download if so. This is unnecessary
>> after subsequent re-opening, which is why netdev_close() doesn't set
>> bup=0.
>>
>>> NACK.
>>
>> I'll resubmit with the commit message fixed and the warning removed.
>>
>
> In addition, do *not* overwrite the eeprompriv.mac_addr - that struct is
> a clean copy of the eeprom's data and should not be modified.
>
> Please changed the dev entry and make sure they driver updates from
> there instead.

I left that part alone (overwriting the eeprompriv.mac_addr) because
the existing code relies on it containing the correct *current* MAC
address in numerous places. But, fair enough.

This will require a much more complex patch, because there are
numerous functions which assume that eeprompriv.mac_addr is the
current address. (And some of these functions only receive the struct
rtw_adapter as an argument, rather than the complete netdev.)

> Second, please CC me directly as the driver maintainer.
>
> For longer term, please try out rtl8xxxu, hopefully we can
> rm -rf drivers/staging/rtl8723au soon.

Woah, I didn't know that driver existed. I will take a look.

Thanks,
Dan
