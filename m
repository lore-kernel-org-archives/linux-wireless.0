Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55013 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2LEURh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 15:17:37 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm9so2434259wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 12:17:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354684410-31170-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1354684410-31170-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 5 Dec 2012 12:17:15 -0800
Message-ID: <CAG6hwVM4xNVr4ewDKcus1ZG-KO-TZLhM7qt3JR+LgGxEzVxVZQ@mail.gmail.com> (sfid-20121205_211741_299476_8E664AF7)
Subject: Re: [RFC] mac80211: dont drop mesh Peering Open frames from unknown STA
To: devel@lists.open80211s.org
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 4, 2012 at 9:13 PM, Marco Porsch
<marco.porsch@etit.tu-chemnitz.de> wrote:
> These are valid mesh peering frames. The STA entry will then be created in
> mesh_peer_init.
> The problem was previously worked around, since both STA receive the beacons
> of one another, which create the STA entry. This may not be the case when
> either node is in PS mode.

Nice, this bug has been there for quite some time then. Please clean
up the commit message before resubmitting as a patch.

> Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
> ---
>  net/mac80211/rx.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 8d267ec..89bfbbb 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -2319,7 +2319,8 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
>         if (len < IEEE80211_MIN_ACTION_SIZE)
>                 return RX_DROP_UNUSABLE;
>
> -       if (!rx->sta && mgmt->u.action.category != WLAN_CATEGORY_PUBLIC)
> +       if (!rx->sta && mgmt->u.action.category != WLAN_CATEGORY_PUBLIC &&
> +           mgmt->u.action.category != WLAN_CATEGORY_SELF_PROTECTED)
>                 return RX_DROP_UNUSABLE;
>
>         if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
> --
> 1.7.9.5
>
> _______________________________________________
> Devel mailing list
> Devel@lists.open80211s.org
> http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel
