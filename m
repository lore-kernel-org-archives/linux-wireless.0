Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:61208 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab3IXGwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 02:52:01 -0400
Received: by mail-bk0-f43.google.com with SMTP id mz13so1096470bkb.16
        for <linux-wireless@vger.kernel.org>; Mon, 23 Sep 2013 23:51:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87r4cebuxm.fsf@kamboji.qca.qualcomm.com>
References: <1379509691-19904-1-git-send-email-michal.kazior@tieto.com>
	<87r4cebuxm.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 24 Sep 2013 08:51:59 +0200
Message-ID: <CA+BoTQ=Tg1Qv8qXqw8++hXiDsBXyeQKDjYesWdNg25ORMQJGRg@mail.gmail.com> (sfid-20130924_085205_368558_05CB7FB0)
Subject: Re: [RFC] ath10k: replenish HTT RX buffers in a tasklet
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 September 2013 08:22, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This fixes system starvation when under heavy RX
>> traffic. This problem could be observed on AP135
>> and led to watchdog resetting the platform.
>>
>> Patch starves FW RX ring buffer by progressively
>> replenishing buffers to auto-balance the RX
>> handled to the host system.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> Looks good to me. I suspect there is a better way to do this in long
> term, but this looks like a viable short term solution.
>
> Does it decrease throughput in a noticeable way?

I have yet to observe any regressions.


Michał.
