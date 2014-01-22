Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:42508 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511AbaAVSCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 13:02:43 -0500
Received: by mail-qa0-f50.google.com with SMTP id cm18so851373qab.37
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 10:02:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390382185.4334.19.camel@jlt4.sipsolutions.net>
References: <1390382185.4334.19.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <twpedersen@gmail.com>
Date: Wed, 22 Jan 2014 10:02:22 -0800
Message-ID: <CAHmEv86saxzZzy-qS6C_6k48EXFh2GVb8gVEcwJcBKQtj1Cv7Q@mail.gmail.com> (sfid-20140122_190248_191511_C99052AE)
Subject: Re: [PATCH] nl80211: check channel switch validity better
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 22, 2014 at 1:16 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Before allowing userspace to initiate a channel switch, check
> that it's actually connected in some sense. Also use a more
> appropriate error code for the not connected case.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/wireless/nl80211.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 6e78c62..0c2ef08 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -5799,10 +5799,15 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
>
>                 /* useless if AP is not running */
>                 if (!wdev->beacon_interval)
> -                       return -EINVAL;
> +                       return -ENOTCONN;
>                 break;
>         case NL80211_IFTYPE_ADHOC:
> +               if (!wdev->ssid_len)
> +                       return -ENOTCONN;
> +               break;
>         case NL80211_IFTYPE_MESH_POINT:
> +               if (!wdev->mesh_id_len)
> +                       return -ENOTCONN;

Hmmm. I'm pretty sure there are some users which set the channel prior
to mesh join. This would break that and only allow sending the channel
with mesh join?

Thomas
