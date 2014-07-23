Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:53840 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655AbaGWSGa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 14:06:30 -0400
Received: by mail-lb0-f175.google.com with SMTP id 10so1190565lbg.6
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2014 11:06:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfd-4jYUy3oz4cOqBprG358X2D9m7Pgq_JrkZKHERm6f3A@mail.gmail.com>
References: <CA+XVXfcJwZJPz9rLWx6+KSWzEfkcdnjBYpzhyKfvmX7Au38akA@mail.gmail.com>
 <20140630222132.GN1390@garbanzo.do-not-panic.com> <CA+XVXffHGQFDQ+yAhdh+R=XuDsT4QfhvFfWK4b2Cw_DttzL-BQ@mail.gmail.com>
 <20140702020442.GP1390@garbanzo.do-not-panic.com> <CA+XVXffvG6GagBPMZF+iogaAeYV0kUoi4BX68J0fxOfsHjE70A@mail.gmail.com>
 <20140703221901.GS1390@garbanzo.do-not-panic.com> <CA+XVXffnDs4oCnyD0NzmyG6=jxqXwUFd+Tj8XAsWGC1bgcMH8A@mail.gmail.com>
 <CA+XVXfewhKpsdVo5Yq3RiKWoDe85h1ne_QVUDtFuC4sfECkV7g@mail.gmail.com>
 <20140708025719.GU1390@garbanzo.do-not-panic.com> <CA+XVXffMM9W76ysqgs=pyAHubavefgjqW5u8bNSZxTX69j7nzg@mail.gmail.com>
 <20140723004132.GX1390@garbanzo.do-not-panic.com> <CA+XVXfd-4jYUy3oz4cOqBprG358X2D9m7Pgq_JrkZKHERm6f3A@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 23 Jul 2014 11:06:08 -0700
Message-ID: <CAB=NE6WxUi9J+ODtvojAkT5PN5LsB=SWKhgbzqSkGkbepWeaOg@mail.gmail.com> (sfid-20140723_200634_218888_7D8E2990)
Subject: Re: [PATCH 4/5] cfg80211: accept world/same regdom from driver/user hints
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2014 at 1:07 AM, Arik Nemtsov <arik@wizery.com> wrote:
> On Wed, Jul 23, 2014 at 3:41 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
>> The struct regulatory_request can then be expanded with the
>> nl80211_driver_reg_hint_type and the handler code can do what is needed.
>> You can expand reg_request_cell_base() to include this type of request
>> but be sure that you review its uses, the only case I see that requires
>> treament of the cell base station hint differently is in
>> reg_ignore_cell_hint() where we check if the alpha2 is already set. In
>> the driver cell base station hint case where the regd structure comes
>> from the driver we'e need to ensure the source was the same, that is the
>> same wiphy.
>
> Well currently this code is only invoked for user hints, so not sure
> we should touch it. For instance reg_request_cell_base() checks the
> initiator is usermode, etc.
> Also in the driver case, we probably don't want to ignore regular
> updates after cell-base updates. So the logic is simpler there.

True, these hints should be handled separately just as
wiphy_apply_custom_regulatory() is.

> I also suggest adding another argument to regulatory_hint_regd() to
> allow the driver to specify the intersection policy. It seems that
> currently the code (__reg_process_hint_driver()) only allows to
> intersect, which is not appropriate to us.
> So the final form can look like:
>
> regulatory_hint_regd(struct wiphy,
>                               const struct ieee80211_regdomain *regd,
>                               enum nl80211_driver_reg_hint_type,
>                               enum nl80211_reg_intersect_policy policy);
>
> enum nl80211_reg_intersect_policy {
>          REG_INTERSECT_POLICY_DEFAULT,
>          REG_INTERSECT_POLICY_OVERRIDE,
>          REG_INTERSECT_POLICY_INTERSECT,
> };

We don't want to use the driver regulatory data to help the regulatory
core at all because I noted it would get things messy fast. That would
mean you never have to deal with any intersection or the cfg80211
regulatory domain at all. So none of this would be needed. The hint
would just be for the driver. Its sad that driver regulatory data
can't contribute to the regulatory core but I think its best this way
to keep things clean and simple. If the driver does want to help the
best way is to contribute to wireless-regdb and move to that.

>> When drivers are the sources of the regd we only want to trust that
>> regd struct for that wiphy, ideally however it is very useful information
>> for the entire kernel what alpha2 was passed, however using this alpha2
>> to for example call CRDA and use the wireless-regdb *only* for drivers
>> other than the caller can get rather sloppy and complicated really
>> quickly. For instance if CRDA is not installed we'd timeout on the request
>> and we don't want to reset the regulatory core as its not a fatal issue if
>> CRDA was not present in the case of an internal driver call.
>> Driver specific helpers added here should simply be documented and
>> implemented as driver specific then, they really can't *easily* contribute
>> much to the regulatory core unless we complicate things quite a bit. I don't
>> think its worth it. We should therefore treat these type of driver hints
>> that have the driver / firmware as source for the regulatory data as no
>> different than the custom reg hint calls, which are only internal to
>> the driver. The driver can still take advantage of other regulatory core
>> helpers like beacon hints, and other regulatory helpers if it so
>> wishes. Please make these new helpers EXPORT_SYMBOL_GPL() though.
>
> Agree we should keep this simple. Why should these be exported as GPL?
> Everything else is just EXPORT_SYMBOL() in reg.c.

