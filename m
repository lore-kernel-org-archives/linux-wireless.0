Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42323 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab0ECWRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 18:17:18 -0400
Received: by pwj9 with SMTP id 9so1466948pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 15:17:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1272734031.8461.0.camel@jlt3.sipsolutions.net>
References: <1272734031.8461.0.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 3 May 2010 15:16:56 -0700
Message-ID: <o2k43e72e891005031516g31c22cdbt3ee5d766e63b3f2c@mail.gmail.com>
Subject: Re: [RFC] mac80211: radiotap vendor data
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Joshua Zhao <Joshua.Zhao@atheros.com>,
	Matt Smith <Matt.Smith@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 1, 2010 at 10:13 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> This allows drivers to add radiotap vendor data
> to any received frame, which will be simply
> passed into userspace and ignored by the kernel.
> Can be used by drivers to convey hw-specific
> information.

Thanks a lot for all your work on this area, on the standardization
part, mac80211 and even for providing a simple example, its really
appreciated! Some comments below.

> Note: 11n shouldn't be done there, in case somebody
> got ideas!!

Well you mean 802.11n standard stuff, I take it, because there are
vendor 802.11n specific stuff.

> Note: didn't test this after the paged RX changes
> ---
>  drivers/net/wireless/mac80211_hwsim.c |   17 ++++++++++
>  include/net/mac80211.h                |   12 +++++++
>  net/mac80211/rx.c                     |   53 ++++++++++++++++++++++++++++++----
>  3 files changed, 77 insertions(+), 5 deletions(-)
>
> --- wireless-testing.orig/include/net/mac80211.h        2010-05-01 08:46:26.000000000 +0200
> +++ wireless-testing/include/net/mac80211.h     2010-05-01 08:47:54.000000000 +0200
> @@ -565,6 +565,13 @@ enum mac80211_rx_flags {
>  * @rate_idx: index of data rate into band's supported rates or MCS index if
>  *     HT rates are use (RX_FLAG_HT)
>  * @flag: %RX_FLAG_*
> + * @vendor_radiotap_bitmap: radiotap vendor namespace presence bitmap
> + * @vendor_radiotap_len: radiotap vendor namespace length
> + * @vendor_radiotap_align: radiotap vendor namespace alignment. Note
> + *     that the actual data must be at the start of the SKB data
> + *     already.

I see your WARN_ON() on the alignment being set to 0 and set it to 1
then. Can you clarify a little more on this here. If there is no
strict alignment requirements why not just treat 0 as 1 then?

> + * @vendor_radiotap_oui: radiotap vendor namespace OUI
> + * @vendor_radiotap_subns: radiotap vendor sub namespace
>  */
>  struct ieee80211_rx_status {
>        u64 mactime;
> @@ -575,6 +582,11 @@ struct ieee80211_rx_status {
>        int antenna;
>        int rate_idx;
>        int flag;
> +       u32 vendor_radiotap_bitmap;
> +       u16 vendor_radiotap_len;
> +       u8 vendor_radiotap_align;
> +       u8 vendor_radiotap_oui[3];
> +       u8 vendor_radiotap_subns;
>  };
>
>  /**
> --- wireless-testing.orig/net/mac80211/rx.c     2010-05-01 08:46:26.000000000 +0200
> +++ wireless-testing/net/mac80211/rx.c  2010-05-01 08:47:54.000000000 +0200
> @@ -37,6 +37,8 @@
>  static struct sk_buff *remove_monitor_info(struct ieee80211_local *local,
>                                           struct sk_buff *skb)
>  {
> +       struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
> +
>        if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS) {
>                if (likely(skb->len > FCS_LEN))
>                        __pskb_trim(skb, skb->len - FCS_LEN);
> @@ -48,6 +50,9 @@ static struct sk_buff *remove_monitor_in
>                }
>        }
>
> +       if (status->vendor_radiotap_len)
> +               __pskb_pull(skb, status->vendor_radiotap_len);
> +
>        return skb;
>  }
>
> @@ -69,8 +74,8 @@ static inline int should_drop_frame(stru
>  }
>
>  static int
> -ieee80211_rx_radiotap_len(struct ieee80211_local *local,
> -                         struct ieee80211_rx_status *status)
> +ieee80211_rx_radiotap_space(struct ieee80211_local *local,
> +                           struct ieee80211_rx_status *status)
>  {
>        int len;
>
> @@ -87,6 +92,21 @@ ieee80211_rx_radiotap_len(struct ieee802
>        if (len & 1) /* padding for RX_FLAGS if necessary */
>                len++;
>
> +       if (status->vendor_radiotap_len) {
> +               /* allocate extra bitmap */
> +               len += 4;
> +
> +               if (WARN_ON(status->vendor_radiotap_align == 0))
> +                       status->vendor_radiotap_align = 1;
> +               /* align standard part of vendor namespace */
> +               len = ALIGN(len, 2);
> +               /* allocate standard part of vendor namespace */
> +               len += 6;
> +               /* align vendor-defined part */
> +               len = ALIGN(len, status->vendor_radiotap_align);
> +               /* vendor-defined part is already in skb */
> +       }
> +
>        return len;
>  }
>
> @@ -115,10 +135,18 @@ ieee80211_add_rx_radiotap_header(struct
>                            (1 << IEEE80211_RADIOTAP_CHANNEL) |
>                            (1 << IEEE80211_RADIOTAP_ANTENNA) |
>                            (1 << IEEE80211_RADIOTAP_RX_FLAGS));
> -       rthdr->it_len = cpu_to_le16(rtap_len);
> +       rthdr->it_len = cpu_to_le16(rtap_len + status->vendor_radiotap_len);
>
>        pos = (unsigned char *)(rthdr+1);
>
> +       if (status->vendor_radiotap_len) {
> +               rthdr->it_present |=
> +                       cpu_to_le32(BIT(IEEE80211_RADIOTAP_VENDOR_NAMESPACE)) |
> +                       cpu_to_le32(BIT(IEEE80211_RADIOTAP_EXT));
> +               put_unaligned_le32(status->vendor_radiotap_bitmap, pos);
> +               pos += 4;
> +       }
> +
>        /* the order of the following fields is important */
>
>        /* IEEE80211_RADIOTAP_TSFT */
> @@ -190,11 +218,26 @@ ieee80211_add_rx_radiotap_header(struct
>        /* IEEE80211_RADIOTAP_RX_FLAGS */
>        /* ensure 2 byte alignment for the 2 byte field as required */
>        if ((pos - (u8 *)rthdr) & 1)
> -               pos++;
> +               *pos++ = 0;

Why is this needed though? We already memset(rthdr, 0, rtap_len); above.

>        if (status->flag & RX_FLAG_FAILED_PLCP_CRC)
>                rx_flags |= IEEE80211_RADIOTAP_F_RX_BADPLCP;
>        put_unaligned_le16(rx_flags, pos);
>        pos += 2;
> +
> +       if (status->vendor_radiotap_len) {
> +               /* ensure 2 byte alignment for the vendor field as required */
> +               if ((pos - (u8 *)rthdr) & 1)
> +                       *pos++ = 0;
> +               *pos++ = status->vendor_radiotap_oui[0];
> +               *pos++ = status->vendor_radiotap_oui[1];
> +               *pos++ = status->vendor_radiotap_oui[2];
> +               *pos++ = status->vendor_radiotap_subns;
> +               put_unaligned_le16(status->vendor_radiotap_len, pos);
> +               pos += 2;
> +               /* align the actual payload as requested */
> +               while ((pos - (u8 *)rthdr) & (status->vendor_radiotap_align - 1))
> +                       *pos++ = 0;
> +       }
>  }
>
>  /*
> @@ -223,7 +266,7 @@ ieee80211_rx_monitor(struct ieee80211_lo
>         */
>
>        /* room for the radiotap header based on driver features */
> -       needed_headroom = ieee80211_rx_radiotap_len(local, status);
> +       needed_headroom = ieee80211_rx_radiotap_space(local, status);
>
>        if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
>                present_fcs_len = FCS_LEN;
> --- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c 2010-05-01 08:46:27.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c      2010-05-01 19:04:57.000000000 +0200
> @@ -484,6 +484,7 @@ static bool mac80211_hwsim_tx_frame(stru
>        struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
>        struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>        struct ieee80211_rx_status rx_status;
> +       u8 *vendor_data;
>
>        if (data->idle) {
>                printk(KERN_DEBUG "%s: Trying to TX when idle - reject\n",
> @@ -509,6 +510,20 @@ static bool mac80211_hwsim_tx_frame(stru
>        secpath_reset(skb);
>        nf_reset(skb);
>
> +       vendor_data = skb_push(skb, 4);
> +       rx_status.vendor_radiotap_len = 4;
> +       rx_status.vendor_radiotap_align = 4;
> +       rx_status.vendor_radiotap_oui[0] = 0xff;
> +       rx_status.vendor_radiotap_oui[1] = 0xff;
> +       rx_status.vendor_radiotap_oui[2] = 0xff;
> +       rx_status.vendor_radiotap_subns = 129;
> +       rx_status.vendor_radiotap_bitmap = 0x1;
> +
> +       *vendor_data++ = 1;
> +       *vendor_data++ = 2;
> +       *vendor_data++ = 3;
> +       *vendor_data++ = 4;
> +

Heh nice, now we just need a sample radiotap vendor extension parser example.

Thanks!!!

  Luis
