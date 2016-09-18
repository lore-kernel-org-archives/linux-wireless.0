Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56846 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753640AbcIRICt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Sep 2016 04:02:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Joe Perches <joe@perches.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: Stop log spam from each successful interrupt
References: <1474132155-9330-1-git-send-email-Larry.Finger@lwfinger.net>
        <1474133525.32273.97.camel@perches.com> <wrfjfuoymeez.fsf@redhat.com>
Date: Sun, 18 Sep 2016 11:02:44 +0300
In-Reply-To: <wrfjfuoymeez.fsf@redhat.com> (Jes Sorensen's message of "Sat, 17
        Sep 2016 16:58:44 -0400")
Message-ID: <8760pt7hzv.fsf@kamboji.qca.qualcomm.com> (sfid-20160918_100254_384614_64C3CE08)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> writes:

> Joe Perches <joe@perches.com> writes:
>> On Sat, 2016-09-17 at 12:09 -0500, Larry Finger wrote:
>>> As soon as debugging is turned on, the logs are filled with messages
>>> reporting the interrupt status. As this quantity is usually zero, this
>>> output is not needed. In fact, there will be a report if the status is
>>> not zero, thus the debug line in question could probably be deleted.
>>> Rather than taking that action, I have changed it to only be printed
>>> when the RTL8XXXU_DEBUG_USB bit is set in the debug mask.
>>
>> There are many uses of
>> 	if (rtl8xxxu_debug & <DEFINE>) {
>> 		dev_info(dev, ...)
>>
>> Emitting debugging information at KERN_INFO is odd.
>
> Not at all, it's a pain to enable it in debug fs post loading the
> driver, especially if you need the output immediately during driver
> init. That is why the flags are there.
>
>> I think it'd be nicer to use dev_dbg for all these cases
>> and as well use some new macro that includes the test
>>
>> Something like:
>>
>> #define rtl8xxxu_dbg(type, fmt, ...)			\
>> do {							\
>> 	if (rtl8xxxu_debug & (type))			\
>> 		dev_dbg(dev, fmt, ##__VA_ARGS__);	\
>> } while (0)
>
> Yuck yuck yuck, no thanks!
>
> Any attempt of adding that kinda grossness to the driver will get a
> NACK.

Huh, how is that ugly? To me it's the opposite, original code is ugly
and Joes' proposal makes sense. Lots of wireless drivers have something
similar.

-- 
Kalle Valo
