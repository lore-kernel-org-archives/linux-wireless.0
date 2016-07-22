Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33232 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbcGVJxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2016 05:53:55 -0400
Received: by mail-io0-f194.google.com with SMTP id y195so7118221iod.0
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jul 2016 02:53:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160721153948.32171-1-me@bobcopeland.com>
References: <20160721153948.32171-1-me@bobcopeland.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 22 Jul 2016 19:53:35 +1000
Message-ID: <CAGRGNgWHJEFBnak-MCK2htkaeQcZ6dmZ=w96omC99G5Z2UJWFg@mail.gmail.com> (sfid-20160722_115400_093481_7F8D4155)
Subject: Re: [PATCH] iw: display 5/10 MHz channel widths
To: Bob Copeland <me@bobcopeland.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bob,

On Fri, Jul 22, 2016 at 1:39 AM, Bob Copeland <me@bobcopeland.com> wrote:
> iw was showing 'width: unknown' for channels on OCB interfaces; teach
> it the values for 5/10 MHz so it will show the configured width.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  interface.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/interface.c b/interface.c
> index 209561d..2802235 100644
> --- a/interface.c
> +++ b/interface.c
> @@ -295,6 +295,10 @@ char *channel_width_name(enum nl80211_chan_width width)
>                 return "80+80 MHz";
>         case NL80211_CHAN_WIDTH_160:
>                 return "160 MHz";
> +       case NL80211_CHAN_WIDTH_5:
> +               return "5 MHz";
> +       case NL80211_CHAN_WIDTH_10:
> +               return "10 MHz";
>         default:
>                 return "unknown";
>         }

Judging by the previous two entries, it looks like the case statements
are sorted, so should these ones therefore be at the top of the list?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
