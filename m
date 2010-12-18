Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62440 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab0LRQAY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 11:00:24 -0500
MIME-Version: 1.0
In-Reply-To: <201012181607.26628.rjw@sisk.pl>
References: <AANLkTikJr+0kVPE4aSwPjZWRfA3gRSNgGwzQdSwRpo_5@mail.gmail.com>
 <Pine.LNX.4.44L0.1012110937100.10743-100000@netrider.rowland.org>
 <AANLkTi=32bqipN5U00La-B7JSgTC1bHgMev=xUSF6kRN@mail.gmail.com> <201012181607.26628.rjw@sisk.pl>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 18 Dec 2010 18:00:03 +0200
Message-ID: <AANLkTin23vbbA7+UDzh=v060HbkLMrJjB38cs+AWScPJ@mail.gmail.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-mmc@vger.kernel.org,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
	Ido Yariv <ido@wizery.com>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 18, 2010 at 5:07 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, December 18, 2010, Ohad Ben-Cohen wrote:
>> On Sat, Dec 11, 2010 at 4:50 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> >> Think of a device which you have no way to reset other than powering
>> >> it down and up again.
>> >>
>> >> If that device is managed by runtime PM, the only way to do that is by
>> >> using put_sync() followed by a get_sync(). Sure, if someone else
>> >> increased the usage_count of that device this won't work, but then of
>> >> course it means that the driver is not using runtime PM correctly.
>> >
>> > Not so.  Even if a driver uses runtime PM correctly, there will still
>> > be times when someone else has increased the usage_count.  This happens
>> > during probing and during system resume, for example.
>>
>> I'm aware of these two examples; normally we're good with them since
>> during probing we're not toggling the power, and during suspend/resume
>> the SDIO core is responsible for manipulating the power (and it does
>> so directly). Are there (or do you think there will be) additional
>> examples where this can happen ?
>>
>> But this leads me to a real problem which we have encountered.
>>
>> During system suspend, our driver is asked (by mac80211's suspend
>> handler) to power off its device. When this happens, the driver has no
>> idea that the system is suspending - regular driver code (responsible
>> to remove the wlan interface and stop the device) is being called.
>
> That's where the problem is.  If there's a difference, from the driver's
> point of view, between suspend and some other operation, there should be a
> way to tell the driver what case it actually is dealing with.

Yes, the problem will be solved if the driver would bypass the runtime
PM framework on system suspend. mac80211 obviously has this
information, and technically it's very easy to let the driver know
about it.

But the difference between suspend and normal operation is really
artificial: in both cases mac80211 just asks the driver to power its
device down, and the end result is exactly the same (a GPIO line of
the device is de-asserted in our case). The difference between these
two scenarios
exist only because runtime PM is effectively disabled during system
suspend, and therefore the driver has to look for an alternative way
to power down the device.

> BTW, what would you do in that case if the runtime PM of the device were
> disabled by user space by writing "on" to the device's
> /sys/devices/.../power/control file?

That's a good point.

Blocking runtime PM for this device is fatal since this particular
device has functionality tied up with its power control (no other way
to reset it).

It might call for a device-specific dev_pm_info bit flag to prohibit this...

(Or.. not using runtime PM at all for this device. But that would call
for SDIO bus changes, because there is no other way to power off SDIO
devices in the absence of their drivers. Moreover, the device would
not gain from runtime PM's system integration, e.g. powertop
statistics, etc..)
