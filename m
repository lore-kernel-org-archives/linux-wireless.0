Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:2768 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbZFHSLT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 14:11:19 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1363793wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2009 11:11:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200906081720.59594.mb@bu3sch.de>
References: <83a869cd0906071450h24ed4119s44d00db0d97d59e2@mail.gmail.com>
	 <200906081720.59594.mb@bu3sch.de>
Date: Mon, 8 Jun 2009 20:04:33 +0200
Message-ID: <83a869cd0906081104m2ecdf049rdcc7694f0974ca28@mail.gmail.com>
Subject: Re: [PATCH] b43 add harware tkip
From: gregor kowski <gregor.kowski@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

thanks for your review

On Mon, Jun 8, 2009 at 5:20 PM, Michael Buesch<mb@bu3sch.de> wrote:
> Well, first thing is that I do think there is a reason Broadcom removed hw TKIP
> support from their drivers. ;)
>
> But well, let's look at the patch.
>
>> +     /* FIXME this is the wrong offset : it goes in tkip rx phase1 shm */
>> +#if 0
>>       b43_write_probe_resp_plcp(dev, 0x31A, size, &b43_b_ratetable[0]);
>>       b43_write_probe_resp_plcp(dev, 0x32C, size, &b43_b_ratetable[1]);
>>       b43_write_probe_resp_plcp(dev, 0x33E, size, &b43_b_ratetable[2]);
>>       b43_write_probe_resp_plcp(dev, 0x350, size, &b43_b_ratetable[3]);
>> +#endif
>
> This looks interesting. Care to find out the correct offsets and submit
> this fix as a separate patch?
>
May be if I have time. But a comment suggest it is not used ?
>> +     if (algorithm == B43_SEC_ALGO_TKIP) {
>> +             /*
>> +              * We should provide an initial iv32, phase1key pair.
>> +              * We could start with iv32=0 and compute the corresponding
>> +              * phase1key, but this mean calling ieee80211_get_tkip_key
>> +              * with a fake skb (or export other tkip function).
>> +              * Because we are lazy we hope iv32 won't start with
>> +              * 0xffff and let's b43_mac_update_tkip_key provide a
>> +              * correct pair.
>> +              */
>> +             rx_tkip_phase1_write(dev, index, 0xffff, (u16*)buf);
>> +     } else /* clear it */
>> +             rx_tkip_phase1_write(dev, index, 0, (u16*)buf);
>
> Why do you write phase1, if TKIP is not used?
I clear the value in shared memory. This help debugging. But I could
remove it if you want.
>
>> +     /* FIXME : for b43_new_kidx_api, there can be 54 key
>> +      * instead of 50 in RCMTA and TKIPTSCTTAK.
>> +      */
>
> I don't understand this comment.
if  b43_new_kidx_api is true :
- we set max_nr_keys to 58
- we program B43_MMIO_RCMTA_COUNT to 50
- in b43_key_write we can allocate key up to index 58 (4 for default,
54 for sta)

But there is only 50 entries for TKIPTSCTTAK, and a comment on bcm-v4
suggest there is 50 entries for RCMTA. So if there more than 50
station we will overflow RCMTA and TKIPTSCTTAK.

So the fix will be do to something like
dev->max_nr_keys = (dev->dev->id.revision >= 5) ? 58 : 20;
if (b43_new_kidx_api())
dev->max_nr_keys -= 4;

>
>> -             if (algorithm == B43_SEC_ALGO_TKIP) {
>> -                     /* FIXME: No TKIP hardware encryption for now. */
>> +             if (algorithm == B43_SEC_ALGO_TKIP &&
>> +                             (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE) ||
>> +                                key->flags & IEEE80211_KEY_FLAG_WMM_STA )) {
>> +                     /* We support only one rx queue (no QOS) and pairwise key */
>
> This comment doesn't really make sense to me, too.
> What does QoS have to do with the RX queue?
each QOS queue got it's own tkip counters (iv16, iv32) (check tkip.c
software implementation for more info).

> Next time please inline the patch ;)
I will try, but I don't know if my mailer handle it.

Gregor
