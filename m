Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52595 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286Ab2LMV1f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 16:27:35 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so2218928lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 13:27:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-19-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-19-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 13 Dec 2012 13:27:14 -0800
Message-ID: <CAB=NE6WVa8bqbe2oyfpEaEJ84s6+C=9wM9+wzgtm6HUNaqm4DQ@mail.gmail.com> (sfid-20121213_222738_841890_A6BADE5B)
Subject: Re: [PATCH 18/24] regulatory: fix reg_is_valid_request handling
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> There's a bug with the world regulatory domain, it
> can be updated any time which is different from all
> other regdomains that can only be updated once after
> a request for them. Fix this by adding a check for
> "processed" to the reg_is_valid_request() function
> and clear that when doing a request.
>
> While looking at this I also found another locking
> bug, last_request is protected by the reg_mutex not
> the cfg80211_mutex so the code in nl80211 is racy.
> Remove that code as it only tries to prevent an
> allocation in an error case, which isn't necessary.
> Then the function can also become static and locking
> in nl80211 can have a smaller scope.
>
> Also change __set_regdom() to do the checks earlier
> and not different for world/other regdomains.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/wireless/nl80211.c |  9 ++-------
>  net/wireless/reg.c     | 21 +++++++++++----------
>  net/wireless/reg.h     |  1 -
>  3 files changed, 13 insertions(+), 18 deletions(-)
>
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 260b5d8..370cd31 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -4333,6 +4326,8 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
>                 }
>         }
>
> +       mutex_lock(&cfg80211_mutex);
> +
>         r = set_regdom(rd);
>         rd = NULL;

Unless you removed it from previous patches in the series the
"bad_reg" goto label has an unlock but above you removed the top
locking call so I think you just forgot to remove the unlock on the
goto label.

> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index dfab71b..10d8edb 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -426,12 +426,16 @@ static int call_crda(const char *alpha2)
>         return kobject_uevent(&reg_pdev->dev.kobj, KOBJ_CHANGE);
>  }
>
> -/* Used by nl80211 before kmalloc'ing our regulatory domain */
> -bool reg_is_valid_request(const char *alpha2)
> +static bool reg_is_valid_request(const char *alpha2)
>  {
> +       assert_reg_lock();
> +
>         if (!last_request)
>                 return false;
>
> +       if (last_request->processed)
> +               return false;
> +
>         return alpha2_equal(last_request->alpha2, alpha2);
>  }
>
> @@ -1471,6 +1475,7 @@ new_request:
>
>         last_request = pending_request;
>         last_request->intersect = intersect;
> +       last_request->processed = false;

The clearing you are doing is on the last_request but it comes from
the pending regulatory request which is always false given that the
request is kzalloc'd, not sure if that was needed or how that helped.

Apart from that looks good.

  Luis
