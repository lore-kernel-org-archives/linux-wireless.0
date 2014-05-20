Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:64928 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaETIpC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 04:45:02 -0400
Received: by mail-lb0-f173.google.com with SMTP id 10so120680lbg.32
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 01:45:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399798250-20987-4-git-send-email-emmanuel.grumbach@intel.com>
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com> <1399798250-20987-4-git-send-email-emmanuel.grumbach@intel.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 20 May 2014 01:44:40 -0700
Message-ID: <CAB=NE6Wwv0y1cOZrpLe+yjZqHLmZpdJ3dYaLhLro==x4-t9UzA@mail.gmail.com> (sfid-20140520_104516_680802_558B8C9F)
Subject: Re: [PATCH 3/7] cfg80211: allow drivers to provide regulatory settings
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 11, 2014 at 1:50 AM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
> From: Arik Nemtsov <arik@wizery.com>
>
> Define a new wiphy callback allowing drivers to provide regulatory
> settings.
>
> Only The first wiphy registered with this callback will be able to provide
> regulatory domain info. If such a wiphy exists, it takes precedence over
> other data sources.
>
> Change-Id: I7c7e368e200c1414b53e3a86e131de24adc62b93
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  include/net/cfg80211.h | 17 +++++++++++++
>  net/wireless/reg.c     | 65 +++++++++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 76 insertions(+), 6 deletions(-)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index f2c3186..3c96b62 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -3008,6 +3008,23 @@ struct wiphy {
>         void (*reg_notifier)(struct wiphy *wiphy,
>                              struct regulatory_request *request);
>
> +       /*
> +        * Indicates this wiphy can provide regulatory information.
> +        * Must be set before the wiphy is registered. Only the first
> +        * wiphy with this callback will be called to provide a regdomain
> +        * on country-code changes. The alpha2 in the returned regdomain
> +        * information can be different from the one given via argument,
> +        * if the argument contains the "99" alpha2, meaning unknown.
> +        * If an ERR_PTR is returned the regulatory core will consult other
> +        * sources for the regdomain info (internal regdb and CRDA).
> +        * Returning NULL will cause the regdomain to remain the same.
> +        * The callee will return a struct allocated with kmalloc(). After
> +        * the struct is returned, the regulatory core is responsible
> +        * for freeing it.
> +        */

Use kdoc instead of this long documentation blob.

> +       struct ieee80211_regdomain * (*get_regd)(struct wiphy *wiphy,
> +                                                const char *alpha2);
> +
>         /* fields below are read-only, assigned by cfg80211 */
>
>         const struct ieee80211_regdomain __rcu *regd;

The driver should be able to dump a regdomain it needs when it needs
it and use the internal callbacks wiphy_apply_custom_regulatory()
which tons of drivers already use when it needs to upon
initialization. As for country IE data you can ignore country IEs,
there's a flag for this, and do what you want on firmware just as that
crappy non-upstream vendor qualcomm driver does. Apart from that its
unclear in this patch why instead any delta observed on wireless-regdb
is addressed publicly I'd like for this to be considered as a sane
alternative. Additionally keeping regulatory data in firmware is very
bug prone and it also doesn't let us grow mature the architecture on
cfg80211, Intel's firmware has historically only had a few world
regulatory domains, and historically this is why not much
contributions from Intel have gone into wireless-regdb, if there is a
need to support specific countries now on firmware I'd encourage the
firmware bloat strategy to be seriously reconsidered in light of the
issues that could arise.

  Luis
