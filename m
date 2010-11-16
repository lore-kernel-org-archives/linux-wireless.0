Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47585 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758072Ab0KPT5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 14:57:12 -0500
Message-ID: <4CE2E215.1090906@candelatech.com>
Date: Tue, 16 Nov 2010 11:57:09 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RFC/PATCH:  Allow wpa_supplicant to share scan results.
References: <4CE1CEC6.2050103@candelatech.com> <20101116094512.GB21872@jm.kir.nu> <4CE2B953.9090509@candelatech.com> <20101116193156.GA32723@jm.kir.nu>
In-Reply-To: <20101116193156.GA32723@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/16/2010 11:31 AM, Jouni Malinen wrote:
> On Tue, Nov 16, 2010 at 09:03:15AM -0800, Ben Greear wrote:
>> It would be easy enough to save the phyname in the wpa_s struct so it
>> doesn't need to be probed all the time.
>
> phyname sounds like a Linux/mac80211/cfg80211 specific thing and
> probably does not belong in wpa_s.. But yes, some kind of identifier for
> interfaces sharing the same radio there or in the private driver wrapper
> data would be fine (if it within driver_nl80211.c, phyname would be
> perfectly valid thing to store at initialization).
>
>> As for the logic that actually propagates scan results to all of the
>> peer VIFS, do you mean you want that moved farther up into the driver
>> as well?
>
> I think I would be fine with either option as a starting point, i.e.,
> driver_nl80211.c can maintain an internal list of interfaces and
> propagate the scan complete event to each interface or there can be an
> abstract radio identifier exposed by the driver wrapper to allow core
> supplicant code to handle this. I'm assuming here that it is possible to
> read the scan results from any vif in mac80211 regardless of which
> generated the scan-completed event. Is that correct?

I earlier attempted to put this sharing/propagation directly into
the kernel (instead of -EBUSY, the kernel would just keep a list of
interested interfaces and then send results to all interested parties).

However, Johannes didn't like this approach, so I'm trying to do a
similar thing in user-space.  My understanding is that you cannot
read scan results from the kernel for one VIF if they were initiated on another
VIF.  I might be wrong about that, however.  At any rate, you certainly can't
have two VIFS on the same phy scanning at the same time, as you get -EBUSY instead.
That makes wpa_supplicant take a long time to scan & associate lots
of VIFS, and speeding that up is my primary goal at this point.

I think I see where to propagate the scan results in the hostap NL driver, except
that I cannot find a global list of driver-data structs.  I could
do some casting of drv->ctx->global, but perhaps we are not supposed
to do that sort of thing?

If I put the phyname (or radio_name, or whatever) in wpa_s, I can propagate
in the events.c code, but I'm not too sure how to set that value from within
the NL driver since we are given the wpa_s as a void* (which I assume means
we should not be assuming what struct it really is).

>> It simple to know the phy-name for a particular VIF (on the latest kernel),
>> so knowing parent-child and sibling relationships is also easy.  Older
>> kernels don't have the phy-name available in sysfs, but they also didn't
>> support multiple VIFS well anyway..so maybe just ignore them?
>
> Yeah, I have no problems in ignoring old versions for this kind of new
> functionality.
>
>> I was afraid that one VIF might scan with one set of scan-options and another
>> a different set.  However, I have no real understanding of how wpa_supplicant
>> works, so if you think it can be always enabled, then I'm fine with that.
>
> That can already happen even with a single vif when other applications
> are requesting scans.. wpa_supplicant will have to handle it cleanly
> anyway.

One other thing I was worried about:  My patch is going to send scan results
to interfaces that have not successfully requested them (they may have not
requested at all, or they may have tried and received EBUSY).  Will that be
an issue?

>> Also, with it enabled, I can currently reliably crash ath9k.  This is a
>> kernel bug that hopefully can be fixed soon, but it would be one small reason to
>> keep the old behaviour available.
>
> What exactly is the trigger for the crash? Multiple vifs? Or this type
> of optimization for re-using scan results? Anyway, I don't think we
> should care about that in the context of designing what should be added
> into wpa_supplicant. If a kernel driver is buggy, it will be fixed, or
> you better not try to use this feature ;-).

It only crashes with the wpa_supplicant patch I posted (and the kernel
patch as well, it turns out).  It's almost certainly due to faster
association attempts, but I haven't looked any farther.  I plan to
test this on ath5k as well..that might shed some light.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

