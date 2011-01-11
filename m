Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54991 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab1AKA1D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 19:27:03 -0500
Message-ID: <4D2BA3CD.4010305@openwrt.org>
Date: Mon, 10 Jan 2011 17:26:53 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Bill Jordan <bjordan@rajant.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re: ath9k_hw_check_alive routine
References: <AANLkTikj+40TksokdnAKzXnBi7CBE5GO4BEKoaxQG79D@mail.gmail.com>
In-Reply-To: <AANLkTikj+40TksokdnAKzXnBi7CBE5GO4BEKoaxQG79D@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-10 1:23 PM, Bill Jordan wrote:
> This routine is failing a lot on my AR9160. The ((reg&  0x7E7FFFEF) ==
> 0x00702400) test is the one that always fails. There is no debug
> messages in this path, so it may not be obvious whether others are
> experiencing the problem.
>
> This forces ath9k_tasklet to reset the hardware. If I increase the
> count to 500, I can eliminate most of the resets, so the hardware
> isn't really hung. However, it sometimes takes over 25 milliseconds
> before the test condition passes.
>
> I don't have specs for the radio, and the numeric constants aren't
> very useful, so I can't tell what condition we are waiting for or why.
>
> Can someone with a spec shed some light on this problem?
I just posted a 4-patch series, the last patch of that should take care 
of this problem. Please test.

- Felix
