Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45170 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaFXGhq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 02:37:46 -0400
Received: by mail-pd0-f171.google.com with SMTP id fp1so6607803pdb.30
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 23:37:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6Wburfgomm81BL-MPsqZSSCSMNyim29OWw3Twj8q2AOUQ@mail.gmail.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
 <1402469724-22358-2-git-send-email-arik@wizery.com> <CAB=NE6Wburfgomm81BL-MPsqZSSCSMNyim29OWw3Twj8q2AOUQ@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 24 Jun 2014 09:37:29 +0300
Message-ID: <CA+XVXff1SLHvP3PABdV1U2xw8CQW660xJR1QMUkW0QaaEpThYQ@mail.gmail.com> (sfid-20140624_083750_423168_BB7610B5)
Subject: Re: [PATCH 2/5] cfg80211: allow drivers to provide regulatory settings
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 19, 2014 at 2:32 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Tue, Jun 10, 2014 at 11:55 PM, Arik Nemtsov <arik@wizery.com> wrote:
>> Define a new wiphy callback allowing drivers to provide regulatory
>> settings.
>>
>> Only The first wiphy registered with this callback will be able to provide
>> regulatory domain info. If such a wiphy exists, it takes precedence over
>> other data sources.
>>
>> Change-Id: If8f8faf1d127120ae464b45098c5edbc5aee3dc0
>> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
>> Reviewed-on: https://gerrit.rds.intel.com/32858
>> Tested-by: IWL Jenkins
>> Reviewed-by: Johannes Berg <johannes.berg@intel.com>
>> ---
>>  include/net/cfg80211.h | 16 +++++++++++++
>>  net/wireless/reg.c     | 65 +++++++++++++++++++++++++++++++++++++++++++++-----
>>  2 files changed, 75 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>> index 5c17b1f..b8f0269 100644
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>> @@ -2950,6 +2950,19 @@ struct wiphy_vendor_command {
>>   *     low rssi when a frame is heard on different channel, then it should set
>>   *     this variable to the maximal offset for which it can compensate.
>>   *     This value should be set in MHz.
>> + * @get_regd: a driver callback to for publishing regulatory information.
>> + *     By implementing this callback, a wiphy indicates it will provide
>> + *     regulatory information. The callback must be set before the wiphy is
>> + *     is registered. Only the first wiphy with this callback will be called
>> + *     to provide a regdomain on country-code changes.
>
> The way this is implemented is a bit more exclusive than this kdoc
> explains -- the way its implemented below allows only a single wiphy
> *ever* to be registered with this capability. This means that external
> attachments such as USB 802.11 devices that have this API requirement
> cannot ensure that they will get this callback issued. What do we want
> to do about that?

Well Intel regulatory constraints require us to be the "dictator".
This feature is also primarily designed for systems which are not
extensible, so you can't really add another device.
I guess we'll have to solve this when the need arises.

>
> Why are we not just considering multiple cards with these capabilities
> as equal and simply deal with the intersections as with the other
> cases? The restriction seems to limit our capabilities and likely will
> require bug reporting / issues to be fleshed out later. I rather
> address this now.
>
>> + *     Returns A driver allocated regdomain structure.
>
> "a" instead of capital A.

Thanks.

>
>> +                                                                           The alpha2 in the
>> + *     returned regdomain can be different from the one given via the alpha2
>> + *     argument, if the argument contains "99", meaning unknown.
>
> Lets be upfront -- how many regulatory domains will you guys return
> right now in which the same alpha2 will be kept? I don't like this for
> one bit at all, if you are going to return a 99 for a specific alpha2
> it must mean firmware / driver has the ability to search for an alpha2
> for a set of custom regulatory domains, which should also mean you
> should be able to return a set of alpha2s that can be used for the
> custom regulatory domain, so I'd like to see that added as a possible
> return set. This should set expectations for users, build a better
> understanding of how all this works, and most importantly enable easy
> and shorter scraping of the firmware for our own research and
> development and advancement of wireless-regdb as otherwise we'd have
> to loop over every alpha2 and then deduce grouping. This is the only
> way I see this being reasonable to accept upstream.

I think you're misunderstanding things here. We only give back real
regulatory domains. The "99" is only used as a means the get the
currently NVRAM flashed regdomain from FW.
We discussed this on the other patch.. Perhaps I should tweak the
explanation a bit here.

>
> We also should be clear now in the documentation about the differences
> and purpose behind this API and the custom regulatory which tons of
> folks already use. In this case the requirement was dynamic changes
> and to ensure these changes get back to userspace permissively as
> otherwise they could not. The way I see it the custom stuff should be
> used for custom world regulatory domains -- this new API is for
> specific alpha2s. This should also mean then that this API should
> *not* be used to query the firmware for the world regulatory domain.

Why not? What's problematic here?
I would much prefer to keep a single API for everything.

> It also means that the custom flag has to be looked at carefully as
> well now since the custom flag may need to be lifted dynamically. You
> may want to look at the Atheros ath module for the different use cases
> as they ship tons of different types of devices: world roaming, and
> also cards with a specific alpha2 set. There's a bit of boiler place
> code there that I saw tons of drivers share / copy so perhaps some
> boiler plate code might be in order to help here.

It is already lifted dynamically if a driver regulatory hint arrives.

>
> This new API makes only sense for dynamic changes and as such I do
> expect this to be used for direct alpha2 mappings, not some region
> stuff. Grouping regulatory domains to groups makes sense to save size
> -- we've seen this before by other vendors but we should be easily
> able to get the group alpha2 mapping as well. If Intel is *not* going
> to contribute to wireless-regdb this at the very least should help us
> move forward with the public regdb by providing back mapping of all
> the alpha2s that a regulatory domain passed also applies to.

The API currently doesn't work this way. I'll ask the regulatory folks
for a table, but I can't promise anything.

>
>> + *     If an ERR_PTR is returned the regulatory core will consult other
>> + *     sources for the regdomain info (internal regdb and CRDA).
>
> That's nice.
>
>> +                                                                                           Returning
>> + *     NULL will cause the regdomain to remain the same.
>
>
> What do you mean by this? Can you please elaborate exactly what this means?

It means we will ignore the request. Not sure what's to elaborate.

>>  static struct regulatory_request core_request_world = {
>> @@ -129,6 +132,15 @@ static int reg_num_devs_support_basehint;
>>   */
>>  static bool reg_is_indoor;
>>
>> +/*
>> + * Wiphy with a get_regd() callback that can provide regulatory information
>> + * when the country code changes. Only the first wiphy registered with the
>> + * get_regd callback will be called to provide a regdomain on country-code
>> + * changes.
>> + * (protected by RTNL)
>> + */
>> +static struct wiphy *regd_info_wiphy;
>
> Note all my feedback on the kdoc comment about this. This obviously
> doesn't scale well but more importantly given that devices bus
> configuration can change (regardless of what systemd folks think) it
> means that we can get different results on a system with 2 internal
> cards. Systems with multiple built in 802.11 cards were something of a
> theoretical myth back in the day when we started with 802.11 but not
> anymore. For example I'm very aware of some Freebox 802.11 APs with
> multiple built in 802.11 cards and from different vendors!  No only
> can this lead to issues with cards on different buses and races
> therein, but it could also produce different results on different
> architectures.

Agree it's a hairy issue, but I think we should get to this in a later
patch. It's not a simple issue or "fix".
Might need different policies, intersections, etc.

>
>> +
>>  static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
>>  {
>>         return rtnl_dereference(cfg80211_regdomain);
>> @@ -538,9 +550,39 @@ static int call_crda(const char *alpha2)
>>         return kobject_uevent_env(&reg_pdev->dev.kobj, KOBJ_CHANGE, env);
>>  }
>>
>> +static int call_wiphy_regd_info(const char *alpha2)
>> +{
>> +       struct ieee80211_regdomain *regd;
>> +
>> +       if (!regd_info_wiphy)
>> +               return -ENOENT;
>> +
>> +       /* can happen if the driver removes the callback at runtime */
>> +       if (WARN_ON(!regd_info_wiphy->get_regd))
>> +               return -EINVAL;
>
> I'd rather see a capability flag for this, that way we can also tell
> userspace of this ridiculous incarnation of crap on firmware, and when
> set we'd expect this to be set. If we want to address the dynamic
> removal / addition of the callback that can be dealt with when the
> time comes, but that doesn't seem to be required givenou'refe that you
> added API to let the firmware let cfg80211 pass through and use the
> wireless-regdb data.

Sure I'll add a capability flag.

>
>> +
>> +       regd = regd_info_wiphy->get_regd(regd_info_wiphy, alpha2);
>> +       if (IS_ERR(regd))
>> +               return -EIO;
>> +
>
> You're not feeding the firmware information on availability of the
> userspace regulatory domain, in the case of it was allowed, it seems
> to me that firmware might make a better decision in the case that
> userspace lacks information. Userspace can also be upgraded at runtime
> dynamically so whether or not userspace has a regulatory domain can
> change at run time. Please consider this.

The Intel use case doesn't use userspace regulatory information at
all. This can be extended later I guess.

Arik
