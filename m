Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:35309 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbbERPbp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 11:31:45 -0400
Received: by obcus9 with SMTP id us9so128804286obc.2
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2015 08:31:43 -0700 (PDT)
Message-ID: <555A05DC.8080704@lwfinger.net> (sfid-20150518_173151_686783_3582258F)
Date: Mon, 18 May 2015 10:31:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Haggai Eran <haggai.eran@gmail.com>,
	Arend van Spriel <aspriel@gmail.com>
CC: Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: kernel page fault in r8712u
References: <CAJ=9Czbh2cT-qvkEmvVWPCwWdAJ5H_kAcRXirW4MQDhrMb4XRg@mail.gmail.com>	<55575AC8.2060301@lwfinger.net>	<CAJ=9CzasMnjhMSWT0P=eenvaeDA04Q2aGhY0z1npD-NDuh7YeQ@mail.gmail.com>	<5557844B.4040108@lwfinger.net>	<CAJ=9CzamCxkwVtTtUzU9zatocUPz0W+3f0Kgm6N0tDMWbcP_LA@mail.gmail.com>	<55586D8D.7040407@gmail.com>	<CAJ=9CzbxScr7SJjhxnxAWt+xS-A8VR-_PQs0BbbdUp7xCaG2aw@mail.gmail.com> <CAJ=9CzaDK+oKJ8JJtb_OE6wrh85f8ffPf_oa9c0GRQFStUULjg@mail.gmail.com>
In-Reply-To: <CAJ=9CzaDK+oKJ8JJtb_OE6wrh85f8ffPf_oa9c0GRQFStUULjg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/17/2015 02:22 PM, Haggai Eran wrote:
> I added some debugging prints, trying to see more details about the
> packet that fails the r8712_validate_recv_frame. I noticed I'm getting
> many packets where recv_decache returns _FAIL. However, the last two
> packets before the crash fail for different reasons. The first has the
> ver field set to 3 (instead of zero). The second (the one that get's
> freed and cause the crash apparently) has an unknown type (12). If I'm
> not mistaken, 12 = WIFI_CTRL_TYPE | WIFI_DATA_TYPE. Is that possible?
>
> It could be that the packet headers are garbled though.

I think the headers are garbled. Did you log the address of the skb at 
precvframe->u.hdr.pkt in r8712_free_recvframe() or orig_prframe->u.hdr.pct in 
recv_func().

I am still dubious of the cast "prframe = (union recv_frame *)pcontext;" in 
recv_func().

Larry


