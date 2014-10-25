Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59103 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaJYTe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:34:58 -0400
Received: by mail-wi0-f180.google.com with SMTP id em10so3587088wid.1
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:34:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <544AB9B8.9050407@mailservices.uwaterloo.ca>
References: <544A7871.7020005@mailservices.uwaterloo.ca>
	<CAJ-Vmon_jefxRgZvJmOsr4ydNHbvTCyMHHejRMWqXg_SG6NJUw@mail.gmail.com>
	<544AB9B8.9050407@mailservices.uwaterloo.ca>
Date: Sat, 25 Oct 2014 08:19:28 -0700
Message-ID: <CAJ-VmomYx1Dn5Oey1v4+8Yw7n0QkBiGKynFf_qNBD1JZb_Ra_A@mail.gmail.com> (sfid-20141025_213501_232783_5045BFE1)
Subject: Re: strange MPDU loss pattern
From: Adrian Chadd <adrian@freebsd.org>
To: Ali Abedi <a2abedi@uwaterloo.ca>
Cc: ath9k-devel <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 October 2014 13:42, Ali Abedi <a2abedi@uwaterloo.ca> wrote:
> We don't use a rate adaptation at this moment (i.e., fixed rate) and the
> setup
>  is stationary. So we expect to see relatively stable channel conditions.
> Even if the channel
> conditions change during the aggregated frame. The first half of the MPDUs
> have the same chance of experiencing worse channel conditions.

How do you /know/ you have stable channel conditions?

There are a lot of things that could be going on inside the devices
you're testing on. It doesn't have to be channel noise coming in an
antenna. For example, your computer could be generating rapidly
changing noise spurs from some clocking sources.

Try firing up the spectral scan mode on the NIC and plot the data. See
if there are any abnormal peaks going on over time.

And a large / long A-MPDU could be measured in milliseconds of length.
the original poster didn't say which rate(s) they are trying with and
how much margin (SNR) the receiver is seeing. Pulling out EVM from the
received A-MPDU frames would also be helpful.

Thanks,



-adrian




-adrian
