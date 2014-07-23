Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:59480 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230AbaGWIHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 04:07:50 -0400
Received: by mail-pd0-f169.google.com with SMTP id y10so1179904pdj.28
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2014 01:07:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140723004132.GX1390@garbanzo.do-not-panic.com>
References: <CA+XVXfcJwZJPz9rLWx6+KSWzEfkcdnjBYpzhyKfvmX7Au38akA@mail.gmail.com>
 <20140630222132.GN1390@garbanzo.do-not-panic.com> <CA+XVXffHGQFDQ+yAhdh+R=XuDsT4QfhvFfWK4b2Cw_DttzL-BQ@mail.gmail.com>
 <20140702020442.GP1390@garbanzo.do-not-panic.com> <CA+XVXffvG6GagBPMZF+iogaAeYV0kUoi4BX68J0fxOfsHjE70A@mail.gmail.com>
 <20140703221901.GS1390@garbanzo.do-not-panic.com> <CA+XVXffnDs4oCnyD0NzmyG6=jxqXwUFd+Tj8XAsWGC1bgcMH8A@mail.gmail.com>
 <CA+XVXfewhKpsdVo5Yq3RiKWoDe85h1ne_QVUDtFuC4sfECkV7g@mail.gmail.com>
 <20140708025719.GU1390@garbanzo.do-not-panic.com> <CA+XVXffMM9W76ysqgs=pyAHubavefgjqW5u8bNSZxTX69j7nzg@mail.gmail.com>
 <20140723004132.GX1390@garbanzo.do-not-panic.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 23 Jul 2014 11:07:34 +0300
Message-ID: <CA+XVXfd-4jYUy3oz4cOqBprG358X2D9m7Pgq_JrkZKHERm6f3A@mail.gmail.com> (sfid-20140723_100802_708717_2352C038)
Subject: Re: [PATCH 4/5] cfg80211: accept world/same regdom from driver/user hints
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2014 at 3:41 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> Dropping Greg as we're no longer focusing on questions on the driver
> core. My reply below.
>
> On Wed, Jul 09, 2014 at 05:46:05PM +0300, Arik Nemtsov wrote:
>> On Tue, Jul 8, 2014 at 5:57 AM, Luis R. Rodriguez
>> <mcgrof@do-not-panic.com> wrote:
>> > Let's separate cell base station hints from userspace from firmware
>> > being loaded and assuming that magical firmware has now regulatory
>> > data (which obviously I consider silly since we already provide the
>> > same functionality with CRDA and let you override the db.txt). The
>> > cellular base station hint infrastructure can certainly be expanded
>> > to support overriding the *_orig parameters. The FW API looks less
>> > attractive now as it seems more than anything the hint can actually
>> > come from userspace and the base station hint mechanism for your
>> > use case.
>> >
>> > A FW API to let FW load regulatory data dynamically is still OK but
>> > lets be clear that if you are using it for a userspace work around
>> > for cell base astation hints it seems rather a work around for
>> > existing APIs and you can likely implement what you want with less
>> > code. If we don't need this FW API I rather not have it added.
>>
>> I don't see a way around having the get_regd() API to get regulatory
>> data from FW. How else would we get regdomain settings?
>
> Well it depends on the solution of course so let's review and be
> crystal clear on what your *requirements* are and determine exactly
> what you need.
>
> So far it seems clear you have requirements for:
>
> (0) asynchronous "cellular hint" from the *driver*, with the data
>     source of the regulatory domain data structure being the driver
>
> Right now we only provide asynchronous cell base station hints but from
> userespace, and only for the alpha2.
>
>> A hint can come from userspace (as a cell-base hint) or from the
>> driver.
>
> Right. Today we only allow cell base station hints from userspace
> though.

Right.

>
>> In some platforms the Wifi HW is directly connected to the SIM
>> and the FW sends up events about country change. This eventually
>> causes a driver hint.
>
> OK, so userspace can't send the cell base station hint (or whatever
> we want to call it to make this fit). In that case the firmware should
> be able to trigger an event and send a regulatory hint but with a
> regulatory domain data structure. As I see it instead of of having the
> regulatory core *ask* the driver for the regdomain the driver should be
> able to initiate the request preemptively, a new call seems best,
> something like:
>
> regulatory_hint_regd(struct wiphy,
>                      const struct ieee80211_regdomain *regd,
>                      enum nl80211_driver_reg_hint_type);
>
> The nl80211_driver_reg_hint_type can be similar to nl80211_user_reg_hint_type
> to qualify the source. The first source would be:
>
> enum nl80211_driver_reg_hint_type {
>                 NL80211_DRIVER_REG_HINT_CELL_BASE       = 0,
> };

That could work nicely actually.

>
> The struct regulatory_request can then be expanded with the
> nl80211_driver_reg_hint_type and the handler code can do what is needed.
> You can expand reg_request_cell_base() to include this type of request
> but be sure that you review its uses, the only case I see that requires
> treament of the cell base station hint differently is in
> reg_ignore_cell_hint() where we check if the alpha2 is already set. In
> the driver cell base station hint case where the regd structure comes
> from the driver we'e need to ensure the source was the same, that is the
> same wiphy.

