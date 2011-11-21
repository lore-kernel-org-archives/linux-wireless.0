Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51147 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab1KUDoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 22:44:08 -0500
Received: by ywt32 with SMTP id 32so4243932ywt.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 19:44:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmokN00pC40cAhpPYLzkBOpHsRwVC-LZX6=zPTBgaXhc3aw@mail.gmail.com>
References: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
	<1321775788-12520-3-git-send-email-mickflemm@gmail.com>
	<CAJ-VmokN00pC40cAhpPYLzkBOpHsRwVC-LZX6=zPTBgaXhc3aw@mail.gmail.com>
Date: Mon, 21 Nov 2011 05:44:07 +0200
Message-ID: <CAFtRNNwk-kk++s3xfZD+vv+k+0F24VWR8HJLLPu1DOP7FD4Otg@mail.gmail.com> (sfid-20111121_044432_452400_55B46DF4)
Subject: Re: [PATCH 02/13] ath5k: Maintain PISR snapshot
From: Nick Kossifidis <mickflemm@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/11/21 Adrian Chadd <adrian@freebsd.org>:
> .. replying to this after having not slept for > 24 hours, thanks to
> being in transit between the US and Western Australia..

Ouch ! I've done that a lot lately, without traveling :P

> On 20 November 2011 15:56, Nick Kossifidis <mickflemm@gmail.com> wrote:
>> Since we dont read a snapshot of the interrupt
>> registers it might be possible to get a new interrupt
>> while reading them. In this case we should make sure
>> that we clear all SISR bits we get from PISR.
>
> Just to be clear, you _shouldn't_ clear the secondary status mask bit
> in the primary status register when you write back 1's to the primary
> ISR.
> Clear the bits that you read in the secondary status registers. If you
> clear the relevant bit in the primary status register then you may
> also skip perfectly valid interrupts.
>
> You don't need to check the secondary registers and the primary ISR
> bits for consistency. Just read what I did in freebsd-head :
> src/sys/dev/ath/ath_hal/ar5416/ar5416_interrupts.c . it works fine.
>
>
> Adrian
>

ACK, thanks for the update ! It's just that docs say nothing about
when and how PISR gets updated so i tried to manually update it.

-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
