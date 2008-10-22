Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58205 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbYJVTVx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 15:21:53 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 12:21:53 -0700
Date: Wed, 22 Oct 2008 05:21:48 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
Subject: Re: [PATCH] wireless: add regulatory_struct_hint
Message-ID: <20081022122148.GF6190@tesla> (sfid-20081022_212158_800191_AF3588C9)
References: <1224585110.5521.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1224585110.5521.8.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2008 at 03:31:50AM -0700, Johannes Berg wrote:
> This adds a new function, regulatory_struct_hint, which acts
> as a hint to the wireless core which regdomain a card thinks
> the system is operating in, but given in terms of the actual
> regdomain definition. Multiple hints are permitted when the
> specified bands do not overlap.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Entirely untested. Anyone want to give it a go in the dual-band scenario?
> 
>  include/net/wireless.h |   14 +++
>  net/wireless/reg.c     |  225 ++++++++++++++++++++++++++++++++-----------------
>  2 files changed, 161 insertions(+), 78 deletions(-)
> 
> --- everything.orig/include/net/wireless.h      2008-10-21 11:50:01.000000000 +0200
> +++ everything/include/net/wireless.h   2008-10-21 11:50:16.000000000 +0200
> @@ -355,4 +355,18 @@ ieee80211_get_channel(struct wiphy *wiph
>   * for a regulatory domain structure for the respective country.
>   */
>  extern void regulatory_hint(const char *alpha2);
> +
> +/**
> + * regulatory_struct_hint - hint wireless core about regdomain
> + *
> + * @rd: regdomain structure containing the frequency ranges that are
> + *     permitted for use.
> + * @bands: bitmask of bands this contains, use BIT(IEEE80211_BAND_...)

Since this is only for wiphys this seems reasonable. I just keep in the
back of my mind leaving open the possibility for other wireless
subsystems to be able to make use of the currently set regulatory domain
and its regulatory rules, but this is in keeping with that as our
current requests are not changing the regulatory definitions, and just
as we have a wiphy for last_request we can add later struct
foo_new_wireless_type there too. I am curious if band definitions
should be shared between Bluetooth and 802.11 though. I don't think
BT devices have any notion of regulatory though nor are they capable of
exporting it though. Marcel is this correct? Inaky -- how about uwb, or
WiMax?

For our purposes though this is OK though, just wanted to make that
note, so we keep in mind this *can* potentially be used by other
wireless foo.

> + *
> + * This function informs the wireless core that the driver believes
> + * that the bands indicated are defined by the given structure in the
> + * regulatory domain the system is operating in.
> + */
> +extern void regulatory_struct_hint(struct ieee80211_regdomain *rd,
> +                                  u32 bands);
>  #endif /* __NET_WIRELESS_H */
> --- everything.orig/net/wireless/reg.c  2008-10-21 11:50:14.000000000 +0200
> +++ everything/net/wireless/reg.c       2008-10-21 12:26:08.000000000 +0200
> @@ -45,9 +45,9 @@
>  /* wiphy is set if this request's initiator is REGDOM_SET_BY_COUNTRY_IE */
>  struct regulatory_request {
>         struct wiphy *wiphy;
> -       int granted;
>         enum reg_set_by initiator;
>         char alpha2[2];
> +       u32 bands;
>  };
> 
>  static struct regulatory_request *last_request;
> @@ -296,82 +296,6 @@ static int call_crda(const char *alpha2)
>         return kobject_uevent_env(&reg_pdev->dev.kobj, KOBJ_CHANGE, envp);
>  }
> 
> -/* This has the logic which determines when a new request
> - * should be ignored. */
> -static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
> -                         const char *alpha2)
> -{

<-- snip -->

> -}
> -
>  /* Used by nl80211 before kmalloc'ing our regulatory domain */
>  bool reg_is_valid_request(const char *alpha2)
>  {

<-- snip -->

>         }
>  }
> 
> +/* This has the logic which determines when a new request
> + * should be ignored. */
> +static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
> +                         const char *alpha2)
> +{
> +}

I take it reg_is_valid_request() was just shifted, no changes were made to it
here?

