Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57011 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab1L3Fum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Dec 2011 00:50:42 -0500
Received: by vcbfk14 with SMTP id fk14so10504784vcb.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Dec 2011 21:50:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111229165800.GA7405@zenon.in.qult.net>
References: <20111229165800.GA7405@zenon.in.qult.net>
Date: Fri, 30 Dec 2011 11:20:40 +0530
Message-ID: <CAD2nsn2AZMPoOC1wuQ8CE9cWt8GhEEYQH8DO7c47ex+H+SEcXg@mail.gmail.com> (sfid-20111230_065046_817379_DAD38C95)
Subject: Re: [PATCH] net/mac80211/sta_info.c: Fix crash in ieee80211_sta_expire.
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ignacy Gawedzki <i@lri.fr>, linux-wireless@vger.kernel.org,
	Marek Lindner <lindner_marek@yahoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Dec 29, 2011 at 10:28 PM, Ignacy Gawedzki <i@lri.fr> wrote:
> Add missing brackets after applying ec2b774e7c91094d8c00de579646f1162b87b01e.


its already addressed by the patch
http://comments.gmane.org/gmane.linux.kernel.wireless.general/83198

> ---
>  net/mac80211/sta_info.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index f0d3b48..1b085f7 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -945,7 +945,7 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
>        struct sta_info *sta, *tmp;
>
>        mutex_lock(&local->sta_mtx);
> -       list_for_each_entry_safe(sta, tmp, &local->sta_list, list)
> +       list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
>                if (sdata != sta->sdata)
>                        continue;
>
> @@ -956,6 +956,7 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
>  #endif
>                        WARN_ON(__sta_info_destroy(sta));
>                }
> +       }
>        mutex_unlock(&local->sta_mtx);
>  }
>
> --
> 1.7.5.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
shafi
