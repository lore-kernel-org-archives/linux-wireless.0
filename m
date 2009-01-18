Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f29.google.com ([209.85.218.29]:64177 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbZARUOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 15:14:41 -0500
Received: by bwz10 with SMTP id 10so1777443bwz.13
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2009 12:14:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200901182015.24298.IvDoorn@gmail.com>
References: <200901182015.24298.IvDoorn@gmail.com>
Date: Sun, 18 Jan 2009 20:14:38 +0000
Message-ID: <c6b1100b0901181214w255355b5i9d4f098a9f96fad1@mail.gmail.com> (sfid-20090118_211446_215912_63342EB0)
Subject: Re: [PATCH] Fix TX rate short preamble detection
From: Chris Clayton <chris2553@googlemail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ivo/John,

2009/1/18 Ivo van Doorn <ivdoorn@gmail.com>:
> Mac80211 provides 2 structures to handle bitrates, namely
> ieee80211_rate and ieee80211_tx_rate. To determine the short preamble
> mode for an outgoing frame, the flag IEEE80211_TX_RC_USE_SHORT_PREAMBLE
> must be checked on ieee80211_tx_rate and not ieee80211_rate (which rt2x00 did).
>
> This fixes a regression which was triggered in 2.6.29-rcX as reported by Chris Clayton.
>

I don't think the patch below will apply to 2.6.29-rc because it is
lagging behind wireless testing and, I would guess, is likely to stay
that way for 2.6.29 because the merge window is closed. Won't the
final patch that was provided to me at
http://marc.info/?l=linux-wireless&m=123229784930740&w=4 be the
correct one? If so, could John please add:

Tested-By: Chris Clayton <chris2553@googlemail.com>

Cheers,

Chris

> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
>
> ---
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> index c1e5a05..3dab9b4 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -186,10 +186,11 @@ static void rt2x00queue_create_tx_descriptor_seq(struct queue_entry *entry,
>
>  static void rt2x00queue_create_tx_descriptor_plcp(struct queue_entry *entry,
>                                                  struct txentry_desc *txdesc,
> -                                                 struct ieee80211_rate *rate)
> +                                                 const struct rt2x00_rate *hwrate)
>  {
>        struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
> -       const struct rt2x00_rate *hwrate = rt2x00_get_rate(rate->hw_value);
> +       struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
> +       struct ieee80211_tx_rate *txrate = &tx_info->control.rates[0];
>        unsigned int data_length;
>        unsigned int duration;
>        unsigned int residual;
> @@ -232,7 +233,7 @@ static void rt2x00queue_create_tx_descriptor_plcp(struct queue_entry *entry,
>                 * When preamble is enabled we should set the
>                 * preamble bit for the signal.
>                 */
> -               if (rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
> +               if (txrate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
>                        txdesc->signal |= 0x08;
>        }
>  }
> @@ -326,7 +327,7 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
>         */
>        rt2x00crypto_create_tx_descriptor(entry, txdesc);
>        rt2x00queue_create_tx_descriptor_seq(entry, txdesc);
> -       rt2x00queue_create_tx_descriptor_plcp(entry, txdesc, rate);
> +       rt2x00queue_create_tx_descriptor_plcp(entry, txdesc, hwrate);
>  }
>
>  static void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
>



-- 
In a world without walls and fences, who needs windows and gates?
