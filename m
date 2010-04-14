Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33766 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab0DNGvS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 02:51:18 -0400
Received: by gyg13 with SMTP id 13so3962913gyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Apr 2010 23:51:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1271227264-26868-3-git-send-email-juuso.oikarinen@nokia.com>
References: <1271227264-26868-1-git-send-email-juuso.oikarinen@nokia.com>
	<1271227264-26868-3-git-send-email-juuso.oikarinen@nokia.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 14 Apr 2010 16:50:57 +1000
Message-ID: <q2u646765f41004132350zdd258fp1d59016dae8ecda6@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] cfg80211: Remove default dynamic PS timeout value
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org, kalle.valo@iki.fi
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 14, 2010 at 16:41, Juuso Oikarinen
<juuso.oikarinen@nokia.com> wrote:
> Now that the mac80211 is choosing dynamic ps timeouts based on the ps-qos
> network latency configuration, configure a default value of -1 as the dynamic
> ps timeout in cfg80211. This value allows the mac80211 to determine the value
> to be used.
>
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---
>  net/mac80211/mlme.c |    2 +-
>  net/wireless/core.c |    3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 22860bd..6c5c034 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -514,7 +514,7 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
>                if (timeout < 0) {
>                        if (latency <= 50000)
>                                timeout = 300;
> -                       else if (latency <= 2000000)
> +                       else if (latency <= 2000000000)
>                                timeout = 100;
>                        else
>                                timeout = 0;

This doesn't seem to belong with the description.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
