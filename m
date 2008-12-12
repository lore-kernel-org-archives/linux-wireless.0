Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:46315 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030AbYLLOr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 09:47:58 -0500
Received: by wa-out-1112.google.com with SMTP id v27so710518wah.21
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2008 06:47:57 -0800 (PST)
Message-ID: <69e28c910812120647l69b317daxfdbeb914d61ba7e3@mail.gmail.com> (sfid-20081212_154802_992856_FD5165B8)
Date: Fri, 12 Dec 2008 15:47:57 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Jouni Malinen" <jouni.malinen@atheros.com>
Subject: Re: [PATCH 3/3] mac80211: Add HT rates into radiotap
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Thomas d'Otreppe" <tdotreppe@aircrack-ng.org>
In-Reply-To: <20081212123918.723191687@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081212123832.506588839@atheros.com>
	 <20081212123918.723191687@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 12, 2008 at 1:38 PM, Jouni Malinen
<jouni.malinen@atheros.com> wrote:
> Update the radiotap definition based on the format used in FreeBSD to
> allows MCS index, HT20/HT40, and short GI information to be reported
> for received frames in monitor mode. This format is also supported by
> wireshark.
>
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
> ---
>  include/net/ieee80211_radiotap.h |    7 +++++--
>  net/mac80211/rx.c                |   28 ++++++++++++----------------
>  2 files changed, 17 insertions(+), 18 deletions(-)
>
> --- wireless-testing.orig/include/net/ieee80211_radiotap.h      2008-12-04 12:56:59.000000000 +0200
> +++ wireless-testing/include/net/ieee80211_radiotap.h   2008-12-12 14:10:02.000000000 +0200
> @@ -100,9 +100,10 @@ struct ieee80211_radiotap_header {
>  *      For frequency-hopping radios, the hop set (first byte)
>  *      and pattern (second byte).
>  *
> - * IEEE80211_RADIOTAP_RATE              u8           500kb/s
> + * IEEE80211_RADIOTAP_RATE              u8           500kb/s or index
>  *
> - *      Tx/Rx data rate
> + *      Tx/Rx data rate.  If bit 0x80 is set then it represents an
> + *      an MCS index and not an IEEE rate.
>  *
>  * IEEE80211_RADIOTAP_DBM_ANTSIGNAL     s8           decibels from
>  *                                                   one milliwatt (dBm)
> @@ -230,6 +231,8 @@ enum ieee80211_radiotap_type {
>                                                 * 802.11 header and payload
>                                                 * (to 32-bit boundary)
>                                                 */
> +#define        IEEE80211_RADIOTAP_F_SHORTGI    0x80    /* HT short GI */
> +
>  /* For IEEE80211_RADIOTAP_RX_FLAGS */
>  #define IEEE80211_RADIOTAP_F_RX_BADFCS 0x0001  /* frame failed crc check */
>
> --- wireless-testing.orig/net/mac80211/rx.c     2008-12-12 14:09:52.000000000 +0200
> +++ wireless-testing/net/mac80211/rx.c  2008-12-12 14:10:02.000000000 +0200
> @@ -116,6 +116,7 @@ ieee80211_add_rx_radiotap_header(struct
>  {
>        struct ieee80211_radiotap_header *rthdr;
>        unsigned char *pos;
> +       u16 chan_flags;
>
>        rthdr = (struct ieee80211_radiotap_header *)skb_push(skb, rtap_len);
>        memset(rthdr, 0, rtap_len);
> @@ -146,19 +147,14 @@ ieee80211_add_rx_radiotap_header(struct
>                *pos |= IEEE80211_RADIOTAP_F_FCS;
>        if (status->flag & RX_FLAG_SHORTPRE)
>                *pos |= IEEE80211_RADIOTAP_F_SHORTPRE;
> +       if (status->flag & RX_FLAG_SHORT_GI)
> +               *pos |= IEEE80211_RADIOTAP_F_SHORTGI;
>        pos++;
>
>        /* IEEE80211_RADIOTAP_RATE */
> -       if (status->flag & RX_FLAG_HT) {
> -               /*
> -                * TODO: add following information into radiotap header once
> -                * suitable fields are defined for it:
> -                * - MCS index (status->rate_idx)
> -                * - HT40 (status->flag & RX_FLAG_40MHZ)
> -                * - short-GI (status->flag & RX_FLAG_SHORT_GI)
> -                */
> -               *pos = 0;
> -       } else
> +       if (status->flag & RX_FLAG_HT)
> +               *pos = 0x80 | status->rate_idx;
> +       else
>                *pos = rate->bitrate / 5;
>        pos++;
>
> @@ -166,14 +162,14 @@ ieee80211_add_rx_radiotap_header(struct
>        *(__le16 *)pos = cpu_to_le16(status->freq);
>        pos += 2;
>        if (status->band == IEEE80211_BAND_5GHZ)
> -               *(__le16 *)pos = cpu_to_le16(IEEE80211_CHAN_OFDM |
> -                                            IEEE80211_CHAN_5GHZ);
> +               chan_flags = IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ;
>        else if (rate->flags & IEEE80211_RATE_ERP_G)
> -               *(__le16 *)pos = cpu_to_le16(IEEE80211_CHAN_OFDM |
> -                                            IEEE80211_CHAN_2GHZ);
> +               chan_flags = IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ;
>        else
> -               *(__le16 *)pos = cpu_to_le16(IEEE80211_CHAN_CCK |
> -                                            IEEE80211_CHAN_2GHZ);
> +               chan_flags = IEEE80211_CHAN_CCK | IEEE80211_CHAN_2GHZ;
> +       if (status->flag & RX_FLAG_40MHZ)
> +               chan_flags |= IEEE80211_CHAN_TURBO;
> +       *(__le16 *) pos = cpu_to_le16(chan_flags);
>        pos += 2;
>
>        /* IEEE80211_RADIOTAP_DBM_ANTSIGNAL */
>
> --
>
> --
> Jouni Malinen                                            PGP id EFC895FA
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thanks for the heads up, mail forwarded to Thomas d'Otreppe, as this
will need changes in airodump-ng.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
