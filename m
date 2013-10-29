Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:43567 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab3J2NOG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 09:14:06 -0400
Received: by mail-la0-f49.google.com with SMTP id eh20so6296845lab.22
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 06:14:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1383048716-5886-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1383048716-5886-1-git-send-email-janusz.dziedzic@tieto.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 29 Oct 2013 14:13:44 +0100
Message-ID: <CAB=NE6Vd6Kq5ezW2J6vV-c5tt3gqxfz5otgnKrgWAaV2Q4gcWQ@mail.gmail.com> (sfid-20131029_141410_557617_C06DC467)
Subject: Re: [PATCH v2 1/2] cfg80211: handle correctly prohibited flags
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 29, 2013 at 1:11 PM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> Handle correctly prohibited flags in cfg80211_secondary_chans_ok()
> function. Before, we ignore IEEE80211_CHAN_RADAR flag even
> caller put the flag as prohibited one.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
>  net/wireless/chan.c |   11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
>
> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> index a6f5c4c..6f2be48 100644
> --- a/net/wireless/chan.c
> +++ b/net/wireless/chan.c
> @@ -438,16 +438,7 @@ static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
>
>         for (freq = start_freq; freq <= end_freq; freq += 20) {
>                 c = ieee80211_get_channel(wiphy, freq);
> -               if (!c)
> -                       return false;
> -
> -               /* check for radar flags */
> -               if ((prohibited_flags & c->flags & IEEE80211_CHAN_RADAR) &&
> -                   (c->dfs_state != NL80211_DFS_AVAILABLE))
> -                       return false;
> -
> -               /* check for the other flags */
> -               if (c->flags & prohibited_flags & ~IEEE80211_CHAN_RADAR)
> +               if (!c || c->flags & prohibited_flags)
>                         return false;
>         }

NACK

Although you do something that looks good here you are breaking this
check atomically for this commit and introducing a regression here,
you want to merge the two patches together.

  Luis
