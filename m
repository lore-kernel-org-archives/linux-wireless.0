Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:54561 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819AbZCYTxG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 15:53:06 -0400
Received: by fxm2 with SMTP id 2so217094fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 12:53:03 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	"Guy\, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>
Subject: Re: wireless powersaving (in NM?)
References: <1237891149.4320.73.camel@johannes.local>
	<87ab7bqa21.fsf@litku.valot.fi>
	<1237978630.4320.150.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 25 Mar 2009 21:53:00 +0200
In-Reply-To: <1237978630.4320.150.camel@johannes.local> (Johannes Berg's message of "Wed\, 25 Mar 2009 11\:57\:10 +0100")
Message-ID: <87ab791isj.fsf@litku.valot.fi> (sfid-20090325_205315_408255_18901305)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2009-03-24 at 16:17 +0200, Kalle Valo wrote:
>
>> > Therefore, I think the "power saving level" needs to be determined
>> > by pm_qos. The design of how to do that, however, is still up in the
>> > air.
>> 
>> Maybe. At least it "feels" a lot better than the five magic numbers :)
>> 
>> Unfortunately I haven't thought about this so I cannot comment on it.
>> And by the looks of it, I won't find the time for some time.
>
> By the way, do you have any numbers on how the timeout affects actual
> network latency?

Nope. I would guess that there are academic studies about this and if
someone finds anything, please share them here. I would interested as
well.

> It's also related to the beacon interval and the listen interval, of
> course.

Yes. Also we need to consider are we willing to skip DTIM beacons and
loose multicast/broadcast frames. We could save even more power with
that.

>> > The alternative would be to expose all the possible parameters and/or
>> > levels to mac80211 and have it make choices based on pm_qos, but it
>> > seems that this interface would rapidly become extremely complex,
>> > fragile and buggy.
>> 
>> I think this alternative would be better in the long run. My feeling
>> is that the settings between different hardware don't wary that much
>> based on what I have seen and we would eventually find settings which
>> work for all, maybe small hackery needed somewhere but that's it.
>
> I'm just worried that we'll require a whole bunch of different
> interfaces. Yes, in theory there isn't much to control, but iwlwifi
> firmware for example can, as far as I interpret the code, dynamically
> vary the listen interval.

You mean the wakeup interval? For me, listen interval means the
maximum time AP is willing to buffer frames for a STA.

I assume you mean sleep_interval here:

#define IWL_POWER_VEC_SIZE 5

struct iwl_powertable_cmd {
	__le16 flags;
	u8 keep_alive_seconds;		/* 3945 reserved */
	u8 debug_flags;			/* 3945 reserved */
	__le32 rx_data_timeout;
	__le32 tx_data_timeout;
	__le32 sleep_interval[IWL_POWER_VEC_SIZE];
	__le32 keep_alive_beacons;
} __attribute__ ((packed));

So there's an array sleep/wakeup interval, which firmware most
probably rotates periodically. I think stlc45xx/p54 even had something
similar. But honestly, I don't know if this kind of trickery is
useful. Why not directly go to the longest wakeup interval
immediately?

My view is that the decision to change wakeup interval should be done
in host, preferably userspace. Userspace has the best knowledge, it
should make the decision as well.

> Some of the decisions might also depend on the hardware, I could
> imagine, the point where turning off power saving is required might be
> different depending on hardware due to wakeup time maybe?

Yes, there might be some differences.

>> > Kalle, there's a related question here -- what's the value of exposing
>> > the sleep timeout to users? It seems to be quite unnecessary, since you
>> > seem to be using a fixed value of 500ms anyway. 
>> 
>> In Maemo products (n800, n810 etc) we use it to select the power save
>> aggressiveness. IIRC in diablo it was so that when the display was on
>> 200 ms timeout value was used, and then it was off the value was set
>> to 100 ms. The decision was made in userspace, in wlancond (our dbus
>> WE wrapper). The idea here was that user won't most probably mind if
>> the network is slower then the display is off.
>> 
>> > Can we remove that, leaving wext only with turning on/off power
>> > saving? [2][3]
>> 
>> I would hate to loose it, at least in the near future. If there's a
>> good alternative and a proper deprecation period, I don't mind it
>> going away.
>
> The trivial alternative would be to use /dev/network_latency and
> register the requirements instead, but do it "globally" based on display
> state rather than "properly" based on applications.

Sounds good to me.

>> > However, by putting the burden onto drivers, drivers can choose a
>> > conservative power saving level when no application has registered its
>> > pm_qos requirements, and once applications start using the it deeper
>> > power levels can be chosen as appropriate.
>> 
>> It will take years for the applications to adapt this, I would not
>> want to depend on that. I would like to have usable already without
>> application support.
>
> As I said above, you can always have a single application register
> requirements for the other apps.

Good, my concern is then taken care of.

-- 
Kalle Valo
