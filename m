Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:52858 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934799Ab3DPBRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 21:17:09 -0400
Received: by mail-vc0-f175.google.com with SMTP id ib11so4374467vcb.6
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2013 18:17:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1366043660.5649.4.camel@dcbw.foobar.com>
References: <CAPutgu8mCmfmsEq0jkqtAN25oUBmCxZLW-kTZrsPKFpCfdJU2A@mail.gmail.com>
	<1365804259.10342.20.camel@dcbw.foobar.com>
	<1366032132.8361.19.camel@jlt4.sipsolutions.net>
	<1366036772.2404.3.camel@dcbw.foobar.com>
	<1366039892.8361.29.camel@jlt4.sipsolutions.net>
	<CAPutgu_3tkxZa1Yn67ZxU9m=E=xRHjPiz7b6yv48kSiw_xQnXw@mail.gmail.com>
	<1366043660.5649.4.camel@dcbw.foobar.com>
Date: Mon, 15 Apr 2013 21:17:04 -0400
Message-ID: <CAPutgu8vx8BxNm-vAGuvQDRqqo+cauayy2Gs4g_i9e-=7kkK+A@mail.gmail.com> (sfid-20130416_031714_829333_746B0017)
Subject: Re: Centrino Ultimate-N 6300 AGN rfkill always Soft blocked
From: schwaahed <schwaahed@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 15, 2013 at 12:34 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Mon, 2013-04-15 at 11:50 -0400, schwaahed wrote:
>> So I configured a kernel with hp-wmi enabled. It had the unfortunate
>> consequence of disabling wireless on the windows side. I also saw that
>> some people with different hardware from me were able to resolve their
>> problem by blacklisting hp-wmi.
>
> Ok, so that means that perhaps the airplane mode interface changed on
> your machine from earlier models in the Elitebook series.  You'll need
> to talk to the hp-wmi maintainers about how to handle your device then,
> at this point it's not a wifi issue, it's the BIOS telling the wifi
> hardware to enable/disable itself and that's causing your issues when
> trying to unblock stuff.
>

Thanks I will look for the maintainer. It seems like a few years ago
there was a Matthew Garrett dealing with some of the *-wmi modules.

Where would I go to find the present maintainer?


>> rfkill show an additional wifi interface ('hp-wifi' I think), that
>> behaves exactly as phy0 did. I still am unable to unblock this
>> interface. phy0 doesn't respond to any rfkill commands or the physical
>> wifi switch. It is just remains soft and hard blocked.
>
> Yeah, kernel driver issue for hp-wmi, of if HP isn't using WMI anymore
> then a different module.  One question though, any idea if your laptop
> uses UEFI instead of traditional BIOS?
>

I think it is UEFI but I'm not sure exactly what that means.


>> Dan -- Are there any links/search terms to older conversations on this issue?
>
> Not your specific issue that I know of, but the rfkill + BIOS
> interaction issue has been going on for years; every time the OEMs
> change the way BIOS talks to the OS and the wifi card, we need a kernel
> update of the various laptop drivers like acer-wmi, hp-wmi,
> thinkpad-acpi, etc to handle it.
>
>> Is wifi working on your 2530p?
>
> Yeah, but it's probably not relevant for your machine, since the 2530p
> is from 2009.  HP has likely changed the BIOS <-> OS interface since
> then.
>
> Dan
>

Thank you for these suggestions. It would make sense that these are
hardware issues.

-Darwin



>> Thanks
>> - Darwin
>>
>> On Mon, Apr 15, 2013 at 11:31 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Mon, 2013-04-15 at 09:39 -0500, Dan Williams wrote:
>> >
>> >> > Yeah it seems not loaded, but how then does the soft block affect hard
>> >> > block? All very odd, but almost certainly a platform rather than a wifi
>> >> > issue.
>> >>
>> >> On my 2530p and a lot of other laptops, blocking the BIOS
>> >> "switch" (either physically or softblock) hardblocks phy0.  I guess the
>> >> BIOS twiddles a GPIO that's connected to the mPCI-E module's rfkill
>> >> line/GPIO?
>> >
>> > Yes, that seems to be the case. Something does, anyway, as the GPIO
>> > state is pretty much directly reflected in the hard kill of the "phy0"
>> > device.
>> >
>> >> Which leads to the problem we've talked about a long time ago; you can't
>> >> treat phy0 hardblock as a physical block that cannot be soft-unblocked,
>> >> because some other switch might actually control it's state.  We tried
>> >> to gray-out the "Enable Wireless" when hardblocked (since logically you
>> >> can't soft-unblock something that's hardblocked), but it turns out you
>> >> can't do that because unblocking BIOS switches might un-hardblock the
>> >> phy0 wifi switch...  (and the kernel doesn't describe these
>> >> dependencies, because, well, that's laptop-specific and would never be
>> >> up-to-date).
>> >
>> > Yeah ... best thing you could do is assume that if a bios rfkill exists
>> > it controls the phy0 hard kill and in case it doesn't enable when you
>> > unblock the bios device you pop up a message saying to switch the
>> > physical button?
>> >
>> > johannes
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
