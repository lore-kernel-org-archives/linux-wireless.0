Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49346 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668Ab1LGRXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 12:23:53 -0500
Received: by ghbz2 with SMTP id z2so695373ghb.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2011 09:23:52 -0800 (PST)
Message-ID: <4EDFA124.7010804@lwfinger.net> (sfid-20111207_182405_607794_E17148E3)
Date: Wed, 07 Dec 2011 11:23:48 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Philipp Dreimann <philipp@dreimann.net>
CC: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
	mikem@ring3k.org, John Linville <linville@tuxdriver.com>
Subject: Re: rtlwifi, rtl8192se bug soft-lockup
References: <CADYPuQ7W2B9HjR_TiV=dhD3vW-3pR4Y+s_9oJzTC-CdL+hr=9w@mail.gmail.com> <4ED44089.7010102@lwfinger.net> <CADYPuQ61D997MA2JCw1WD_xOosaKvaWK-_RHeBkLtabydDj2iw@mail.gmail.com>
In-Reply-To: <CADYPuQ61D997MA2JCw1WD_xOosaKvaWK-_RHeBkLtabydDj2iw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/07/2011 07:59 AM, Philipp Dreimann wrote:
> On 29 November 2011 00:16, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>> On 11/28/2011 06:58 PM, Philipp Dreimann wrote:
>>  From a quick look, Stanislaw's patch should fix your system. If not, then
>> please consider pulling a git tree and checking out commit 34ddb20, which is
>> the one before 67fc6052.
>
> It fixed the issue *but* I am currently back to kernel v3.0.3, as it
> is the most stable for me. I am not sure whether new issues were
> introduced by using a v3.2-rc or if there is more wrong in the
> rtl8192se driver itself. I had random sound and standby issues at
> which I will have a look some other day.

The bug that affected 3.2-rcX and fixed by Stanislaw's patch was not introduced 
until 3.1. A patch to fix it there was just queued by GregKH.

> Another idea about the problem:
> I omitted for some reason the following line in the first email about
> the problem:
> [  732.056049] BUG: soft lockup - CPU#0 stuck for 22s! [kworker/0:3:2112]

That was a serious omission.

> While looking at the Call Trace and the code I have no idea why
> rtl92s_phy_set_rf_power_state needs that much time for the ERFSLEEP
> operation. I suspected an issue in the loop but did not find it so
> far.

With a modern CPU, no loop can take 22s unless it involves a spin lock that 
never is released.

> Another solution which I tested was the following:
> 0. rtl_lps_leave function informs the  rtl92s_phy_set_rf_power_state
> being in the ERFSLEEP-case-loop, that it needs the lock.
> 1. rtl92s_phy_set_rf_power_state notices, "return false" ( leaves the
> loop and function as if the action failed ) and the lock is released.
>
> This seemed to work fine as well. - But I am not sure what this might
> break for others...

Is this the same patch that you posted on the linux-wireless ML? Although I have 
not heard back from Chaoming, I formatted that patch correctly and submitted it 
to John Linville yesterday with the notation that it should be applied to the 
stable kernels.

Larry
