Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:32930 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbcKNJmS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 04:42:18 -0500
Received: by mail-it0-f67.google.com with SMTP id c20so10379510itb.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 01:42:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161114084536.GB12372@redhat.com>
References: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
 <1478095865-8651-6-git-send-email-sgruszka@redhat.com> <ebc4779b-a68b-f3b3-c8fc-87db9401a603@kresin.me>
 <20161114084536.GB12372@redhat.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 14 Nov 2016 20:41:57 +1100
Message-ID: <CAGRGNgU=3tRrdgzoiGjoGr6QguyYnQ2kadiaX+HWxm0jiKqaqw@mail.gmail.com> (sfid-20161114_104351_243930_FDF2C838)
Subject: Re: [PATCH 05/10] rt2800: make ba_size depend on ampdu_factor
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Mathias Kresin <dev@kresin.me>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stainslaw,

On Mon, Nov 14, 2016 at 7:45 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Sat, Nov 05, 2016 at 01:56:58PM +0100, Mathias Kresin wrote:
>> 02.11.2016 15:11, Stanislaw Gruszka:
>> >
>> >-            sta_priv = sta_to_rt2x00_sta(sta);
>> >+            txdesc->u.ht.mpdu_density = sta->ht_cap.ampdu_density;
>> >             txdesc->u.ht.wcid = sta_priv->wcid;
>> >+
>> >+            if (!(tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)) {
>> >+                    ba_size = IEEE80211_MIN_AMPDU_BUF;
>> >+                    ba_size <<= sta->ht_cap.ampdu_factor;
>> >+                    ba_size = min_t(int, 63, ba_size - 1);
>> >+            }
>> >     }
>> >
>> >     /*
>> >@@ -345,7 +350,7 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
>> >             return;
>> >     }
>> >
>> >-    txdesc->u.ht.ba_size = 7;       /* FIXME: What value is needed? */
>> >+    txdesc->u.ht.ba_size = ba_size;
>> >
>> >     /*
>> >      * Only one STBC stream is supported for now.
>> >
>>
>> Having this patch applied, the throughput on a vgv7510kw22 (RT3062F)
>> in AP mode using LEDE head is decreased by somewhat around 10
>> Mbits/sec. I'm using iperf3 for throughput tests and having this
>> patch reverted the throughout is back to 80 Mbits/sec.
>>
>> When bringing down the wifi interface the following messages are
>> logged with the patch applied:
>>
>> [  281.738373] ieee80211 phy0: rt2x00queue_flush_queue: Warning -
>> Queue 2 failed to flush
>> [  281.906380] ieee80211 phy0: rt2x00queue_flush_queue: Warning -
>> Queue 2 failed to flush
>
> Could you check below patch and see if it helps? If it does not,
> could you printk sta->ht_cap.ampdu_density and ba_size values
> and provide them here.
>
> Thanks
> Stanislaw
>
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index 2515702..72c7948 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -4707,7 +4707,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>             rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070E))
>                 rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 2);
>         else
> -               rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 1);
> +               rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 3;

You're missing a closing parenthesis, so it isn't going to work unless
it's added back in.

>         rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_PSDU, 0);
>         rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_MPDU, 0);
>         rt2800_register_write(rt2x00dev, MAX_LEN_CFG, reg);

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
