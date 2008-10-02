Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:24285 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYJBLDp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 07:03:45 -0400
Received: by fg-out-1718.google.com with SMTP id 19so717763fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 02 Oct 2008 04:03:43 -0700 (PDT)
Message-ID: <1ba2fa240810020403r56d02416k60f45e9e6fb95fd8@mail.gmail.com> (sfid-20081002_130350_634454_8D9FC563)
Date: Thu, 2 Oct 2008 14:03:43 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2 V2] mac80211: send action frame when toggling SM PS mode
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1222936652.24551.30.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222805245-31166-1-git-send-email-tomas.winkler@intel.com>
	 <1222936652.24551.30.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 2, 2008 at 11:37 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-09-30 at 23:07 +0300, Tomas Winkler wrote:
>
> Some code comments first, I'll cover the design below.
>
>> +static void ieee80211_send_sm_ps(struct ieee80211_sub_if_data *sdata, u8 mode)
>
> Can we use an enum for 'mode'?

We use spec numbers here why to invent more numbers.


>> +     /* Implemented for STA only */
>> +     if (sdata->vif.type != NL80211_IFTYPE_STATION)
>> +             return;
>
> What about mesh, ibss, wds, ...? I see this doesn't make much sense for
> an AP, but...?

This is explicitly defined in spec for STA mode.

>
>> +     switch (mode) {
>> +
>
> spurious blank line
>
>> +     if (ifsta->flags & IEEE80211_STA_ASSOCIATED)
>> +             ieee80211_tx_skb(sdata, skb, 0);
>
> Umm. Why don't you check this before the allocation so that it doesn't
> leak? Also, this probably should return the out of memory status so that
> the driver can decide to not switch SM PS mode in that case? Although
> then the system is probably pretty much dead anyway...
>
>> +     rcu_read_lock();
>> +     list_for_each_entry_rcu(sdata, &local->interfaces, list) {
>> +             ieee80211_send_sm_ps(sdata, new_mode);
>> +     }
>
> no need for braces there

Will fix.

>
> So, let's get to the design, it's really confusing. Especially with
> patch 2 in there as well, this gets _really_ confusing. On the one hand,
> this is being called by mac80211 when the user changes the power save
> mode and in that case the driver is notified of the powersave mode, but
> on the other hand this is also exported to drivers?

It should not be exported to driver, I think I was clear in the last
mail that I didn't like it myself
and I'm looking for popper way to do that.

> It seems that for the second use case you're citing you've now done
> something that might lead to bouncing back and forth because there is no
> central instance deciding on the powersave mode. You seem to be trying
> to avoid this by introducing the two new variables sm_ps_psp_mode and
> sm_ps_cam_mode, but this seems very strange. Is the driver supposed to
> modify them at runtime?

No it should be set on registration only

What sort of policy does the driver impose on
> them? Why is this policy driver-specific?

Depends on radio ability rather then policy. The only policy that is
set here is that we coupling SM PS and PS

Why doesn't the driver just
> inform mac80211 of the antenna status and mac80211 then decides based on
> the antenna status and the requested powersave mode which SM PS mode
> should be activated, and then notifies the driver of that?

Correct that's the solution, just keep in mind that driver change rx
chain configuration upon SM PS request as well.


> I don't like this patch. You're putting some policy into the driver that
> seems should not be different between drivers. Also, these backward
> calls from the driver to mac80211 that just update the AP's status make
> it rather complex to get the API right, with multiple variables that
> need updating.

I don't like it either, the development strategy is first make it work
and then beautify and optimize

> I'd much rather see you implement this in a different way:
>  * a HW flag that determines whether the driver can wake up with or
>   without an RTS frame (?)

Not enough there are 3 states you may request in SM_PS

>  * some way to tell mac80211 that MIMO isn't currently effective
Yes that we shell implement.

>  * mac80211 determines the SM PS mode based on
>   - the two inputs from the driver above
>   - user input

Correct

>   - association status (no need for all chains when not associated)
SM_PS mode has meaning only in association state, before association
it will only make sense in what state we enter association and we may
announce our SM_PS state already in association.

>   - possibly interface modes (maybe no need for MIMO when in mesh etc.)

Out of scope, HT is not enabled at all in these modes.

>  * mac80211 notifies the driver about the SM PS mode it should switch to
>   via the hw config callback

That's the current design

> I'm worried especially about the third bullet point, you've implemented
> the fourth but the driver is allowed to override this and mac80211 can't
> even make a proper decision because it doesn't have the inputs. I don't
> think having the first two inputs to mac80211 is "opening too much
> guts", it is, after all, something the policy engine needs, and that
> policy engine shouldn't be split up between the driver and mac80211.

I didn't submit any patch for that yet, believe me if I thought it's
closed issue you will have it in your mailbox already :)

Thanks for your valuable input
Tomas