Well currently this code is only invoked for user hints, so not sure
we should touch it. For instance reg_request_cell_base() checks the
initiator is usermode, etc.
Also in the driver case, we probably don't want to ignore regular
updates after cell-base updates. So the logic is simpler there.

I also suggest adding another argument to regulatory_hint_regd() to
allow the driver to specify the intersection policy. It seems that
currently the code (__reg_process_hint_driver()) only allows to
intersect, which is not appropriate to us.
So the final form can look like:

regulatory_hint_regd(struct wiphy,
                              const struct ieee80211_regdomain *regd,
                              enum nl80211_driver_reg_hint_type,
                              enum nl80211_reg_intersect_policy policy);

enum nl80211_reg_intersect_policy {
         REG_INTERSECT_POLICY_DEFAULT,
         REG_INTERSECT_POLICY_OVERRIDE,
         REG_INTERSECT_POLICY_INTERSECT,
};

>
> When drivers are the sources of the regd we only want to trust that
> regd struct for that wiphy, ideally however it is very useful information
> for the entire kernel what alpha2 was passed, however using this alpha2
> to for example call CRDA and use the wireless-regdb *only* for drivers
> other than the caller can get rather sloppy and complicated really
> quickly. For instance if CRDA is not installed we'd timeout on the request
> and we don't want to reset the regulatory core as its not a fatal issue if
> CRDA was not present in the case of an internal driver call.
> Driver specific helpers added here should simply be documented and
> implemented as driver specific then, they really can't *easily* contribute
> much to the regulatory core unless we complicate things quite a bit. I don't
> think its worth it. We should therefore treat these type of driver hints
> that have the driver / firmware as source for the regulatory data as no
> different than the custom reg hint calls, which are only internal to
> the driver. The driver can still take advantage of other regulatory core
> helpers like beacon hints, and other regulatory helpers if it so
> wishes. Please make these new helpers EXPORT_SYMBOL_GPL() though.

Agree we should keep this simple. Why should these be exported as GPL?
Everything else is just EXPORT_SYMBOL() in reg.c.

>
> This should simplify your implementation then. You can even piggy back on
> top of the current cell base station hint code, it can be extended to include
> support for driver cell base station hints and I think all you'd
> need is to expand support to enable drivers to specify whether or not
> they want driver cell base station hints to be able to be more authoritative
> than what was specified on the _orig* parameters. To be clear you would
> not be overriding the _orig* parameters but these new settings would be
> a new super set for the driver. Right now we don't let stepping outside
> what is on the _orig* parameters and it seems you do want to do that for
> these hints, but you also *don't* want these saved and cached. Using a
> flag for this preference seems reasonable. You'd still have cached any
> previous settings on the _orig* parameters so a reset would restore
> the device to previous state.
>
>> Sometimes the SIM is removed or there's no reception etc. In this case
>> we must get back to the "default" country, which is burned in
>> NVRAM/FW.
>
> You explaining *two* other requirements here:
>
> (1) The driver provides an alpha2 regulatory domain which is burned onto
>     the NVRAM or writtten on the firmware file. You could expand on the
>     regulatory_hint_regd(), this would should probably go in first, so
>     you'd have:
>
> enum nl80211_driver_reg_hint_type {
>                 NL80211_DRIVER_REG_HINT_INTERNAL        = 0,
>                 NL80211_DRIVER_REG_HINT_CELL_BASE       = 1,
> };
>
> As with (0) the source is internal and only applicable to the
> driver. This should simplify the implementation. As with
> REGULATORY_STRICT_REG, you'd want something similar to help you
> override the *_orig parameters.

I don't think we ever want to override _orig as they restrict changes.
But the overall solution is ok.

>
> (2) regulatory_hint_cell_disconnect() - this would allow the regulatory core
>     to reset the device to the "default" alpha2 country. If you
>     implement the driver cell base station as explained on (0)
>     and the driver reg hint as in (1) then the reset of the regulatory
>     settings should already take care of this.
>
>> As explained in my previous email, currently reg.c doesn't
>> have any suitable facility to save this "default" country-code.
>
> Yes it does, we have it for the REGULATORY_STRICT_REG and
> regulatory_hint() case, you have a similar use case but the
> source is simply internal to the driver. That's all.

So the only use for nl80211_driver_reg_hint_type for now would be to
cache the default alpha2 value?
We'll need a new global variable, something like "driver_alpha2",
similar to the existing "user_alpha2". We can't just use the last
request, since it will change..

>
>> And anyway a "restore to default" API doesn't exist.
>
> regulatory_hint_disconnect() exists but that's only used by the SME.
> So indeed we a regulatory_hint_cell_disconnect() seems in order.

Ok that sounds good.

>
> This can be much simpler, I'll reorder your requirements:
>
> (0) regulatory_hint_regd() for type NL80211_DRIVER_REG_HINT_INTERNAL
>     with a flag similar to REGULATORY_STRICT_REG
> (1) regulatory_hint_regd() for type NL80211_DRIVER_REG_HINT_CELL_BASE
> (2) regulatory_hint_cell_disconnect()

All this is in addition to the new get_regd() callback for setting the
regdomain data when usermode requests a cell-base hint right?
If so, this should work well.

Arik
