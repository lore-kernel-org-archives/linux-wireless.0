Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:53919 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab3HQAXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 20:23:53 -0400
Received: by mail-pd0-f169.google.com with SMTP id r10so2866535pdi.0
        for <linux-wireless@vger.kernel.org>; Fri, 16 Aug 2013 17:23:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1376650616.15299.16.camel@jlt4.sipsolutions.net>
References: <1376395438-24788-1-git-send-email-arik@wizery.com>
 <1376568235.14084.12.camel@jlt4.sipsolutions.net> <CA+XVXffREZsiLU_Gs646-akyW9XNcZEmQnQGsp4ihT92hP7LOw@mail.gmail.com>
 <1376650616.15299.16.camel@jlt4.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 16 Aug 2013 23:09:37 +0300
Message-ID: <CA+XVXfeVtaxqAgWQgSsiMw8uZ6uDmEwba+T8M9-YrUNBwxvshA@mail.gmail.com> (sfid-20130817_022410_726939_3F0F4A63)
Subject: Re: [PATCH] mac80211: implement STA CSA for drivers using channel contexts
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 16, 2013 at 1:56 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> Well right now ieee80211_chswitch_work() takes care of it, and does
>> something a bit different there to accommodate the legacy behavior -
>> if the chan_switch op is defined, ieee80211_hw_config is not called.
>> Would you prefer that ieee80211_vif_change_channel() handle all this,
>> checking interface type to do the right thing?
>
> Well, it can't. If you look carefully then the old chan_switch op
> behaviour is to let the driver switch, not switch in software
> afterwards.

The right thing for chan_switch drivers would be not to call hw_config()..

>
>> I only added it since the current implementation of
>> ieee80211_vif_change_channel() bails if it's false. That said, I'm not
>> sure what's wrong here. This setting is per-vif.
>
> Yeah but it's (currently) meant for interfaces controlling the CSA (i.e.
> AP only right now) ... so I really think we need to make this
> controllable, I think that when we want to implement it for Intel MVM
> firmware then we'll let the firmware control the switch timing, etc.
> None of this can even be done today or with your patch.

The TI driver implements the chan_switch op and uses channel contexts.
If I catch your drift you would rather these kind of drivers (which
include MVM) use a new API exposed by mac80211 to complete the channel
switch. This API would basically be ieee80211_vif_change_channel(). Do
we still need to touch the cfg80211 chandef definition in ifmgd?

The above is maybe cleaner, but it's functionally equivalent to the
solution today - the low level driver decides when the channel switch
is completed, and ieee80211_chswitch_work() is called, which does the
right thing for all cases.
Note that with the above, the channel_contexts + software chan-switch
drivers will still need the kind of code that I wrote. So it would
just lead to replicated code. Or maybe you meant something else?

Also, where would you put csa_active = true (if at all) for a STA
interface? Unlike AP, the trigger here is mac80211 code. So putting it
there seemed appropriate.

Arik
