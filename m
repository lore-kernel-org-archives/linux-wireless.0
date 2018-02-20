Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:43009 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbeBTVS2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 16:18:28 -0500
Received: by mail-qt0-f195.google.com with SMTP id d26so18243195qtk.10
        for <linux-wireless@vger.kernel.org>; Tue, 20 Feb 2018 13:18:28 -0800 (PST)
Subject: Re: [RFC PATCH 0/2] net: rfkill: gpio: Fix and support SerDev
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Carlo Caione <carlo@endlessm.com>, Carlo Caione <carlo@caione.org>,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        frederic.danis.oss@gmail.com, sebastian.reichel@collabora.co.uk,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Upstreaming Team <linux@endlessm.com>
References: <20180220134618.12972-1-carlo@caione.org>
 <31f0157f-4778-2f9c-977f-8bdbba6f52a4@redhat.com>
 <CAL9uMOEFm4apUrDxs6GkZqV2S=mepd2Ytcna+SCaLnCcwtcfeg@mail.gmail.com>
 <c1f7d6a5-7b31-e3e2-870c-ccc0dd2fca20@redhat.com>
 <CAFBinCCc6yAWgVm85gTeGr_=y0B=H0j1et1r=V10ycX4pKCZVg@mail.gmail.com>
From: Jeremy Cline <jcline@redhat.com>
Message-ID: <9c385301-dae6-9d7c-a510-2b210eaf05bc@redhat.com> (sfid-20180220_221832_531130_1D10766F)
Date: Tue, 20 Feb 2018 16:18:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAFBinCCc6yAWgVm85gTeGr_=y0B=H0j1et1r=V10ycX4pKCZVg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Martin,

On 02/20/2018 03:26 PM, Martin Blumenstingl wrote:
> Hello Jeremy, Hello Hans,
> 
> On Tue, Feb 20, 2018 at 5:15 PM, Hans de Goede <hdegoede@redhat.com> wrote:
>> Hi,
>>
>> On 02/20/2018 03:36 PM, Carlo Caione wrote:
>>>
>>> On Tue, Feb 20, 2018 at 2:01 PM, Hans de Goede <hdegoede@redhat.com>
>>> wrote:
>>>>
>>>> Hi Carlo,
>>>
>>>
>>> Hi Hans,
>>>
>>>> Is this for devices with a RTL8723BS chip? If so then they
>>>> still will not work after this since there also no longer is
>>>> a /dev/ttyS4 created for the UART for the bluetooth, instead
>>>> you probably want:
>>>>
>>>>
>>>> https://github.com/jwrdegoede/linux-sunxi/commit/c383dac5ea00738ac01d704d820aa548494fcd41
>>>>
>>>> Which also puts the /dev/ttyS4 back in place.
>>>
>>>
>>> Yeah, this problem came up while working on the RTL8723BS chip but the
>>> driver is also broken for the other two GPS devices supported by this
>>> driver.
>>> Thank you for the patch BTW.
>>>
>>>> Regards,
>>>>
>>>> Hans
>>>>
>>>> p.s.
>>>>
>>>> My college Jeremy Cline in the Cc is looking into getting proper
>>>> bluetooth support in place for the rtl8723bs using serdev binding
>>>> and having everything in the kernel, as we now already do for bcm
>>>> uart bluetooth modules.
>>>
>>>
>>> Wasn't also Martin (+CC) working on this? See
>>> https://www.spinics.net/lists/linux-bluetooth/msg73594.html
> thank you for CC'ing me Carlo!
> 
>> Ah I did not know that, cool.  Jeremy, this is probably a good starting
>> point :)   And you should probably coordinate with Martin on this.
> the status on this is:
> - Marcel wrote a tool to parse the config blob: [0]
> - the first patch from my series called "serdev: implement parity
> configuration" is now obsolete because an improved version from Ulrich
> Hecht has been merged: [1] (this requires a trivial change to the
> "serdev_device_set_parity" call in patch #9 of my series)
> - I still have Realtek serdev support on my TODO-list but with low priority
> 
> there was a discussion what has to be done to drop the "RFC" prefix
> from my series: [3]
> the quick summary (from my point of view):
> - if possible we should get rid of the config blob (don't use it at
> all or generate it in-memory - I couldn't make either of these work so
> far but I've not spent much time on it either)
> - create a "library" for the H5 protocol (similar to the H4 protocol)
> so the Realtek code doesn't have to be part of hci_h5.c
> - add ACPI support (and not just device-tree support)
> - testing with existing Realtek USB devices is needed
> 
> I have successfully tested v2 of my series on two Amlogic boards I
> have which both come with a RTL8723BS SDIO wifi/UART Bluetooth combo
> chip.
> that said, I only looked at Bluetooth support (I didn't test wifi or
> btcoex support) and I don't have any "Realtek USB Bluetooth" dongles
> to check that I didn't break support for the existing devices
> 
> @Jeremy: I definitely won't be able to update my patches for the v4.17
> cycle (and I'm not sure how much time I can dedicate to this for the
> v4.18 cycle).
> it would be great if you could keep me CC'ed on your patches so I can
> learn and test them on the boards I have

Great, thanks for all the info! I'll definitely keep you CC'ed on my
progress. I'm still very new to kernel development so I expect it'll
take me quite a while, but I do have a fair bit of time to devote to
this.


Regards,
Jeremy
