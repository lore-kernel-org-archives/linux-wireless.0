Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:41584 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3GMQ2D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jul 2013 12:28:03 -0400
Received: by mail-qc0-f170.google.com with SMTP id s1so5550235qcw.29
        for <linux-wireless@vger.kernel.org>; Sat, 13 Jul 2013 09:28:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1373575017-25645-1-git-send-email-johannes@sipsolutions.net>
References: <1373575017-25645-1-git-send-email-johannes@sipsolutions.net>
Date: Sat, 13 Jul 2013 12:28:02 -0400
Message-ID: <CAKf6xpu7iUSKWsFwsUnV2Nv2XjWepzaXv6s=3WvcgB6dY20oGQ@mail.gmail.com> (sfid-20130713_182810_245599_FB79BAD2)
Subject: Re: [PATCH] mac80211: fix duplicate retransmission detection
From: Jason Andryuk <jandryuk@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 11, 2013 at 4:36 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 23dbcfc..2c5a79b 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -936,8 +936,14 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
>         struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
>         struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
>
> -       /* Drop duplicate 802.11 retransmissions (IEEE 802.11 Chap. 9.2.9) */
> -       if (rx->sta && !is_multicast_ether_addr(hdr->addr1)) {
> +       /*
> +        * Drop duplicate 802.11 retransmissions
> +        * (IEEE 802.11-2012: 9.3.2.10 "Duplicate detection and recovery")
> +        */
> +       if (rx->skb->len >= 24 && rx->sta &&

Shouldn't this check rx->skb first?
if (rx->sta && rx->sta->len >= 24 &&

-Jason

> +           !ieee80211_is_ctl(hdr->frame_control) &&
> +           !ieee80211_is_qos_nullfunc(hdr->frame_control) &&
> +           !is_multicast_ether_addr(hdr->addr1)) {
>                 if (unlikely(ieee80211_has_retry(hdr->frame_control) &&
>                              rx->sta->last_seq_ctrl[rx->seqno_idx] ==
>                              hdr->seq_ctrl)) {
> --
> 1.8.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
