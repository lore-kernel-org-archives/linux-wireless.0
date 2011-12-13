Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59460 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab1LMLcO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 06:32:14 -0500
Received: by bkcjm19 with SMTP id jm19so2656227bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Dec 2011 03:32:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323775643-6018-1-git-send-email-eliad@wizery.com>
References: <1323775643-6018-1-git-send-email-eliad@wizery.com>
From: Arik Nemtsov <anamtsov@gmail.com>
Date: Tue, 13 Dec 2011 13:31:56 +0200
Message-ID: <CA+XVXfexsY4gyPFc0y7Uw2YVg4RR9uitprpSak2wkzCj5uN3Hw@mail.gmail.com> (sfid-20111213_123230_026172_23075CCC)
Subject: Re: [PATCH] wl12xx: use ieee80211_free_txskb()
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 13, 2011 at 13:27, Eliad Peller <eliad@wizery.com> wrote:
> Use the newly introduced ieee80211_free_txskb() instead
> of dev_kfree_skb() for failed tx packets.
>
> Reported-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  drivers/net/wireless/wl12xx/main.c |    2 +-
>  drivers/net/wireless/wl12xx/tx.c   |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 2f7bfa8..333bc29 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
[..]
>
> diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
> index 36eb0d6..fe62f21 100644
> --- a/drivers/net/wireless/wl12xx/tx.c
> +++ b/drivers/net/wireless/wl12xx/tx.c
> @@ -740,7 +740,7 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
>                        set_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags);
>                        goto out_ack;
>                } else if (ret < 0) {
> -                       dev_kfree_skb(skb);
> +                       ieee80211_free_txskb(wl->hw, skb);

Technically, the skb can be a dummy packet here. In this case we
shouldn't do anything. This was a bug before, but it's even more of a
bug now.

Arik