The regulatory code was changed to permissive license to help with the
BSD community. I've more than once now pitched to folks about sharing
and growing this code together, nothing has happened over years and in
fact got a positive nack on interest at least on FreeBSD, so although
the goal was good, upkeeping the permissive license doesn't do us any
good. These new symbols would be a good drawing line to move away from
that, and prevent proprietary drivers from making use of this.

>> This should simplify your implementation then. You can even piggy back on
>> top of the current cell base station hint code, it can be extended to include
>> support for driver cell base station hints and I think all you'd
>> need is to expand support to enable drivers to specify whether or not
>> they want driver cell base station hints to be able to be more authoritative
>> than what was specified on the _orig* parameters. To be clear you would
>> not be overriding the _orig* parameters but these new settings would be
>> a new super set for the driver. Right now we don't let stepping outside
>> what is on the _orig* parameters and it seems you do want to do that for
>> these hints, but you also *don't* want these saved and cached. Using a
>> flag for this preference seems reasonable. You'd still have cached any
>> previous settings on the _orig* parameters so a reset would restore
>> the device to previous state.
>>
>>> Sometimes the SIM is removed or there's no reception etc. In this case
>>> we must get back to the "default" country, which is burned in
>>> NVRAM/FW.
>>
>> You explaining *two* other requirements here:
>>
>> (1) The driver provides an alpha2 regulatory domain which is burned onto
>>     the NVRAM or writtten on the firmware file. You could expand on the
>>     regulatory_hint_regd(), this would should probably go in first, so
>>     you'd have:
>>
>> enum nl80211_driver_reg_hint_type {
>>                 NL80211_DRIVER_REG_HINT_INTERNAL        = 0,
>>                 NL80211_DRIVER_REG_HINT_CELL_BASE       = 1,
>> };
>>
>> As with (0) the source is internal and only applicable to the
>> driver. This should simplify the implementation. As with
>> REGULATORY_STRICT_REG, you'd want something similar to help you
>> override the *_orig parameters.
>
> I don't think we ever want to override _orig as they restrict changes.
> But the overall solution is ok.

OK, to be clear you would override _orig for the driver alpha2 hint,
and then the cell base station hint can either be the minimum set or
superset depending on a flag, but it won't touch the _orig parameters.
When a reset of the regulatory occurs the regulatory core would make
the driver go back to the _orig parameters, that work is already done.

>> (2) regulatory_hint_cell_disconnect() - this would allow the regulatory core
>>     to reset the device to the "default" alpha2 country. If you
>>     implement the driver cell base station as explained on (0)
>>     and the driver reg hint as in (1) then the reset of the regulatory
>>     settings should already take care of this.
>>
>>> As explained in my previous email, currently reg.c doesn't
>>> have any suitable facility to save this "default" country-code.
>>
>> Yes it does, we have it for the REGULATORY_STRICT_REG and
>> regulatory_hint() case, you have a similar use case but the
>> source is simply internal to the driver. That's all.
>
> So the only use for nl80211_driver_reg_hint_type for now would be to
> cache the default alpha2 value?

It would be good to expose the source to userspace as well both as an
event and when querying the wiphy.

> We'll need a new global variable, something like "driver_alpha2",
> similar to the existing "user_alpha2". We can't just use the last
> request, since it will change..

No, last_request stuff would never be touched by any of this work as
the regulatory data is purely internal and it'd be a mess to share
this with other drivers. I think its best to keep these hints
applicable only to the wiphy who issued them, even the driver cellular
hint with the regd. We should only share hints / reg info for drivers
using wireless-regdb. To help with debugging and as a compromise to
help with wireless-regdb evolution it would be good though to store
the passed regd for each type of driver hint so it can be made
available to userspace for easy inspection. I suspect you'll also want
a driver country IE hint too then, and I think this is fine. It is
better than the current situation where drivers / firmware would just
keep this regulatory data private.

>>> And anyway a "restore to default" API doesn't exist.
>>
>> regulatory_hint_disconnect() exists but that's only used by the SME.
>> So indeed we a regulatory_hint_cell_disconnect() seems in order.
>
> Ok that sounds good.
>
>>
>> This can be much simpler, I'll reorder your requirements:
>>
>> (0) regulatory_hint_regd() for type NL80211_DRIVER_REG_HINT_INTERNAL
>>     with a flag similar to REGULATORY_STRICT_REG
>> (1) regulatory_hint_regd() for type NL80211_DRIVER_REG_HINT_CELL_BASE
>> (2) regulatory_hint_cell_disconnect()
>
> All this is in addition to the new get_regd() callback for setting the
> regdomain data when usermode requests a cell-base hint right?
> If so, this should work well.

No instead of the callback you'd just issue the calls directly for
each type of event, you'd pass the regd from the start. Note that the
hints are for specific alpha2 regdomains, not for custom world
regdomain as an API for that already exists. In fact perhaps you can
share that code with what you are doing, not sure, I think the only
difference is after registration we'd have to worry about locking.
Before registration wiphy_apply_custom_regulatory() can be used, after
that the other hints you're developing can be used.

  Luis
