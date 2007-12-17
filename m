Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hu-out-0506.google.com ([72.14.214.231]:35371 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470AbXLQPBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 10:01:00 -0500
Received: by hu-out-0506.google.com with SMTP id 19so765702hue.21
        for <linux-wireless@vger.kernel.org>; Mon, 17 Dec 2007 07:00:58 -0800 (PST)
Message-ID: <c85cb4470712170700q3ce34320wcc00e15a23abebab@mail.gmail.com> (sfid-20071217_150105_439379_3A8D5359)
Date: Mon, 17 Dec 2007 17:00:56 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	flamingice@sourmilk.net, tomas.winkler@intel.com
Subject: Re: [PATCH 1/1] mac80211: pass in PS_POLL frames
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1197278205280-git-send-email-ron.rindjunsky@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1197278205280-git-send-email-ron.rindjunsky@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks, this patch is a V2 with fixes, and i haven't received any
new comments nor Ack for it. I have another patch that depends on this
one so i need to know the status for it.
thanks
ron

> This patch fixes should_drop_frame function to pass in ps poll control
> frames required for power save functioanlity. Interface types that do not
> have interest for PS POLL frames now drop it in handler.
>
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> ---
>  net/mac80211/rx.c   |   10 ++++++++--
>  net/mac80211/util.c |    7 ++++++-
>  2 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 50f99e7..5dbf5d6 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -61,8 +61,10 @@ static inline int should_drop_frame(struct ieee80211_rx_status *status,
>                return 1;
>        if (unlikely(skb->len < 16 + present_fcs_len + radiotap_len))
>                return 1;
> -       if ((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
> -                       cpu_to_le16(IEEE80211_FTYPE_CTL))
> +       if (((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
> +                       cpu_to_le16(IEEE80211_FTYPE_CTL)) &&
> +           ((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_STYPE)) !=
> +                       cpu_to_le16(IEEE80211_STYPE_PSPOLL)))
>                return 1;
>        return 0;
>  }
> @@ -880,6 +882,7 @@ ieee80211_rx_h_defragment(struct ieee80211_txrx_data *rx)
>  static ieee80211_txrx_result
>  ieee80211_rx_h_ps_poll(struct ieee80211_txrx_data *rx)
>  {
> +       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
>        struct sk_buff *skb;
>        int no_pending_pkts;
>        DECLARE_MAC_BUF(mac);
> @@ -890,6 +893,9 @@ ieee80211_rx_h_ps_poll(struct ieee80211_txrx_data *rx)
>                   !(rx->flags & IEEE80211_TXRXD_RXRA_MATCH)))
>                return TXRX_CONTINUE;
>
> +       if (sdata->type == IEEE80211_IF_TYPE_STA)
> +               return TXRX_DROP;
> +
>        skb = skb_dequeue(&rx->sta->tx_filtered);
>        if (!skb) {
>                skb = skb_dequeue(&rx->sta->ps_tx_buf);
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 7b278e9..fb7fd89 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -135,13 +135,16 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len)
>  {
>        u16 fc;
>
> -       if (len < 24)
> +        /* drop ACK/CTS frames and incorrect hdr len (ctrl) */
> +       if (len < 16)
>                return NULL;
>
>        fc = le16_to_cpu(hdr->frame_control);
>
>        switch (fc & IEEE80211_FCTL_FTYPE) {
>        case IEEE80211_FTYPE_DATA:
> +               if (len < 24) /* drop incorrect hdr len (data) */
> +                       return NULL;
>                switch (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
>                case IEEE80211_FCTL_TODS:
>                        return hdr->addr1;
> @@ -154,6 +157,8 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len)
>                }
>                break;
>        case IEEE80211_FTYPE_MGMT:
> +               if (len < 24) /* drop incorrect hdr len (mgmt) */
> +                       return NULL;
>                return hdr->addr3;
>        case IEEE80211_FTYPE_CTL:
>                if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)
