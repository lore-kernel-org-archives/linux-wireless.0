Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62289 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab2K1Xxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 18:53:45 -0500
Received: by mail-vb0-f46.google.com with SMTP id ff1so8670901vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 15:53:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354139095-22937-1-git-send-email-johannes@sipsolutions.net>
References: <1354139095-22937-1-git-send-email-johannes@sipsolutions.net>
Date: Thu, 29 Nov 2012 01:53:43 +0200
Message-ID: <CAB3XZEeuZOv_gHD2q0-K3JUXhjgTFx3AgZ1vS0Rc-toOVf-kTA@mail.gmail.com> (sfid-20121129_005348_483274_AD75A896)
Subject: Re: [PATCH] cfg80211: fix cmp_hidden_bss
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 28, 2012 at 11:44 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> The cmp_bss() comparator function uses memcmp() to
> compare the SSID. This means that cmp_hidden_bss()
> needs to similarly return a number bigger than zero
> (use 1) instead of -1 when ie1 is bigger than ie2,
> which is the case if an ie2 byte is non-zero.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/wireless/scan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index 9233910..57855bc 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -472,7 +472,7 @@ static int cmp_hidden_bss(struct cfg80211_bss *a, struct cfg80211_bss *b)
>         /* zeroed SSID ie is another indication of a hidden bss */
>         for (i = 0; i < ie2[1]; i++)
>                 if (ie2[i + 2])
> -                       return -1;
> +                       return 1;
>
>         return 0;
>  }

maybe i'm misreading it, but there is still no comparison here at all,
so it seems wrong as well :)
(practically, i guess it doesn't really matter, because if there is
some non-null char, this is not a hidden ssid anyway)

Eliad.
