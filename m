Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.serverraum.org ([78.47.150.89]:42320 "EHLO
	mail.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560Ab1LGUsC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 15:48:02 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.serverraum.org (Postfix) with ESMTP id A84DD3EF96
	for <linux-wireless@vger.kernel.org>; Wed,  7 Dec 2011 21:49:05 +0100 (CET)
Received: from mail.serverraum.org ([127.0.0.1])
	by localhost (web.serverraum.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ii1HTphDuyGC for <linux-wireless@vger.kernel.org>;
	Wed,  7 Dec 2011 21:49:05 +0100 (CET)
Received: from mail-vw0-f46.google.com (mail-vw0-f46.google.com [209.85.212.46])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)
	by mail.serverraum.org (Postfix) with ESMTPSA id 3EB243EF94
	for <linux-wireless@vger.kernel.org>; Wed,  7 Dec 2011 21:49:05 +0100 (CET)
Received: by vbbfc26 with SMTP id fc26so862345vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2011 12:47:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EDFA124.7010804@lwfinger.net>
References: <CADYPuQ7W2B9HjR_TiV=dhD3vW-3pR4Y+s_9oJzTC-CdL+hr=9w@mail.gmail.com>
	<4ED44089.7010102@lwfinger.net>
	<CADYPuQ61D997MA2JCw1WD_xOosaKvaWK-_RHeBkLtabydDj2iw@mail.gmail.com>
	<4EDFA124.7010804@lwfinger.net>
Date: Wed, 7 Dec 2011 18:47:58 -0200
Message-ID: <CADYPuQ5io_nKkzqwY3uM5bre-bfUvrmH080MBpwqYpNeot5yHA@mail.gmail.com> (sfid-20111207_214805_928564_95928C9A)
Subject: Re: rtlwifi, rtl8192se bug soft-lockup
From: Philipp Dreimann <philipp@dreimann.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
	mikem@ring3k.org, John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 December 2011 15:23, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 12/07/2011 07:59 AM, Philipp Dreimann wrote:
>>
>> On 29 November 2011 00:16, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>>>
>>> On 11/28/2011 06:58 PM, Philipp Dreimann wrote:
>>>  From a quick look, Stanislaw's patch should fix your system. If not,
>>> then
>>> please consider pulling a git tree and checking out commit 34ddb20, which
>>> is
>>> the one before 67fc6052.
>>
>>
>> It fixed the issue *but* I am currently back to kernel v3.0.3, as it
>> is the most stable for me. I am not sure whether new issues were
>> introduced by using a v3.2-rc or if there is more wrong in the
>> rtl8192se driver itself. I had random sound and standby issues at
>> which I will have a look some other day.
>
>
> The bug that affected 3.2-rcX and fixed by Stanislaw's patch was not
> introduced until 3.1. A patch to fix it there was just queued by GregKH.

I had Stanislaw's patch included.

>> Another idea about the problem:
>> I omitted for some reason the following line in the first email about
>> the problem:
>> [  732.056049] BUG: soft lockup - CPU#0 stuck for 22s! [kworker/0:3:2112]
>
>
> That was a serious omission.

Yes.

>> While looking at the Call Trace and the code I have no idea why
>> rtl92s_phy_set_rf_power_state needs that much time for the ERFSLEEP
>> operation. I suspected an issue in the loop but did not find it so
>> far.
>
>
> With a modern CPU, no loop can take 22s unless it involves a spin lock that
> never is released.

Yes, and it should not, as the loop has the lock!

Putting things together:

- Stanislaw's patch prevents the occurrence of the issue with using
the irq safe spin lock.
  This is kind of an an revert of
312d5479dcfaca2b8aa451201b5388fdb8c8684a (I did not check
everything!).

- The loop-issue is still around but won't be noticed unless the
delayed execution of rtl_lps_leave() has side-effects..

- As it took up to an hour  to hit the issue, I suspect that there is
something else going wrong which interferes with the loop...

>> Another solution which I tested was the following:
>> 0. rtl_lps_leave function informs the  rtl92s_phy_set_rf_power_state
>> being in the ERFSLEEP-case-loop, that it needs the lock.
>> 1. rtl92s_phy_set_rf_power_state notices, "return false" ( leaves the
>> loop and function as if the action failed ) and the lock is released.
>>
>> This seemed to work fine as well. - But I am not sure what this might
>> break for others...
>
> Is this the same patch that you posted on the linux-wireless ML?

No, this was not posted so far. I will try to debug the loop issue
soonish. The outlined idea above only prevents the issue without
knowing what is happening.

> Although I
> have not heard back from Chaoming, I formatted that patch correctly and
> submitted it to John Linville yesterday with the notation that it should be
> applied to the stable kernels.

Thanks. The comment in v2 is fine now.
