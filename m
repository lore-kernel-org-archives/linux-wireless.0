Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f41.google.com ([209.85.212.41]:36694 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3DOPuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 11:50:23 -0400
Received: by mail-vb0-f41.google.com with SMTP id f13so4005232vbg.0
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2013 08:50:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1366039892.8361.29.camel@jlt4.sipsolutions.net>
References: <CAPutgu8mCmfmsEq0jkqtAN25oUBmCxZLW-kTZrsPKFpCfdJU2A@mail.gmail.com>
	<1365804259.10342.20.camel@dcbw.foobar.com>
	<1366032132.8361.19.camel@jlt4.sipsolutions.net>
	<1366036772.2404.3.camel@dcbw.foobar.com>
	<1366039892.8361.29.camel@jlt4.sipsolutions.net>
Date: Mon, 15 Apr 2013 11:50:22 -0400
Message-ID: <CAPutgu_3tkxZa1Yn67ZxU9m=E=xRHjPiz7b6yv48kSiw_xQnXw@mail.gmail.com> (sfid-20130415_175030_613050_28F07E1C)
Subject: Re: Centrino Ultimate-N 6300 AGN rfkill always Soft blocked
From: schwaahed <schwaahed@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So I configured a kernel with hp-wmi enabled. It had the unfortunate
consequence of disabling wireless on the windows side. I also saw that
some people with different hardware from me were able to resolve their
problem by blacklisting hp-wmi.

rfkill show an additional wifi interface ('hp-wifi' I think), that
behaves exactly as phy0 did. I still am unable to unblock this
interface. phy0 doesn't respond to any rfkill commands or the physical
wifi switch. It is just remains soft and hard blocked.

Dan -- Are there any links/search terms to older conversations on this issue?

Is wifi working on your 2530p?

Thanks
- Darwin

On Mon, Apr 15, 2013 at 11:31 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-04-15 at 09:39 -0500, Dan Williams wrote:
>
>> > Yeah it seems not loaded, but how then does the soft block affect hard
>> > block? All very odd, but almost certainly a platform rather than a wifi
>> > issue.
>>
>> On my 2530p and a lot of other laptops, blocking the BIOS
>> "switch" (either physically or softblock) hardblocks phy0.  I guess the
>> BIOS twiddles a GPIO that's connected to the mPCI-E module's rfkill
>> line/GPIO?
>
> Yes, that seems to be the case. Something does, anyway, as the GPIO
> state is pretty much directly reflected in the hard kill of the "phy0"
> device.
>
>> Which leads to the problem we've talked about a long time ago; you can't
>> treat phy0 hardblock as a physical block that cannot be soft-unblocked,
>> because some other switch might actually control it's state.  We tried
>> to gray-out the "Enable Wireless" when hardblocked (since logically you
>> can't soft-unblock something that's hardblocked), but it turns out you
>> can't do that because unblocking BIOS switches might un-hardblock the
>> phy0 wifi switch...  (and the kernel doesn't describe these
>> dependencies, because, well, that's laptop-specific and would never be
>> up-to-date).
>
> Yeah ... best thing you could do is assume that if a bios rfkill exists
> it controls the phy0 hard kill and in case it doesn't enable when you
> unblock the bios device you pop up a message saying to switch the
> physical button?
>
> johannes
>
