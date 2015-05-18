Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:32799 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbbERRiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 13:38:22 -0400
Received: by lagr1 with SMTP id r1so149004412lag.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2015 10:38:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <555A05DC.8080704@lwfinger.net>
References: <CAJ=9Czbh2cT-qvkEmvVWPCwWdAJ5H_kAcRXirW4MQDhrMb4XRg@mail.gmail.com>
	<55575AC8.2060301@lwfinger.net>
	<CAJ=9CzasMnjhMSWT0P=eenvaeDA04Q2aGhY0z1npD-NDuh7YeQ@mail.gmail.com>
	<5557844B.4040108@lwfinger.net>
	<CAJ=9CzamCxkwVtTtUzU9zatocUPz0W+3f0Kgm6N0tDMWbcP_LA@mail.gmail.com>
	<55586D8D.7040407@gmail.com>
	<CAJ=9CzbxScr7SJjhxnxAWt+xS-A8VR-_PQs0BbbdUp7xCaG2aw@mail.gmail.com>
	<CAJ=9CzaDK+oKJ8JJtb_OE6wrh85f8ffPf_oa9c0GRQFStUULjg@mail.gmail.com>
	<555A05DC.8080704@lwfinger.net>
Date: Mon, 18 May 2015 20:38:20 +0300
Message-ID: <CAJ=9CzbrwmG5x6i9wOH0g9hwNq27J_maVe7kS8Nco9y4BJEOpg@mail.gmail.com> (sfid-20150518_193826_439571_302C753D)
Subject: Re: kernel page fault in r8712u
From: Haggai Eran <haggai.eran@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Arend van Spriel <aspriel@gmail.com>,
	Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 May 2015 at 18:31, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 05/17/2015 02:22 PM, Haggai Eran wrote:
>>
>> I added some debugging prints, trying to see more details about the
>> packet that fails the r8712_validate_recv_frame. I noticed I'm getting
>> many packets where recv_decache returns _FAIL. However, the last two
>> packets before the crash fail for different reasons. The first has the
>> ver field set to 3 (instead of zero). The second (the one that get's
>> freed and cause the crash apparently) has an unknown type (12). If I'm
>> not mistaken, 12 = WIFI_CTRL_TYPE | WIFI_DATA_TYPE. Is that possible?
>>
>> It could be that the packet headers are garbled though.
>
>
> I think the headers are garbled. Did you log the address of the skb at
> precvframe->u.hdr.pkt in r8712_free_recvframe() or orig_prframe->u.hdr.pct
> in recv_func().
I haven't. I'll print that.

>
> I am still dubious of the cast "prframe = (union recv_frame *)pcontext;" in
> recv_func().

Why? As far as I can see, recv_func is called only at one place
(r8712_recv_entry), where it is passed a union recv_frame * as the
pcontext parameter.

Haggai
