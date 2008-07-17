Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:56469 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbYGQHPn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 03:15:43 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1926326yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2008 00:15:42 -0700 (PDT)
Message-ID: <1ba2fa240807170015n163ec5c7wb7693df317ae926d@mail.gmail.com> (sfid-20080717_091554_447280_1BE48C00)
Date: Thu, 17 Jul 2008 10:15:41 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: background scanning and fast handovers
Cc: "Dan Williams" <dcbw@redhat.com>, devel@e-doo.de,
	linux-wireless@vger.kernel.org
In-Reply-To: <87zlohawx3.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <28167927.118721216023197288.JavaMail.servlet@kundenserver>
	 <1216140538.6039.95.camel@localhost.localdomain>
	 <87zlohawx3.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 17, 2008 at 8:42 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Dan Williams <dcbw@redhat.com> writes:
>
>>> How does the compact-wireless driver handle the case, when a
>>> connection of a STA to an AP gets lost?
>>
>> Right now, the lowest-common-denominator is that the driver sends a
>> disconnection event to userspace, and userspace handles reconnection as
>> it sees fit.  Some drivers may attempt to reconnect to the AP
>> periodically until told not to.
>
> Are you talking about mac80211 drivers here? I haven't seen any
> mac80211 driver do that.
>
>> I personally think the driver/stack should try a few reconnections to
>> the AP (without sending the SIOCSIWAP disconnect event) and only if
>> those all fail, send the disconnect event.
>
> Actually I disagree with this, because it might slowdown roaming too
> much. The logic should be either in user space or in mac80211, but not
> in both. Now it's implemented in user space and, in my opinion, that's
> the best place.
>
>> But if the reconnection was successful, send the SCIOCSIWAP event
>> for the AP even if it matches the old AP's BSSID just so userspace
>> knows that something happened. wpa_supplicany may need to know this
>> to rekey the connection or something.
>
> Yes, we have to send SIOCSIWAP event after every association.
>
>>> Are there any activities to implement something like a "background
>>> scanning" in STA Mode?
>>
>> Some drivers already do this (ipw for example), but I don't think
>> background scanning is really implemented in mac80211 at this time.
>
> My understanding is that mac80211 assumes user space to do this. I
> think wpa_supplicant doesn't do that currently, it only issues a scan
> if it receives a disassociation event.
>
> (Please correct me if I'm wrong.)
>
>> mac80211 certainly will handle beacons and probe responses _on the
>> same channel_, but I don't believe there is any sort of
>> multi-channel background scanning going on, nor should there really
>> be unless it can be made _very_ fast. You don't want the driver
>> doing a multi-channel background scan while you're using VOIP.
>
> If the STA is stationary, then background scanning isn't that
> beneficial, that's true. But if STA is moving, when there are benefits
> from background scanning because of faster roaming. I haven't measured
> it ever, but I assume that background scanning and roaming to an
> another AP beforehand is always faster than loosing a connection.
>
> The way I see this is that mac80211 should follow the connection
> quality (RSSI, transmission failures, beacon losts, etc) and signal
> userspace if the connection quality gets low and the signal would then
> trigger background scanning in user space. If the signal gets better,
> mac80211 would send a signal stating so and user space would turn off
> background scanning.
>
> If background scanning affects the normal data transfer too much
> we can always try to optimise the scan, for example by scanning every
> third channel at a time or something similar.
>
>>> A background scanning will allow a STA to observe the neighbourhood
>>> for new APs.
>>
>> Right.
>>
>>> There are a few drivers that provide this functionality today. The
>>> intention is to reduce Handover latency of a mobile STA, when it
>>> switches from one AP to an other AP.
>>
>> Again, within the same ESS?
>
> I think he is talking about roaming in same ESS here.
>
>>> What do you think: Is it interessting for you, to work jointly on
>>> these challenges?
>>
>> Personally I think anything we can do to make intra-ESS handover faster
>> is a good thing.  wpa_supplicant in userspace is obviously required here
>> for WPA roaming and it can handle things like preauth and other bits of
>> fast reauth defined in the WPA specs.  Since that's where things are
>> going, it's going to need coordination between both the driver and the
>> supplicant to get right.
>
> I'm very interested about this as well. I expect to work on this more
> in a month or two.
>

I think Cisco APs implements fast roaming ... intra-ESSI think they
made it also to 802.11r. So there is no much invention
just implement the spec :) http://en.wikipedia.org/wiki/IEEE_802.11r.

For regular roaming you need background scanning. Such scanning should
be rather limited to not hurt performance.
The best known approach to me is using direct scan scan to known
possible AP. Yet there is no notion
of a profile in mac80211 or wext. So you cannot set bunch of SSIDs to
be scanned for to find appropriate roaming candidate in background.
Iwlwifi HW has this infrastructure but it's not used.
The other approach is limit number of channels in each round of the scan.

Tomas
