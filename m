Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:61517 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab0BOAKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 19:10:33 -0500
Received: by fxm27 with SMTP id 27so96996fxm.25
        for <linux-wireless@vger.kernel.org>; Sun, 14 Feb 2010 16:10:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266190653-2453-1-git-send-email-benoit.papillault@free.fr>
References: <1266190653-2453-1-git-send-email-benoit.papillault@free.fr>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 15 Feb 2010 01:10:11 +0100
Message-ID: <69e28c911002141610q737465b4s1d825d6dcd3aea26@mail.gmail.com>
Subject: Re: [PATCH 1/2] mac80211: Drop protected data frames that have not
	been decrypted
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 15, 2010 at 12:37 AM, Benoit Papillault
<benoit.papillault@free.fr> wrote:
> Fix for the following issue : a STA connected to a WPA2 AP was showing
> frames from others STA in tcpdump on wlan0 (promiscuous mode). In fact,
> those frames are not decrypted and appears as 802.3 junk. This patch
> just drops any protected data frames that have not been decrypted.
>
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
> ---
>  net/mac80211/rx.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index c9755f3..22ae6ee 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1397,6 +1397,14 @@ ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx, __le16 fc)
>                     ieee80211_is_data(fc) &&
>                     (rx->key || rx->sdata->drop_unencrypted)))
>                return -EACCES;
> +       /*
> +        * Drop encrypted frames that have not been decrypted. This
> +        * happens for frames that are sent by an AP to another STA
> +        */
> +       if (ieee80211_has_protected(fc) &&
> +           !(status->flag & RX_FLAG_DECRYPTED)) {
> +               return -EACCES;
> +       }
>        if (rx->sta && test_sta_flags(rx->sta, WLAN_STA_MFP)) {
>                if (unlikely(ieee80211_is_unicast_robust_mgmt_frame(rx->skb) &&
>                             rx->key))
> --
> 1.5.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I'm not familiar with this part of the code; but have you tested if
this doesn't break monitor-while-operating mode (i.e. doesn't remove
other-STA frames from monitor interfaces)?

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
