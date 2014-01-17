Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:60961 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaAQM7T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 07:59:19 -0500
Received: by mail-pa0-f45.google.com with SMTP id lf10so1837102pab.4
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 04:59:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8b96c31da0f8a23b8e99ed790e462bd933925041.1389947627.git.gamerh2o@gmail.com>
References: <CACna6rzkKGxBxReQJ0Y=TscY8GJ+r=S+6Cs+g+B0=7k1FFxW2w@mail.gmail.com>
	<8b96c31da0f8a23b8e99ed790e462bd933925041.1389947627.git.gamerh2o@gmail.com>
Date: Fri, 17 Jan 2014 20:59:18 +0800
Message-ID: <CAAb+SYZ4K1iLLiZG-RjyJeBjUu13QVGH2XgBGyWKE1_U6fQZWw@mail.gmail.com> (sfid-20140117_135921_678554_9EB07168)
Subject: Re: [PATCH v2] b43: use kernel api to replace b43 specific helper function
From: ZHAO Gang <gamerh2o@gmail.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Luca Coelho <luca@coelho.fi>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 17, 2014 at 5:11 PM, ZHAO Gang <gamerh2o@gmail.com> wrote:
> The b43_freq_to_channel_{2,5}ghz() should be changed to
> b43_channel_to_freq{2,5}ghz() if we want to use b43 helper function,
> but a better way is to use kernel api ieee80211_channel_to_frequency()
> and remove these unnecessary helper function.
>
> Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
> ---
> v2: combine two patches to one.
>     suggested by Luca Coelho and Rafał Miłecki
>

The version 2 patch should be ignored. After more discussion, it seems it's
good to let the fix be two patches.

>  drivers/net/wireless/b43/main.h | 35 -----------------------------------
>  drivers/net/wireless/b43/xmit.c | 12 ++++++------
>  2 files changed, 6 insertions(+), 41 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/main.h b/drivers/net/wireless/b43/main.h
> index abac25e..f476fc3 100644
> --- a/drivers/net/wireless/b43/main.h
> +++ b/drivers/net/wireless/b43/main.h
> @@ -58,41 +58,6 @@ enum b43_verbosity {
>  #endif
>  };
>
> -
> -/* Lightweight function to convert a frequency (in Mhz) to a channel number. */
> -static inline u8 b43_freq_to_channel_5ghz(int freq)
> -{
> -       return ((freq - 5000) / 5);
> -}
> -static inline u8 b43_freq_to_channel_2ghz(int freq)
> -{
> -       u8 channel;
> -
> -       if (freq == 2484)
> -               channel = 14;
> -       else
> -               channel = (freq - 2407) / 5;
> -
> -       return channel;
> -}
> -
> -/* Lightweight function to convert a channel number to a frequency (in Mhz). */
> -static inline int b43_channel_to_freq_5ghz(u8 channel)
> -{
> -       return (5000 + (5 * channel));
> -}
> -static inline int b43_channel_to_freq_2ghz(u8 channel)
> -{
> -       int freq;
> -
> -       if (channel == 14)
> -               freq = 2484;
> -       else
> -               freq = 2407 + (5 * channel);
> -
> -       return freq;
> -}
> -
>  static inline int b43_is_cck_rate(int rate)
>  {
>         return (rate == B43_CCK_RATE_1MB ||
> diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
> index 4ae63f4..218a0f3 100644
> --- a/drivers/net/wireless/b43/xmit.c
> +++ b/drivers/net/wireless/b43/xmit.c
> @@ -806,7 +806,8 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
>                 B43_WARN_ON(1);
>                 /* FIXME: We don't really know which value the "chanid" contains.
>                  *        So the following assignment might be wrong. */
> -               status.freq = b43_channel_to_freq_5ghz(chanid);
> +               status.freq =
> +                       ieee80211_channel_to_frequency(chanid, status.band);
>                 break;
>         case B43_PHYTYPE_G:
>                 status.band = IEEE80211_BAND_2GHZ;
> @@ -819,13 +820,12 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
>         case B43_PHYTYPE_HT:
>                 /* chanid is the SHM channel cookie. Which is the plain
>                  * channel number in b43. */
> -               if (chanstat & B43_RX_CHAN_5GHZ) {
> +               if (chanstat & B43_RX_CHAN_5GHZ)
>                         status.band = IEEE80211_BAND_5GHZ;
> -                       status.freq = b43_freq_to_channel_5ghz(chanid);
> -               } else {
> +               else
>                         status.band = IEEE80211_BAND_2GHZ;
> -                       status.freq = b43_freq_to_channel_2ghz(chanid);
> -               }
> +               status.freq =
> +                       ieee80211_channel_to_frequency(chanid, status.band);
>                 break;
>         default:
>                 B43_WARN_ON(1);
> --
> 1.8.4.2
>
