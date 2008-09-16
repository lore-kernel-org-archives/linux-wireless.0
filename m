Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:44844 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbYIPHzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 03:55:12 -0400
To: "Dan Williams" <dcbw@redhat.com>
Cc: Helmut Schaa <hschaa@suse.de>, linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: notify the user space about low signal quality
References: <200809151416.07552.hschaa@suse.de>
	<200809151435.28933.hschaa@suse.de>
	<1221487652.10177.23.camel@localhost.localdomain>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 16 Sep 2008 10:53:51 +0300
In-Reply-To: <1221487652.10177.23.camel@localhost.localdomain> (ext Dan Williams's message of "Mon\, 15 Sep 2008 10\:07\:31 -0400")
Message-ID: <874p4g1q7k.fsf@nokia.com> (sfid-20080916_095524_106465_5D6E3DBB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:

> On Mon, 2008-09-15 at 14:35 +0200, Helmut Schaa wrote:
>> This patch adds a new wext event that notifies the user space about a low
>> signal quality. The currently used indicator is as follows: If three
>> successive beacons are received with a signal quality lower then 40%
>> user space gets informed.
>> 
>> Any ideas about which indicators should be used? Comments?
>
> So why does this need a new event?  Can't wpa_supplicant monitor the
> signal quality (or level/noise if the driver doesn't provide "quality")
> and do what it needs to do without any changes to the kernel at all?

Because that's polling. 10 years ago polling might be acceptable, but
not anymore. We need to improve our power consumption and to do that
we have to avoid waking up CPU (and rest of the system) as much as
possible.

> That's what any userspace process already does.  If you're concerned
> about polling or something, we could fix that by sending periodic
> quality events

Periodic events are as worse as polling, still the CPU is waken up
unnecessarily.

> I'm concerned about adding arbitrary "roaming thresholds" to the
> stack, since that can certainly mean different things to different
> programs. It's not necessarily a system-wide value, and adding it as
> another tweakable seems unnecessary.

I don't see a problem here. We have to have a threshold somewhere and,
in my opinion, mac80211 is the best place to have it. That way it's
easier in the future when we want to improve the roaming logic because
mac80211 has the best information available to make the decision of
bad coverage to the AP.

> We've already got IWEVQUAL, why don't we use it?

Maybe, if we can provide all the necessary information to user space.
Remember that this is not all about signal level, I'm sure we will
want to use other parameters as well.

But what's so bad of adding a new event to WE? This is clearly a new
feature in WE and I don't see why we have to start overloading old
events.

-- 
Kalle Valo
