Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:37346 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaETIKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 04:10:19 -0400
Received: by mail-la0-f49.google.com with SMTP id pv20so87031lab.22
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 01:10:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399798250-20987-2-git-send-email-emmanuel.grumbach@intel.com>
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com> <1399798250-20987-2-git-send-email-emmanuel.grumbach@intel.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 20 May 2014 01:09:57 -0700
Message-ID: <CAB=NE6XydtDn4v-VWReaR3p6bePyySjvnO0Sf_f3=xRi9bZs7g@mail.gmail.com> (sfid-20140520_101024_438104_80C8F06D)
Subject: Re: [PATCH 1/7] cfg80211: don't set reg timeout for user-handled hint
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
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
> Otherwise every "indoor" setting by usermode will cause a regdomain reset.
>
> Change-Id: I3225325d9fb956174458d386d4dd0f4e069deb58
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  net/wireless/reg.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index e78f532..558b0e3 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1876,7 +1876,8 @@ static void reg_process_hint(struct regulatory_request *reg_request)
>         case NL80211_REGDOM_SET_BY_USER:
>                 treatment = reg_process_hint_user(reg_request);
>                 if (treatment == REG_REQ_IGNORE ||
> -                   treatment == REG_REQ_ALREADY_SET)
> +                   treatment == REG_REQ_ALREADY_SET ||
> +                   treatment == REG_REQ_USER_HINT_HANDLED)
>                         return;
>                 queue_delayed_work(system_power_efficient_wq,
>                                    &reg_timeout, msecs_to_jiffies(3142));

This patch would create a conflict with Janusz's patch, but otherwise
it looks fine to me.

Acked-by: Luis R. Rodriguez <mcgrof@suse.com>

  Luis
