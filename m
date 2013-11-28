Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:47256 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab3K1Ck1 (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Wed, 27 Nov 2013 21:40:27 -0500
Received: by mail-ie0-f179.google.com with SMTP id x13so13271889ief.38
        for <linux-wireless@vger.kernel.org>; Wed, 27 Nov 2013 18:20:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1385392886-6777-1-git-send-email-machen@suse.com>
References: <1385392886-6777-1-git-send-email-machen@suse.com>
Date: Thu, 28 Nov 2013 10:20:01 +0800
Message-ID: <CALx5=V-_eyhoH+CGS42vfBc0hQ__Q7iEecGiiKT-8mMTUY41dA@mail.gmail.com> (sfid-20131128_034030_706282_EF819A9A)
Subject: Re: [PATCH] mac80211: save parsing elem if channel is disabled
From: Matt Chen <machen@suse.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Does this patch make sense to you all ?

2013/11/25 Matt Chen <machen@suse.com>:
> It is possible to save parsing element time
> if we find the channel is disabled.
>
> Acked-by: Matt Chen <machen@suse.com>
> ---
>  net/mac80211/scan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index 5ad66a8..7369557 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -198,13 +198,13 @@ void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
>         if (baselen > skb->len)
>                 return;
>
> -       ieee802_11_parse_elems(elements, skb->len - baselen, false, &elems);
> -
>         channel = ieee80211_get_channel(local->hw.wiphy, rx_status->freq);
>
>         if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
>                 return;
>
> +       ieee802_11_parse_elems(elements, skb->len - baselen, false, &elems);
> +
>         bss = ieee80211_bss_info_update(local, rx_status,
>                                         mgmt, skb->len, &elems,
>                                         channel);
> --
> 1.7.12.4
>
>
