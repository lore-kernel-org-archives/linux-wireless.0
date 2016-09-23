Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35649 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758507AbcIWGsV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Sep 2016 02:48:21 -0400
Received: by mail-oi0-f50.google.com with SMTP id w11so124522535oia.2
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2016 23:48:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rzhdzUDhG=jqG6Fksqh7qPP-7jKSTN0AoA-8u84HdrYdQ@mail.gmail.com>
References: <20160920111604.32716-1-zajec5@gmail.com> <20160922115935.11287-1-zajec5@gmail.com>
 <bdc7e4d1-0d96-c8ed-e07a-fdb19c1265d8@gmail.com> <CACna6rzhdzUDhG=jqG6Fksqh7qPP-7jKSTN0AoA-8u84HdrYdQ@mail.gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Fri, 23 Sep 2016 08:48:19 +0200
Message-ID: <CACna6rwKfunLZhs3B=qJnWtGZ+qrZzY0kZ=st3KU1LqO5REoLw@mail.gmail.com> (sfid-20160923_084832_989157_A76890A3)
Subject: Re: brcmf_txfinalize misses 802.1x packet leading to infinite WARNINGs
To: Hante Meuleman <meuleman@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        brcm80211 development <brcm80211-dev-list@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 September 2016 at 16:09, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> w=
rote:
> On 22 September 2016 at 14:24, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>=
 wrote:
>> I got the same problem again, but this time there was only 1 skb in my
>> flowring.
>> That resulted in less serial console messages and no reboot.
>>
>> It doesn't look good. brcmf_txfinalize was called 11 times after deletin=
g
>> flowring. Everytime it was working with the same skb that was already fr=
eed.
>
> I'm wondering if there is some bug in flowring code. Please take a
> look if my following understanding it correct.
>
> 1) Every skb that is supposed to reach the device gets queued on a flowri=
ng.
> 2) Dequeuing means skb is not available in a flowring anymore
> 3a) brcmf_msgbuf_txflow dequeues skbs to pass them to the firmware
> 3b) brcmf_flowring_delete dequeues skbs to delete (free) them
>
> If that simple description is correct, it shouldn't be possible to skb to=
:
> 1) Reach the firmware
> *and*
> 2) Get freed as part of flowring deletion
>
> But this is what seems to be happening in my case. We get one skb
> freed on flowring deletion and then reported as transmitted (sometimes
> multiple times) by the firmware.
>
> Maybe there is simply a race between brcmf_flowring_delete and
> brcmf_msgbuf_txflow?

I can see a problem with my debugging code. It may happen brcmfmac
gets skb allocated at the same address. Due to brcmf_flowring_delete
bypassing brcmf_txfinalize we don't drop tracing of the old one and
that results in the same packet listed twice in my debugging code.

I got caught into the same trap that breaks pend_8021x_cnt counting.

I believe pend_8021x_cnt related code should be moved to the place
that really queues skb for the firmware to access.

--=20
Rafa=C5=82
