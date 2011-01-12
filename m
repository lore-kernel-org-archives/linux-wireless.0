Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62026 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478Ab1ALBh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 20:37:29 -0500
Received: by eye27 with SMTP id 27so29382eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 17:37:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D2BA3CD.4010305@openwrt.org>
References: <AANLkTikj+40TksokdnAKzXnBi7CBE5GO4BEKoaxQG79D@mail.gmail.com>
	<4D2BA3CD.4010305@openwrt.org>
Date: Tue, 11 Jan 2011 20:37:27 -0500
Message-ID: <AANLkTimsPoa=1ifA6x0q4rZ0t40tpbMUNzesXuCPk=wf@mail.gmail.com>
Subject: Re: ath9k_hw_check_alive routine
From: Bill Jordan <bjordan@rajant.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 10, 2011 at 7:26 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2011-01-10 1:23 PM, Bill Jordan wrote:
>>
>> This routine is failing a lot on my AR9160. The ((reg&  0x7E7FFFEF) ==
>> 0x00702400) test is the one that always fails. There is no debug
>> messages in this path, so it may not be obvious whether others are
>> experiencing the problem.
>>
>> This forces ath9k_tasklet to reset the hardware. If I increase the
>> count to 500, I can eliminate most of the resets, so the hardware
>> isn't really hung. However, it sometimes takes over 25 milliseconds
>> before the test condition passes.
>>
>> I don't have specs for the radio, and the numeric constants aren't
>> very useful, so I can't tell what condition we are waiting for or why.
>>
>> Can someone with a spec shed some light on this problem?
>
> I just posted a 4-patch series, the last patch of that should take care of
> this problem. Please test.
>
> - Felix
>

I tried your patch. It improved the situation, but it still reset
every couple minutes. It also seems to reset a few times in quick
succession every time it resets. What is the routine testing for? Is
this a test for a stuck transmitter? I'm in a very noisy environment,
and it could take a while to transmit.

Bill Jordan
