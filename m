Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34060 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753112AbcIVOJV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 10:09:21 -0400
Received: by mail-oi0-f45.google.com with SMTP id a62so98782130oib.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2016 07:09:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bdc7e4d1-0d96-c8ed-e07a-fdb19c1265d8@gmail.com>
References: <20160920111604.32716-1-zajec5@gmail.com> <20160922115935.11287-1-zajec5@gmail.com>
 <bdc7e4d1-0d96-c8ed-e07a-fdb19c1265d8@gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Thu, 22 Sep 2016 16:09:19 +0200
Message-ID: <CACna6rzhdzUDhG=jqG6Fksqh7qPP-7jKSTN0AoA-8u84HdrYdQ@mail.gmail.com> (sfid-20160922_160925_274251_BBE59383)
Subject: Re: brcmf_txfinalize misses 802.1x packet leading to infinite WARNINGs
To: Hante Meuleman <meuleman@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        brcm80211 development <brcm80211-dev-list@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 September 2016 at 14:24, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> w=
rote:
> On 09/22/2016 01:59 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
>>
>> And again...
>>
>> I decided to focus on brcmf_flowring_delete a bit more.
>>
>> As I can see flowrings are created and removed from time to time, in mos=
t
>> cases
>> they are empty when being deleted. When they are not, things go wrong. I=
n
>> below
>> log you can see brcmfmac removing flowring that got 8 skb packets.
>>
>> First some summary, of what was already partially noticed in previous
>> e-mail:
>> 1) brcmf_flowring_delete calls brcmu_pkt_buf_free_skb directly bypassing
>>    brcmf_txfinalize. It means tracing 802.1x packets and counting TX
>> errors is
>>    broken.
>> 2) After freeing skb (as the result of brcmf_flowring_delete) there will
>> still
>>    an IRQ, MSGBUF_TYPE_TX_STATUS and call to the brcmf_txfinalize. That'=
s
>>    definitely unexpected as brcmf_txfinalize will be operating on skb th=
at
>> was
>>    already freed.
>>
>> Now, there is something new that looks even worse. Sometimes
>> brcmf_txfinalize
>> may be called multiple times for the same skb! Take a close look at my
>> log.
>> It was called twice for skb c64a5a80. Twice for c64a5480. Twice for
>> c64a5f00.
>> Then Linux/device rebooted itself due to amount of console messages.
>
>
> I got the same problem again, but this time there was only 1 skb in my
> flowring.
> That resulted in less serial console messages and no reboot.
>
> It doesn't look good. brcmf_txfinalize was called 11 times after deleting
> flowring. Everytime it was working with the same skb that was already fre=
ed.

I'm wondering if there is some bug in flowring code. Please take a
look if my following understanding it correct.

1) Every skb that is supposed to reach the device gets queued on a flowring=
.
2) Dequeuing means skb is not available in a flowring anymore
3a) brcmf_msgbuf_txflow dequeues skbs to pass them to the firmware
3b) brcmf_flowring_delete dequeues skbs to delete (free) them

If that simple description is correct, it shouldn't be possible to skb to:
1) Reach the firmware
*and*
2) Get freed as part of flowring deletion

But this is what seems to be happening in my case. We get one skb
freed on flowring deletion and then reported as transmitted (sometimes
multiple times) by the firmware.

Maybe there is simply a race between brcmf_flowring_delete and
brcmf_msgbuf_txflow?
