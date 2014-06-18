Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:63850 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaFRWIt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2014 18:08:49 -0400
Received: by mail-la0-f41.google.com with SMTP id hz20so943238lab.14
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jun 2014 15:08:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1402469724-22358-3-git-send-email-arik@wizery.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com> <1402469724-22358-3-git-send-email-arik@wizery.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 18 Jun 2014 15:08:27 -0700
Message-ID: <CAB=NE6UZPcgAAJ6GAnjy2nSdYhLRqxo4h1ZZoZ7vYsAbYBiw+Q@mail.gmail.com> (sfid-20140619_000852_167075_2961B11F)
Subject: Re: [PATCH 3/5] cfg80211: treat the special "unknown" alpha2 as valid
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 10, 2014 at 11:55 PM, Arik Nemtsov <arik@wizery.com> wrote:
> If the regulatory request contains the special "99" unknown-country code,
> allow a different alpha2 as response.
>
> This special alpha2 is used when the real alpha2 is unknown and should
> be provided by the driver via its get_regd() wiphy callback, as part of
> the regdomain info.
>
> Change-Id: I286e3aed828cabf22292b6fe320fdcfa61f0b951
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> Reviewed-on: https://gerrit.rds.intel.com/32266
> Tested-by: IWL Jenkins
> Reviewed-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/wireless/reg.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index e2f33d7..c429ec5 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -418,7 +418,8 @@ static bool is_user_regdom_saved(void)
>                 return false;
>
>         /* This would indicate a mistake on the design */
> -       if (WARN(!is_world_regdom(user_alpha2) && !is_an_alpha2(user_alpha2),
> +       if (WARN(!is_world_regdom(user_alpha2) && !is_an_alpha2(user_alpha2) &&
> +                !is_unknown_alpha2(user_alpha2),
>                  "Unexpected user alpha2: %c%c\n",
>                  user_alpha2[0], user_alpha2[1]))
>                 return false;

When would the user alpha2 be a custom value? This is *very* different
than allowing an API to set the regulatory domain to a specific alpha2
value, which is what I though this was all about.

> @@ -595,7 +596,8 @@ bool reg_is_valid_request(const char *alpha2)
>         if (!lr || lr->processed)
>                 return false;
>
> -       return alpha2_equal(lr->alpha2, alpha2);
> +       return alpha2_equal(lr->alpha2, alpha2) ||
> +              is_unknown_alpha2(lr->alpha2);
>  }

This patch seems to be allowing custom user alpha2s to be passed,
while the commit log is indicating we want to allow a change from a
custom value that is set to a regular alpha2.

  Luis
