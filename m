Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40852 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758111AbaJ3QL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 12:11:28 -0400
Received: by mail-wi0-f177.google.com with SMTP id ex7so7867906wid.4
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2014 09:11:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54525DD8.6080506@mailservices.uwaterloo.ca>
References: <544A7871.7020005@mailservices.uwaterloo.ca>
	<CAJ-Vmon_jefxRgZvJmOsr4ydNHbvTCyMHHejRMWqXg_SG6NJUw@mail.gmail.com>
	<544AB9B8.9050407@mailservices.uwaterloo.ca>
	<CAJ-VmomYx1Dn5Oey1v4+8Yw7n0QkBiGKynFf_qNBD1JZb_Ra_A@mail.gmail.com>
	<544BC1B5.1040107@mailservices.uwaterloo.ca>
	<CAJ-Vmo=ceFvBDxL=HYSVmAMfEk0yxD_-a4MP3WjcvPAaupxPPw@mail.gmail.com>
	<544C0995.8010507@mailservices.uwaterloo.ca>
	<CAJ-VmonTjXvqPs2APB90pNgRyKwxPE2BJk+jxFGbLGw9uK2xHw@mail.gmail.com>
	<54525DD8.6080506@mailservices.uwaterloo.ca>
Date: Thu, 30 Oct 2014 09:11:26 -0700
Message-ID: <CAJ-VmonkWf5q445fR2PnsQarnA5Vuu4t4jNckU3-YUd+nbUZvQ@mail.gmail.com> (sfid-20141030_171131_959319_D1930A25)
Subject: Re: strange MPDU loss pattern
From: Adrian Chadd <adrian@freebsd.org>
To: Ali Abedi <a2abedi@uwaterloo.ca>
Cc: ath9k-devel <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 October 2014 08:48, Ali Abedi <a2abedi@uwaterloo.ca> wrote:
> Hi Adrian,
>
>
> We observed that this can happen for any rate for some SNR values.
> If the SNR is strong enough for the given MCS this won't happen.
> But when the SNR approaches the transition region when
> error rate starts to increase, this problem will be observed.
>
> So this can happen even for MCS0->MCS4 when the client is far from the AP
> and specially when it's moving.

Right. That's the missing useful information here. :)

Yes, I'd expect this happens whilst the client is moving. The training
stuff is all done on the beginning of the packet and channel
conditions aren't adjusted during packet reception - only upon the
next received packet.

(FYI - I've seen a similar pattern, but when i stand between the AP /
STA at > MCS13 and start waving my hands around. Just that slight
change in channel conditions == the above failure.)

So thanks for reminding us that we should take A-MPDU length into
account in our rate control code. :)



-adrian
