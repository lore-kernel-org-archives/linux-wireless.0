Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35659 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946215AbdDYLK1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 07:10:27 -0400
Received: by mail-pf0-f175.google.com with SMTP id v14so21869767pfd.2
        for <linux-wireless@vger.kernel.org>; Tue, 25 Apr 2017 04:10:27 -0700 (PDT)
Subject: Re: [PATCH] ath6kl: assure headroom of skbuff is writable in
 .start_xmit()
To: James Hughes <james.hughes@raspberrypi.org>
References: <1493111408-27692-1-git-send-email-arend.vanspriel@broadcom.com>
 <CAE_XsML=O-Ga9VXxifuE_rUqG47uKVyjwSHGXNSMorPa6340Og@mail.gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c07932c7-b207-28bc-d540-9a137c66657d@broadcom.com> (sfid-20170425_131120_145382_073FA1AE)
Date: Tue, 25 Apr 2017 13:10:19 +0200
MIME-Version: 1.0
In-Reply-To: <CAE_XsML=O-Ga9VXxifuE_rUqG47uKVyjwSHGXNSMorPa6340Og@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25-4-2017 11:36, James Hughes wrote:
> On 25 April 2017 at 10:10, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> An issue was found brcmfmac driver in which a skbuff in .start_xmit()
>> callback was actually cloned. So instead of checking for sufficient
>> headroom it should also be writable. Hence use skb_cow_head() to
>> check and expand the headroom appropriately.
>>
>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> ---
>> Hi Kalle,
>>
>> Did a recursive grep in drivers/net/wireless and found a similar
>> case in ath6kl. I do not have the hardware to test so this is
>> only compile tested.
>>
>> Regards,
>> Arend
>> ---
>>  drivers/net/wireless/ath/ath6kl/txrx.c | 13 ++++---------
>>  1 file changed, 4 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
>> index a531e0c..e6b2517 100644
>> --- a/drivers/net/wireless/ath/ath6kl/txrx.c
>> +++ b/drivers/net/wireless/ath/ath6kl/txrx.c
>> @@ -399,15 +399,10 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
>>                         csum_dest = skb->csum_offset + csum_start;
>>                 }
>>
>> -               if (skb_headroom(skb) < dev->needed_headroom) {
>> -                       struct sk_buff *tmp_skb = skb;
>> -
>> -                       skb = skb_realloc_headroom(skb, dev->needed_headroom);
>> -                       kfree_skb(tmp_skb);
>> -                       if (skb == NULL) {
>> -                               dev->stats.tx_dropped++;
>> -                               return 0;
>> -                       }
>> +               if (skb_cow_head(skb, dev->needed_headroom)) {
>> +                       dev->stats.tx_dropped++;
>> +                       kfree_skb(skb);
>> +                       return 0;
>>                 }
>>
>>                 if (ath6kl_wmi_dix_2_dot3(ar->wmi, skb)) {
>> --
>> 1.9.1
>>
> 
> Not sure if this is the right place to comment on this, but I've had a
> quick look around various network drivers, and there are similar
> constructs in a LOT of drivers. I've picked two at random, and both
> seem to show this issue. When the issue first came up in a USB
> attached smsc ethernet driver, at least 6 other drivers with similar
> faults were found in the net/usb tree.  Now I could just be being
> paranoid, and am missing something, so here are the files I looked
> at...
> 
> drivers/net/marvell/mwifiex/uap_txrx.c line 161 - no relevant skb_cow
> operations in this file, but changes are made to the buffers

This piece of code is used in rx. They have in-driver bridging
implemented in mwifiex. Surprised to see such a feature in a upstream
driver.

> /drivers/net/ethernet/sun/niu.c line 6657 - ditto

Looks suspicious indeed.

> I'm a bit of a beginner at this stuff, so not sure how this should be
> taken forward.

I looked at the wireless drivers specifically and initial grep was for
skb_push(), but that gave a lot of results. So just did a grep for
drivers touching struct net_device::needed_headroom. Admittedly that is
more of a glance than a proper look and it would probably be best if
driver maintainers would check for such headroom constructs in their
driver(s).

Regards,
Arend
