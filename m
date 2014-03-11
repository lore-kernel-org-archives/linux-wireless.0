Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:52730 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaCKJ20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 05:28:26 -0400
Received: by mail-ig0-f172.google.com with SMTP id uq10so10673798igb.5
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2014 02:28:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1393073299-4831-1-git-send-email-nbd@openwrt.org>
References: <1393073299-4831-1-git-send-email-nbd@openwrt.org>
Date: Tue, 11 Mar 2014 10:28:25 +0100
Message-ID: <CAGXE3d_wmuDi2kUjvhLGxSFMAxwcYgjLXJ78fPgyHmDN7m0cSw@mail.gmail.com> (sfid-20140311_102830_485949_377369DC)
Subject: Re: [PATCH 3.14] ath9k: fix ps-poll responses under a-mpdu sessions
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 22, 2014 at 1:48 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> When passing tx frames to the U-APSD queue for powersave poll responses,
> the ath_atx_tid pointer needs to be passed to ath_tx_setup_buffer for
> proper sequence number accounting.
>
> This fixes high latency and connection stability issues with ath9k
> running as AP and a few kinds of mobile phones as client, when PS-Poll
> is heavily used
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---

Hi Felix,

this commit introduced a regression for me when using Intel Win7
clients on a ath9k AP.

I was not able to track the exact issue down yet :( but it seems to be
related to the Intel
client constantly tearing down the BA session and entering/leaving PS mode.

Any idea?

Thanks,
Helmut

>  drivers/net/wireless/ath/ath9k/xmit.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 4f4ce83..f042a18 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -2186,14 +2186,15 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
>                 txq->stopped = true;
>         }
>
> +       if (txctl->an)
> +               tid = ath_get_skb_tid(sc, txctl->an, skb);
> +
>         if (info->flags & IEEE80211_TX_CTL_PS_RESPONSE) {
>                 ath_txq_unlock(sc, txq);
>                 txq = sc->tx.uapsdq;
>                 ath_txq_lock(sc, txq);
>         } else if (txctl->an &&
>                    ieee80211_is_data_present(hdr->frame_control)) {
> -               tid = ath_get_skb_tid(sc, txctl->an, skb);
> -
>                 WARN_ON(tid->ac->txq != txctl->txq);
>
>                 if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
> --
> 1.8.3.4 (Apple Git-47)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
