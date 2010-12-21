Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46772 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab0LUWXa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 17:23:30 -0500
From: Kevin Hilman <khilman@deeprootsystems.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Ohad Ben-Cohen" <ohad@wizery.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
References: <AANLkTikJr+0kVPE4aSwPjZWRfA3gRSNgGwzQdSwRpo_5@mail.gmail.com>
	<AANLkTin23vbbA7+UDzh=v060HbkLMrJjB38cs+AWScPJ@mail.gmail.com>
	<201012182347.08635.rjw@sisk.pl> <201012191122.09581.rjw@sisk.pl>
Date: Tue, 21 Dec 2010 14:23:25 -0800
In-Reply-To: <201012191122.09581.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sun, 19 Dec 2010 11:22:09 +0100")
Message-ID: <87ipymwysi.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Saturday, December 18, 2010, Rafael J. Wysocki wrote:
>> On Saturday, December 18, 2010, Ohad Ben-Cohen wrote:
>> > On Sat, Dec 18, 2010 at 5:07 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > > On Saturday, December 18, 2010, Ohad Ben-Cohen wrote:
>> > >> On Sat, Dec 11, 2010 at 4:50 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> > >> >> Think of a device which you have no way to reset other than powering
>> > >> >> it down and up again.
>> > >> >>
>> > >> >> If that device is managed by runtime PM, the only way to do that is by
>> > >> >> using put_sync() followed by a get_sync(). Sure, if someone else
>> > >> >> increased the usage_count of that device this won't work, but then of
>> > >> >> course it means that the driver is not using runtime PM correctly.
>> > >> >
>> > >> > Not so.  Even if a driver uses runtime PM correctly, there will still
>> > >> > be times when someone else has increased the usage_count.  This happens
>> > >> > during probing and during system resume, for example.
>> > >>
>> > >> I'm aware of these two examples; normally we're good with them since
>> > >> during probing we're not toggling the power, and during suspend/resume
>> > >> the SDIO core is responsible for manipulating the power (and it does
>> > >> so directly). Are there (or do you think there will be) additional
>> > >> examples where this can happen ?
>> > >>
>> > >> But this leads me to a real problem which we have encountered.
>> > >>
>> > >> During system suspend, our driver is asked (by mac80211's suspend
>> > >> handler) to power off its device. When this happens, the driver has no
>> > >> idea that the system is suspending - regular driver code (responsible
>> > >> to remove the wlan interface and stop the device) is being called.
>> > >
>> > > That's where the problem is.  If there's a difference, from the driver's
>> > > point of view, between suspend and some other operation, there should be a
>> > > way to tell the driver what case it actually is dealing with.
>> > 
>> > Yes, the problem will be solved if the driver would bypass the runtime
>> > PM framework on system suspend. mac80211 obviously has this
>> > information, and technically it's very easy to let the driver know
>> > about it.
>> > 
>> > But the difference between suspend and normal operation is really
>> > artificial: in both cases mac80211 just asks the driver to power its
>> > device down, and the end result is exactly the same (a GPIO line of
>> > the device is de-asserted in our case). The difference between these
>> > two scenarios
>> > exist only because runtime PM is effectively disabled during system
>> > suspend, and therefore the driver has to look for an alternative way
>> > to power down the device.
>> 
>> That's not correct, sorry.
>> 
>> There is a bug and the bug is that you use the runtime PM to power down
>> the device in every situation, although you obviously shouldn't do that
>> (e.g. because it may be disabled by user space or it _is_ disabled by
>> the PM core during system suspend).
>> 
>> > > BTW, what would you do in that case if the runtime PM of the device were
>> > > disabled by user space by writing "on" to the device's
>> > > /sys/devices/.../power/control file?
>> > 
>> > That's a good point.
>> > 
>> > Blocking runtime PM for this device is fatal since this particular
>> > device has functionality tied up with its power control (no other way
>> > to reset it).
>> > 
>> > It might call for a device-specific dev_pm_info bit flag to prohibit this...
>> 
>> No way.
>
> That said, I think we may do something different that perhaps will make your
> life somewhat easier.
>
> Namely, if your driver doesn't implement any system suspend callbacks
> (i.e. ->suspend(), ->resume(), ->freeze(), ->thaw() etc.) and it doesn't
> want the analogous subsystem callbacks to be executed for the device, it will
> make sense to flag the device as "runtime only", or something like this,
> which make the PM core skip the device in dpm_suspend() etc.
>
> In that case, if a device if flagged as "runtime only", we can avoid
> calling pm_runtime_get_noirq() for it in dpm_prepare() and, analogously,
> calling pm_runtime_put_sync() for it in dpm_complete().  However, we will have
> to fail system suspend (or hibernation) if a "runtime only" device has the
> power.runtime_auto flag unset.
>
> So, I think we can add a "runtime only" flag working as described above.
> I guess it will also help in the case I've been discussing with Kevin for some
> time (i2c device using runtime PM used by an RTC in a semi-transparent
> fashion).

[sorry for being late to the discussion]

Something like thi would certainly work for the case we've discussed at
LPC and some other similar ones we have on OMAP where we have "runtime
only" drivers.

That being said, another thing we discussed briefly at LPC was wondering
about reason(s) behind the DPM core locking out runtime PM transitions
in the first place.

Currently runtime PM transitions are blocked in dpm_prepare() and only
allowed again in dpm_complete().  How about locking out runtime PM
transitions only until the DPM suspend operation is complete.  IOW,
rather than waiting for dpm_complete() to re-allow runtime PM
transitions, what about allowing them after dpm_suspend()?  I haven't
actually tested this yet, since I'm busy with getting OMAP PM stuff
ready for the merge window, so it's just and idea so far.  Of course
similar will be needed to block runtime PM transitions during
dpm_resume().  

Kevin
