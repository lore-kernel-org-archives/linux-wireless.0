Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35453 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbcE3Fce (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2016 01:32:34 -0400
MIME-Version: 1.0
In-Reply-To: <ca13e9bde679512a872e5136c177676d0238dc25.1464576022.git.kirtika.ruchandani@gmail.com>
References: <cover.1464576022.git.kirtika.ruchandani@gmail.com> <ca13e9bde679512a872e5136c177676d0238dc25.1464576022.git.kirtika.ruchandani@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 30 May 2016 15:32:14 +1000
Message-ID: <CAGRGNgXVvX2zjp7HjNsYJP=tSc3XM7O5sSXf9=8JmPdd20QJtw@mail.gmail.com> (sfid-20160530_073238_132811_9294CDCC)
Subject: Re: [PATCH v2 10/10] nl80211: Prefer kcalloc over kzalloc
To: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Mon, May 30, 2016 at 12:54 PM, Kirtika Ruchandani
<kirtika.ruchandani@gmail.com> wrote:
> This patch fixes the checkpatch.pl warning -
> "prefer kcalloc over kzalloc with multiply"
>
> Signed-off-by: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>

Looks right to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

Julian Calaby


> ---
>  net/wireless/nl80211.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 46757af..2964406 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -9482,7 +9482,7 @@ static int nl80211_parse_wowlan_nd(struct cfg80211_registered_device *rdev,
>         struct nlattr **tb;
>         int err;
>
> -       tb = kzalloc(NUM_NL80211_ATTR * sizeof(*tb), GFP_KERNEL);
> +       tb = kcalloc(NUM_NL80211_ATTR, sizeof(*tb), GFP_KERNEL);
>         if (!tb)
>                 return -ENOMEM;
>
> --
> 2.8.0.rc3.226.g39d4020
>



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
