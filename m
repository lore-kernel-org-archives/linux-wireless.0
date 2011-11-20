Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50120 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab1KTPnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 10:43:07 -0500
Received: by ywt32 with SMTP id 32so3905337ywt.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 07:43:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EC8C6FD.1030103@openwrt.org>
References: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
	<1321775788-12520-7-git-send-email-mickflemm@gmail.com>
	<4EC8C6FD.1030103@openwrt.org>
Date: Sun, 20 Nov 2011 17:43:06 +0200
Message-ID: <CAFtRNNxbEnbS27Hd=ZKN2nMfOABEZ-nEBygLZr5FSaoXvtvBhA@mail.gmail.com> (sfid-20111120_164334_987770_1FEAA8CD)
Subject: Re: [PATCH 06/13] ath5k: Use usleep_range where possible
From: Nick Kossifidis <mickflemm@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/11/20 Felix Fietkau <nbd@openwrt.org>:
> On 2011-11-20 8:56 AM, Nick Kossifidis wrote:
>> Use usleep_range where possible to reduce busy waits
>>
>> Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>> ---
>>  drivers/net/wireless/ath/ath5k/attach.c |    2 +-
>>  drivers/net/wireless/ath/ath5k/pci.c    |    2 +-
>>  drivers/net/wireless/ath/ath5k/phy.c    |   22 +++++++++++-----------
>>  drivers/net/wireless/ath/ath5k/reset.c  |   14 +++++++-------
>>  4 files changed, 20 insertions(+), 20 deletions(-)
>>
>> @@ -1454,7 +1454,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
>>       beacon = ath5k_hw_reg_read(ah, AR5K_BEACON_5210);
>>       ath5k_hw_reg_write(ah, beacon & ~AR5K_BEACON_ENABLE, AR5K_BEACON_5210);
>>
>> -     mdelay(2);
>> +     usleep_range(2000, 2500);
>>
>>       /*
>>        * Set the channel (with AGC turned off)
>> @@ -1467,7 +1467,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
>>        * Activate PHY and wait
>>        */
>>       ath5k_hw_reg_write(ah, AR5K_PHY_ACT_ENABLE, AR5K_PHY_ACT);
>> -     mdelay(1);
>> +     usleep_range(1000, 1500);
>>
>>       AR5K_REG_DISABLE_BITS(ah, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
>>
> Are you sure this is safe? This looks like it's being called from
> tasklet context, and I think usleep_range is not allowed there.
>
> - Felix
>

Reset runs in process context. Calls to reset are done directly from
non-interrupt context (e.g. during init) or through a work queue, not
a tasklet. They are also locked using a mutex lock, not a spinlock so
we should be fine.

I did a few tests to be on the safe side and run this on a multi-core
system with an AR2425 with no problems/deadlocks or anything.



-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
