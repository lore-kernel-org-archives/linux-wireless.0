Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:52370 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab2LMVf5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 16:35:57 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so2222206lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 13:35:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-21-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-21-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 13 Dec 2012 13:35:35 -0800
Message-ID: <CAB=NE6Ush3Z+-V2LXtW4ApYqig+FfHz1Jm1dUXc5cka2Gnougg@mail.gmail.com> (sfid-20121213_223559_832470_3AFE5CD6)
Subject: Re: [PATCH 20/24] regulatory: fix memory leak
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> If duplicating here fails, we leak the original.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/wireless/reg.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 011fab9..5a34830 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -2120,8 +2120,10 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
>                         return -EALREADY;
>
>                 regd = reg_copy_regd(rd);
> -               if (IS_ERR(regd))
> +               if (IS_ERR(regd)) {
> +                       kfree(rd);
>                         return PTR_ERR(regd);
> +               }

The caller, set_regdom() free's t for us if we fail though so I don't
see how this was leaked.

int set_regdom(const struct ieee80211_regdomain *rd)
{
        int r;

        assert_cfg80211_lock();

        mutex_lock(&reg_mutex);

        /* Note that this doesn't update the wiphys, this is done below */
        r = __set_regdom(rd);
        if (r) {
                if (r == -EALREADY)
                        reg_set_request_processed();

                kfree(rd);
                mutex_unlock(&reg_mutex);
                return r;
        }
...
}

  Luis
