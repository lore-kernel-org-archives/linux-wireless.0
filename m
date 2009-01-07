Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:20029 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbZAGQWq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 11:22:46 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: Vivek Natarajan <vnatarajan@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2] mac80211: extend/document powersave API
References: <1231264395.3654.10.camel@johannes>
	<1231273502.3767.4.camel@johannes> <878wpn5d64.fsf@nokia.com>
	<1231343803.3545.50.camel@johannes>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 07 Jan 2009 18:22:21 +0200
In-Reply-To: <1231343803.3545.50.camel@johannes> (ext Johannes Berg's message of "Wed\, 07 Jan 2009 16\:56\:43 +0100")
Message-ID: <874p0b5bnm.fsf@nokia.com> (sfid-20090107_172250_159228_57759D77)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2009-01-07 at 17:49 +0200, Kalle Valo wrote:
>
>> > + * First, it can support hardware that handles all powersaving by
>> > + * itself, such hardware should simply set the %IEEE80211_HW_SUPPORTS_PS
>> > + * hardware flag. In that case, it will be told about the desired
>> > + * powersave mode regardless of association status, and the driver or
>> > + * hardware must take care of enabling/disabling powersave depending on
>> > + * the association status and TIM bit and send nullfunc frames by
>> > + itself.
>> 
>> Actually I'm not aware of any hardware designs which enables and
>> disables power save according to association status (modulo fullmac
>> design, of course). Even iwlwifi, which I think has the most
>> sophisticated power save support, requires the host to enable power
>> save according to the association status. Hence I would like to have
>> the power save enable/disable logic based on association status in
>> mac80211.
>
> Yeah, good point. But iwlwifi is confusing me ;) Since iwlwifi is the
> only user, I'll clean that up along with cleaning up iwlwifi, would you
> mind leaving it as-is, and I'll fix it in the short term?

I'm perfectly fine with this. Most important is that we have a
consensus about long term goals, the current solution is just fine.
Power save is always tricky, and it's even trickier when we have to
deal with all these different hardware designs. Let's do this in small
pieces, it makes life a lot easier.

>> We already have this support in ieee80211_set_associated() 
>> 
>> [Reads the function again] 
>> 
>> Or, actually we had it. I think Vivek's patch changed the
>> functionality. But anyway, it's very easy to add the support back.
>> 
>> The reason why I would like to have this in mac80211 is to avoid
>> having duplicate bugs in different drivers and make the driver
>> implementation easier.
>
> Makes sense.

Good, we have an agreement :)

>> Actually there are hardware designs which don't have dynamic power
>> save but have null frame creation in firmware (and hence don't need
>> IEEE80211_HW_PS_NULLFUNC_STACK). So IEEE80211_HW_SUPPORTS_DYNAMIC_PS
>> and IEEE80211_HW_PS_NULLFUNC_STACK are not related to each other in
>> any way. I suspect at76_usb is such design, but I need to recheck
>> that.
>
> But if they don't have dynps but nullfunc in firmware then we can't
> support dynamic ps at all, can we?
>
>> So I would like to implement this so that if
>> IEEE80211_HW_SUPPORTS_DYNAMIC_PS is not set mac80211 will always use
>> it's own timer, independent of IEEE80211_HW_PS_NULLFUNC_STACK. If you
>> agree, I can create a separate patch for this.
>
> Oh, I see now, so the firmware just creates the nullfunc whenever you
> tell it to? 

Exactly. In that case we command the null frame creation in firmware
with the CONF_PS flag.

> bit strange, I guess.

It's strange, but I think it's because the hardware designers haven't
properly thought about power save. 802.11 power save wasn't important
few years ago, but fortunately times are changing.

-- 
Kalle Valo