> +
>  /* Caller must hold &cfg80211_drv_mutex */
>  int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
>                       const char *alpha2)
> @@ -567,6 +568,7 @@ int __regulatory_hint(struct wiphy *wiph
>                 request->alpha2[1] = alpha2[1];
>                 request->initiator = set_by;
>                 request->wiphy = wiphy;
> +               request->bands = ~0;
> 
>                 kfree(last_request);
>                 last_request = request;
> @@ -594,6 +596,74 @@ void regulatory_hint(const char *alpha2)
>  }
>  EXPORT_SYMBOL(regulatory_hint);
> 
> +void regulatory_struct_hint(struct ieee80211_regdomain *rd, u32 bands)

I see you changed the return value to void for both routines the driver
or a subsystem can use, can you elaborate on the kdoc why this is the
case?

> +{
> +       const struct ieee80211_regdomain *orig = NULL;
> +       struct ieee80211_regdomain *new = NULL;
> +       int origrules;
> +
> +       BUG_ON(!rd);
> +       BUG_ON(!bands);
> +
> +       mutex_lock(&cfg80211_drv_mutex);
> +
> +       /*
> +        * ignore hint if anything else set it or if the given
> +        * bands overlap already defined bands

Is the assumption all along here that this is for hardware which registers
only the channels its hardware is legally capable of? If so can the
documentation clarify that?

Otherwise it would seem to me if USER already set it we should get the
intersection. For example when a user plugs in a USB wireless
card it would not have gotten the chance to have regulatory_hint'd
first so the user may have already set it and if the driver
didn't have a reg_notifier() and simply registered all the channels
upon mac80211 register then the channels the user set will be
allowed. Also what about when the COUNTRY_IE had set it (remember the
result of such country IE request may be in an intersection with the
first driver too, but its ok, we always can trust the result of the
structure of the last set regdomain)? Again, disregard this comment
if the answer to the above paragraph is yes.

> +        */
> +       if (last_request) {
> +               switch (last_request->initiator) {
> +               case REGDOM_SET_BY_DRIVER:
> +                       if (last_request->bands & bands)
> +                               goto out;
> +                       break;
> +               case REGDOM_SET_BY_CORE:
> +                       break;
> +               default:
> +                       goto out;
> +               }
> +
> +               /* modify the currently set regdom */
> +               orig = cfg80211_regdomain;
> +               origrules = orig->n_reg_rules;
> +       } else {
> +               last_request = kzalloc(sizeof(struct regulatory_request),
> +                                      GFP_KERNEL);
> +               if (!last_request)
> +                       goto out;
> +
> +               last_request->alpha2[0] = '9';
> +               last_request->alpha2[1] = '9';
> +               last_request->initiator = REGDOM_SET_BY_DRIVER;
> +
> +               origrules = 0;
> +       }
> +
> +       last_request->bands |= bands;
> +
> +       new = krealloc(orig,
> +                      sizeof(struct ieee80211_regdomain) +
> +                      sizeof(struct ieee80211_reg_rule) * origrules +
> +                      sizeof(struct ieee80211_reg_rule) * rd->n_reg_rules,
> +                      GFP_KERNEL);

Very nice :)

> +       if (!new)
> +               goto out;
> +
> +       new->alpha2[0] = '9';
> +       new->alpha2[1] = '9';

What about cases where the alpha2 can be determined? I know we have no
such hardware yet and doubt we will though. Or are we just going to
point those to use the alpha2 call instead?

> +       new->n_reg_rules = origrules + rd->n_reg_rules;
> +       /* original rules still intact */
> +       memcpy(&new->reg_rules[origrules],
> +              rd->reg_rules,
> +              sizeof(struct ieee80211_reg_rule) * rd->n_reg_rules);

So did this work ? :) Zhu Yi, did you get to test?

> +
> +       set_regdom(new);
> +       kfree(rd);

Very nice indeed.

> +
> + out:
> +       mutex_unlock(&cfg80211_drv_mutex);
> +}
> +
> 
>  static void print_rd_rules(const struct ieee80211_regdomain *rd)
>  {
> @@ -710,7 +780,6 @@ static int __set_regdom(const struct iee
> 
>         /* Tada! */
>         cfg80211_regdomain = rd;
> -       last_request->granted = 1;

What's wrong with this?

  Luis
