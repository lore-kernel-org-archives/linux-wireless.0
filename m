Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59572 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752682AbcIRQ0s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Sep 2016 12:26:48 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Joe Perches <joe@perches.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: Stop log spam from each successful interrupt
References: <1474132155-9330-1-git-send-email-Larry.Finger@lwfinger.net>
        <1474133525.32273.97.camel@perches.com> <wrfjfuoymeez.fsf@redhat.com>
        <8760pt7hzv.fsf@kamboji.qca.qualcomm.com>
Date: Sun, 18 Sep 2016 12:26:46 -0400
In-Reply-To: <8760pt7hzv.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Sun, 18 Sep 2016 11:02:44 +0300")
Message-ID: <wrfjh99dkwc9.fsf@redhat.com> (sfid-20160918_182652_202813_A145E126)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>
>> Joe Perches <joe@perches.com> writes:
>>> I think it'd be nicer to use dev_dbg for all these cases
>>> and as well use some new macro that includes the test
>>>
>>> Something like:
>>>
>>> #define rtl8xxxu_dbg(type, fmt, ...)			\
>>> do {							\
>>> 	if (rtl8xxxu_debug & (type))			\
>>> 		dev_dbg(dev, fmt, ##__VA_ARGS__);	\
>>> } while (0)
>>
>> Yuck yuck yuck, no thanks!
>>
>> Any attempt of adding that kinda grossness to the driver will get a
>> NACK.
>
> Huh, how is that ugly? To me it's the opposite, original code is ugly
> and Joes' proposal makes sense. Lots of wireless drivers have something
> similar.

Sorry it's a classic case of obfuscating the code for zero gain. If
someone else likes this kinda wrapper in their code, by all means go
ahead. In my book it's just bad coding taste.

Jes
