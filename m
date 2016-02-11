Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:37848 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbcBKAMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2016 19:12:43 -0500
Received: by mail-ig0-f180.google.com with SMTP id 5so26305103igt.0
        for <linux-wireless@vger.kernel.org>; Wed, 10 Feb 2016 16:12:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1455148822-13849-1-git-send-email-ola1olsson@gmail.com>
References: <1455148822-13849-1-git-send-email-ola1olsson@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 11 Feb 2016 11:12:23 +1100
Message-ID: <CAGRGNgWY+1Axri83WE6T-MQqcTn3bmmJNqtJBdfRk5nPKMQN2g@mail.gmail.com> (sfid-20160211_011246_642950_408BA99C)
Subject: Re: [PATCH] nl80211: Zero out the connection keys memory when freeing them.
To: Ola Olsson <ola1olsson@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ola Olsson <ola.olsson@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ola,

On Thu, Feb 11, 2016 at 11:00 AM, Ola Olsson <ola1olsson@gmail.com> wrote:
> The connection keys are zeroed out in all other cases except this
> one. Let's fix the last one as well.
>
> Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>

Makes sense to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  net/wireless/nl80211.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 72de698..c1ef6ce 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -7547,7 +7547,7 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
>
>                 if ((ibss.chandef.width != NL80211_CHAN_WIDTH_20_NOHT) &&
>                     no_ht) {
> -                       kfree(connkeys);
> +                       kzfree(connkeys);
>                         return -EINVAL;
>                 }
>         }
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
