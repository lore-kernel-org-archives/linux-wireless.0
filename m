Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:34168 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbbESFAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 01:00:25 -0400
Received: by laat2 with SMTP id t2so5579870laa.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2015 22:00:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <555AC172.4040507@lwfinger.net>
References: <CAJ=9Czbh2cT-qvkEmvVWPCwWdAJ5H_kAcRXirW4MQDhrMb4XRg@mail.gmail.com>
	<55575AC8.2060301@lwfinger.net>
	<CAJ=9CzasMnjhMSWT0P=eenvaeDA04Q2aGhY0z1npD-NDuh7YeQ@mail.gmail.com>
	<5557844B.4040108@lwfinger.net>
	<CAJ=9CzamCxkwVtTtUzU9zatocUPz0W+3f0Kgm6N0tDMWbcP_LA@mail.gmail.com>
	<55586D8D.7040407@gmail.com>
	<CAJ=9CzbxScr7SJjhxnxAWt+xS-A8VR-_PQs0BbbdUp7xCaG2aw@mail.gmail.com>
	<CAJ=9CzaDK+oKJ8JJtb_OE6wrh85f8ffPf_oa9c0GRQFStUULjg@mail.gmail.com>
	<555A05DC.8080704@lwfinger.net>
	<CAJ=9CzY3E0Y3++g6sWEmgBQ70YmJEJaUdunN9AS4obLT4-WaBQ@mail.gmail.com>
	<555AC172.4040507@lwfinger.net>
Date: Tue, 19 May 2015 08:00:24 +0300
Message-ID: <CAJ=9CzbZaJXQUdyiGK+coP8FYzhM_F4JCo4vSAtwMMzkhbedLw@mail.gmail.com> (sfid-20150519_070030_425948_8AD9331A)
Subject: Re: kernel page fault in r8712u
From: Haggai Eran <haggai.eran@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 May 2015 at 07:52, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> OK, I will have to search further upstream to see how a faulty skb was
> provided.
>
> I have been testing r8712u on my x86_64 system with no difficulty.
>
> I checked the driver with Smatch and found a couple of array problems. These
> likely won't be the problem, but try the attached patches anyway.

I found one place that might be the cause for the fault. The
recvbuf2recvframe function has a line copying memory between the
incoming pskb and a new allocated skb:

1065                 pkt_copy = netdev_alloc_skb(padapter->pnetdev, alloc_sz);
1066                 if (pkt_copy) {
1067                         precvframe->u.hdr.pkt = pkt_copy;
1068                         skb_reserve(pkt_copy, 4 - ((addr_t)(pkt_copy->data)
1069                                     % 4));
1070                         skb_reserve(pkt_copy, shift_sz);
1071                         memcpy(pkt_copy->data, pbuf, tmp_len);
1072                         precvframe->u.hdr.rx_head =
precvframe->u.hdr.rx_data =
1073                                  precvframe->u.hdr.rx_tail =
pkt_copy->data;
1074                         precvframe->u.hdr.rx_end = pkt_copy->data
+ alloc_sz;

I added a BUG_ON there in case the memcpy overflows
(BUG_ON((pkt_copy->end - pkt_copy->data) < tmp_len)) and it trigerred.
I'm not sure why does the overflow occur though.

Haggai
