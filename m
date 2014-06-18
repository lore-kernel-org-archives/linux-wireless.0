Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34724 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbaFRXcu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2014 19:32:50 -0400
Received: by mail-lb0-f182.google.com with SMTP id c11so975590lbj.27
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jun 2014 16:32:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1402469724-22358-2-git-send-email-arik@wizery.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com> <1402469724-22358-2-git-send-email-arik@wizery.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 18 Jun 2014 16:32:29 -0700
Message-ID: <CAB=NE6Wburfgomm81BL-MPsqZSSCSMNyim29OWw3Twj8q2AOUQ@mail.gmail.com> (sfid-20140619_013254_802497_57ED4CB3)
Subject: Re: [PATCH 2/5] cfg80211: allow drivers to provide regulatory settings
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 10, 2014 at 11:55 PM, Arik Nemtsov <arik@wizery.com> wrote:
> Define a new wiphy callback allowing drivers to provide regulatory
> settings.
>
> Only The first wiphy registered with this callback will be able to provide
> regulatory domain info. If such a wiphy exists, it takes precedence over
> other data sources.
>
> Change-Id: If8f8faf1d127120ae464b45098c5edbc5aee3dc0
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> Reviewed-on: https://gerrit.rds.intel.com/32858
> Tested-by: IWL Jenkins
> Reviewed-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  include/net/cfg80211.h | 16 +++++++++++++
>  net/wireless/reg.c     | 65 +++++++++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 75 insertions(+), 6 deletions(-)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 5c17b1f..b8f0269 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -2950,6 +2950,19 @@ struct wiphy_vendor_command {
>   *     low rssi when a frame is heard on different channel, then it should set
>   *     this variable to the maximal offset for which it can compensate.
>   *     This value should be set in MHz.
> + * @get_regd: a driver callback to for publishing regulatory information.
> + *     By implementing this callback, a wiphy indicates it will provide
> + *     regulatory information. The callback must be set before the wiphy is
> + *     is registered. Only the first wiphy with this callback will be called
> + *     to provide a regdomain on country-code changes.

The way this is implemented is a bit more exclusive than this kdoc
explains -- the way its implemented below allows only a single wiphy
*ever* to be registered with this capability. This means that external
attachments such as USB 802.11 devices that have this API requirement
cannot ensure that they will get this callback issued. What do we want
to do about that?

Why are we not just considering multiple cards with these capabilities
as equal and simply deal with the intersections as with the other
cases? The restriction seems to limit our capabilities and likely will
require bug reporting / issues to be fleshed out later. I rather
address this now.

> + *     Returns A driver allocated regdomain structure.

"a" instead of capital A.

> +                                                                           The alpha2 in the
> + *     returned regdomain can be different from the one given via the alpha2
> + *     argument, if the argument contains "99", meaning unknown.

Lets be upfront -- how many regulatory domains will you guys return
right now in which the same alpha2 will be kept? I don't like this for
one bit at all, if you are going to return a 99 for a specific alpha2
it must mean firmware / driver has the ability to search for an alpha2
for a set of custom regulatory domains, which should also mean you
should be able to return a set of alpha2s that can be used for the
custom regulatory domain, so I'd like to see that added as a possible
return set. This should set expectations for users, build a better
understanding of how all this works, and most importantly enable easy
and shorter scraping of the firmware for our own research and
development and advancement of wireless-regdb as otherwise we'd have
to loop over every alpha2 and then deduce grouping. This is the only
way I see this being reasonable to accept upstream.

We also should be clear now in the documentation about the differences
and purpose behind this API and the custom regulatory which tons of
folks already use. In this case the requirement was dynamic changes
and to ensure these changes get back to userspace permissively as
otherwise they could not. The way I see it the custom stuff should be
used for custom world regulatory domains -- this new API is for
specific alpha2s. This should also mean then that this API should
*not* be used to query the firmware for the world regulatory domain.
It also means that the custom flag has to be looked at carefully as
well now since the custom flag may need to be lifted dynamically. You
may want to look at the Atheros ath module for the different use cases
as they ship tons of different types of devices: world roaming, and
also cards with a specific alpha2 set. There's a bit of boiler place
code there that I saw tons of drivers share / copy so perhaps some
boiler plate code might be in order to help here.

This new API makes only sense for dynamic changes and as such I do
expect this to be used for direct alpha2 mappings, not some region
stuff. Grouping regulatory domains to groups makes sense to save size
-- we've seen this before by other vendors but we should be easily
able to get the group alpha2 mapping as well. If Intel is *not* going
to contribute to wireless-regdb this at the very least should help us
move forward with the public regdb by providing back mapping of all
the alpha2s that a regulatory domain passed also applies to.

> + *     If an ERR_PTR is returned the regulatory core will consult other
> + *     sources for the regdomain info (internal regdb and CRDA).

That's nice.

> +                                                                                           Returning
> + *     NULL will cause the regdomain to remain the same.


What do you mean by this? Can you please elaborate exactly what this means?

> +                                                                                    The callee will
> + *     return a struct allocated with kmalloc(). After the struct is returned
> + *     the regulatory core is responsible for freeing it.
>   */
>  struct wiphy {
>         /* assign these fields before you register the wiphy */
> @@ -3033,6 +3046,9 @@ struct wiphy {
>         void (*reg_notifier)(struct wiphy *wiphy,
>                              struct regulatory_request *request);
>
> +       struct ieee80211_regdomain * (*get_regd)(struct wiphy *wiphy,
> +                                                const char *alpha2);
> +
>         /* fields below are read-only, assigned by cfg80211 */
>
>         const struct ieee80211_regdomain __rcu *regd;
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index efd6d0d..e2f33d7 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -78,6 +78,8 @@
>   *     further processing is required, i.e., not need to update last_request
>   *     etc. This should be used for user hints that do not provide an alpha2
>   *     but some other type of regulatory hint, i.e., indoor operation.
> + * @REG_REQ_HANDLED: a request was handled synchronously. No need to set
> + *     timeouts and potentially revert to the default settings.
>   */
>  enum reg_request_treatment {
>         REG_REQ_OK,
> @@ -85,6 +87,7 @@ enum reg_request_treatment {
>         REG_REQ_INTERSECT,
>         REG_REQ_ALREADY_SET,
>         REG_REQ_USER_HINT_HANDLED,
> +       REG_REQ_HANDLED,
>  };
>
>  static struct regulatory_request core_request_world = {
> @@ -129,6 +132,15 @@ static int reg_num_devs_support_basehint;
>   */
>  static bool reg_is_indoor;
>
> +/*
> + * Wiphy with a get_regd() callback that can provide regulatory information
> + * when the country code changes. Only the first wiphy registered with the
> + * get_regd callback will be called to provide a regdomain on country-code
> + * changes.
> + * (protected by RTNL)
> + */
> +static struct wiphy *regd_info_wiphy;

Note all my feedback on the kdoc comment about this. This obviously
doesn't scale well but more importantly given that devices bus
configuration can change (regardless of what systemd folks think) it
means that we can get different results on a system with 2 internal
cards. Systems with multiple built in 802.11 cards were something of a
theoretical myth back in the day when we started with 802.11 but not
anymore. For example I'm very aware of some Freebox 802.11 APs with
multiple built in 802.11 cards and from different vendors!  No only
can this lead to issues with cards on different buses and races
therein, but it could also produce different results on different
architectures.

> +
>  static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
>  {
>         return rtnl_dereference(cfg80211_regdomain);
> @@ -538,9 +550,39 @@ static int call_crda(const char *alpha2)
>         return kobject_uevent_env(&reg_pdev->dev.kobj, KOBJ_CHANGE, env);
>  }
>
> +static int call_wiphy_regd_info(const char *alpha2)
> +{
> +       struct ieee80211_regdomain *regd;
> +
> +       if (!regd_info_wiphy)
> +               return -ENOENT;
> +
> +       /* can happen if the driver removes the callback at runtime */
> +       if (WARN_ON(!regd_info_wiphy->get_regd))
> +               return -EINVAL;

I'd rather see a capability flag for this, that way we can also tell
userspace of this ridiculous incarnation of crap on firmware, and when
set we'd expect this to be set. If we want to address the dynamic
removal / addition of the callback that can be dealt with when the
time comes, but that doesn't seem to be required givenou'refe that you
added API to let the firmware let cfg80211 pass through and use the
wireless-regdb data.

> +
> +       regd = regd_info_wiphy->get_regd(regd_info_wiphy, alpha2);
> +       if (IS_ERR(regd))
> +               return -EIO;
> +

You're not feeding the firmware information on availability of the
userspace regulatory domain, in the case of it was allowed, it seems
to me that firmware might make a better decision in the case that
userspace lacks information. Userspace can also be upgraded at runtime
dynamically so whether or not userspace has a regulatory domain can
change at run time. Please consider this.

> +       if (regd)
> +               set_regdom(regd);
> +
> +       return 0;
> +}
> +
>  static enum reg_request_treatment
> -reg_call_crda(struct regulatory_request *request)
> +vreg_get_regdom_data(struct regulatory_request *request)
>  {
> +       ASSERT_RTNL();
> +
> +       /*
> +        * A wiphy wishing to set the regdomain takes precedence. Note the
> +        * regdomain setting happens synchronously inside.
> +        */
> +       if (!call_wiphy_regd_info(request->alpha2))
> +               return REG_REQ_HANDLED;
> +
>         if (call_crda(request->alpha2))
>                 return REG_REQ_IGNORE;
>         return REG_REQ_OK;
> @@ -1641,7 +1683,7 @@ reg_process_hint_core(struct regulatory_request *core_request)
>
>         reg_update_last_request(core_request);
>
> -       return reg_call_crda(core_request);
> +       return reg_get_regdom_data(core_request);
>  }
>
>  static enum reg_request_treatment
> @@ -1715,7 +1757,7 @@ reg_process_hint_user(struct regulatory_request *user_request)
>         user_alpha2[0] = user_request->alpha2[0];
>         user_alpha2[1] = user_request->alpha2[1];
>
> -       return reg_call_crda(user_request);
> +       return reg_get_regdom_data(user_request);
>  }
>
>  static enum reg_request_treatment
> @@ -1764,6 +1806,7 @@ reg_process_hint_driver(struct wiphy *wiphy,
>                 break;
>         case REG_REQ_IGNORE:
>         case REG_REQ_USER_HINT_HANDLED:
> +       case REG_REQ_HANDLED:
>                 reg_free_request(driver_request);
>                 return treatment;
>         case REG_REQ_INTERSECT:
> @@ -1794,7 +1837,7 @@ reg_process_hint_driver(struct wiphy *wiphy,
>                 return treatment;
>         }
>
> -       return reg_call_crda(driver_request);
> +       return reg_get_regdom_data(driver_request);
>  }
>
>  static enum reg_request_treatment
> @@ -1864,6 +1907,7 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
>                 break;
>         case REG_REQ_IGNORE:
>         case REG_REQ_USER_HINT_HANDLED:
> +       case REG_REQ_HANDLED:
>                 /* fall through */
>         case REG_REQ_ALREADY_SET:
>                 reg_free_request(country_ie_request);
> @@ -1883,7 +1927,7 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
>
>         reg_update_last_request(country_ie_request);
>
> -       return reg_call_crda(country_ie_request);
> +       return reg_get_regdom_data(country_ie_request);
>  }
>
>  /* This processes *all* regulatory hints */
> @@ -1903,7 +1947,8 @@ static void reg_process_hint(struct regulatory_request *reg_request)
>                 treatment = reg_process_hint_user(reg_request);
>                 if (treatment == REG_REQ_IGNORE ||
>                     treatment == REG_REQ_ALREADY_SET ||
> -                   treatment == REG_REQ_USER_HINT_HANDLED)
> +                   treatment == REG_REQ_USER_HINT_HANDLED ||
> +                   treatment == REG_REQ_HANDLED)
>                         return;
>                 queue_delayed_work(system_power_efficient_wq,
>                                    &reg_timeout, msecs_to_jiffies(3142));
> @@ -2684,6 +2729,9 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
>  {
>         struct regulatory_request *lr;
>
> +       if (wiphy->get_regd && !regd_info_wiphy)
> +               regd_info_wiphy = wiphy;
> +

This is rather limiting in architecture.

  Luis
