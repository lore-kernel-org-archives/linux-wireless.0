Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:38286 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbcEOOow convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2016 10:44:52 -0400
Received: by mail-ig0-f172.google.com with SMTP id m9so29129635ige.1
        for <linux-wireless@vger.kernel.org>; Sun, 15 May 2016 07:44:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160515163906.3d64d8fe@wiggum>
References: <CAJ-Vmom45Pb9X_1Zw6VdszZAiizZUUd=HbEFw0hFMmPFFSNbpQ@mail.gmail.com>
	<20160515163906.3d64d8fe@wiggum>
Date: Sun, 15 May 2016 07:44:51 -0700
Message-ID: <CAJ-VmonNc_qFWJf+AOsUOUVMmRJwH4r_y8YSGrnKWuh=vUJnMQ@mail.gmail.com> (sfid-20160515_164456_329226_D8A1CA7C)
Subject: Re: [b43] don't unconditionally fall back to CCK if the rate is 6MB OFDM.
From: Adrian Chadd <adrian@freebsd.org>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: b43-dev@lists.infradead.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 May 2016 at 07:39, Michael Büsch <m@bues.ch> wrote:
> On Sun, 15 May 2016 07:23:25 -0700
> Adrian Chadd <adrian@freebsd.org> wrote:
>
>> @@ -438,7 +446,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
>>
>>                 rts_rate = rts_cts_rate ? rts_cts_rate->hw_value :
>> B43_CCK_RATE_1MB;
>
> I just noticed that this is incorrect for 5GHz, too.
> Maybe there are more such bugs.

There are other bugs, yes. I'll do some more digging and submit
follow-up patches, including for the rts_rate selection.

I've tested this on BCM4321 on FreeBSD; it came up in a code review of
b43 whilst I was learning about the driver/hardware. I've tested the
change on FreeBSD and it works correctly. I'll setup a separate PC
linux environment next week to test things on.


-adrian
