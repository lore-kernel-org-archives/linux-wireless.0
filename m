Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48810 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab0LGXGK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 18:06:10 -0500
Received: by qwa26 with SMTP id 26so477813qwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 15:06:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291759599-14698-1-git-send-email-greearb@candelatech.com>
References: <1291759599-14698-1-git-send-email-greearb@candelatech.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 8 Dec 2010 00:05:50 +0100
Message-ID: <AANLkTinA7WKOz+bVX0CsF5ts9Yt=8aBN0O0OWffPjR1b@mail.gmail.com>
Subject: Re: [PATCH] wireless: Remove spurious warning in mlme.c
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 7, 2010 at 11:06 PM,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> Seems that we should not be warning if all of the
> authtry_bsses are already NULL.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 d7680f2... 866d016... M  net/wireless/mlme.c
>  net/wireless/mlme.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
> index d7680f2..866d016 100644
> --- a/net/wireless/mlme.c
> +++ b/net/wireless/mlme.c
> @@ -266,7 +266,7 @@ EXPORT_SYMBOL(cfg80211_send_disassoc);
>  static void __cfg80211_auth_remove(struct wireless_dev *wdev, const u8 *addr)
>  {
>        int i;
> -       bool done = false;
> +       bool done = true;
>
>        ASSERT_WDEV_LOCK(wdev);
>
> @@ -277,9 +277,10 @@ static void __cfg80211_auth_remove(struct wireless_dev *wdev, const u8 *addr)
>                        cfg80211_unhold_bss(wdev->authtry_bsses[i]);
>                        cfg80211_put_bss(&wdev->authtry_bsses[i]->pub);
>                        wdev->authtry_bsses[i] = NULL;
> -                       done = true;
>                        break;
>                }
> +               else if (wdev->authtry_bsses[i])
> +                       done = false;

Coding style issues: always put the else on the same line as the
closing brace, and if one branch is braced, both branches should be
so.

>        }
>
>        WARN_ON(!done);
> --
> 1.7.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
