Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:37508 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2K2Jm1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 04:42:27 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so14285525oag.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2012 01:42:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354179660-11964-1-git-send-email-johannes@sipsolutions.net>
References: <1354139095-22937-1-git-send-email-johannes@sipsolutions.net>
	<1354179660-11964-1-git-send-email-johannes@sipsolutions.net>
Date: Thu, 29 Nov 2012 11:42:26 +0200
Message-ID: <CAB3XZEd4pfJ+gRcDxK4DWhYW-s72g4-8gqoNYwz17nGTkpcsGg@mail.gmail.com> (sfid-20121129_104232_381042_BCCAA327)
Subject: Re: [PATCH v2] cfg80211: fix cmp_hidden_bss
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 29, 2012 at 11:01 AM, Johannes Berg
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
>  net/wireless/scan.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index 9233910..456c342 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -469,10 +469,14 @@ static int cmp_hidden_bss(struct cfg80211_bss *a, struct cfg80211_bss *b)
>         if (ie1[1] != ie2[1])
>                 return ie2[1] - ie1[1];
>
> -       /* zeroed SSID ie is another indication of a hidden bss */
> +       /*
> +        * zeroed SSID ie is another indication of a hidden bss;
> +        * if it isn't zeroed just return the regular sort value
> +        * to find the next candidate
> +        */
>         for (i = 0; i < ie2[1]; i++)
>                 if (ie2[i + 2])
> -                       return -1;
> +                       return memcmp(ie1 + 2, ie2 + 2, ie1[1]);
>
>         return 0;
>  }

btw, it might be worth noting that this comparator works correctly
only in one way (if hidden ssid is in "b")...

Eliad.
