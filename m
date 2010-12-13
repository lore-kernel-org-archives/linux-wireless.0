Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:1563 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab0LMSio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 13:38:44 -0500
Received: from kpbe15.cbf.corp.google.com (kpbe15.cbf.corp.google.com [172.25.105.79])
	by smtp-out.google.com with ESMTP id oBDIchr9001899
	for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 10:38:43 -0800
Received: from qyk29 (qyk29.prod.google.com [10.241.83.157])
	by kpbe15.cbf.corp.google.com with ESMTP id oBDIcQhr027152
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 10:38:42 -0800
Received: by qyk29 with SMTP id 29so6603251qyk.4
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 10:38:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D06670B.90200@lwfinger.net>
References: <AANLkTimqTaTJYinS-AyyjwR2hD+zLYuzjC6W0jDXMyB9@mail.gmail.com>
	<7A94256FD72B884D9E7C55586C3CBCEE13856A173D@SJEXCHCCR01.corp.ad.broadcom.com>
	<AANLkTikL8M-nbCuhj4UmYVYEX-5ba2rRthTMFqbYqmwp@mail.gmail.com>
	<4D06670B.90200@lwfinger.net>
Date: Mon, 13 Dec 2010 10:38:42 -0800
Message-ID: <AANLkTikYRuLi_8iXFnisH6g+-TmKPvvz2ERobq8Bjab9@mail.gmail.com>
Subject: Re: brcm80211 locking up
From: Sean Paul <seanpaul@google.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Brett Rudley <brudley@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,
Thanks for the insight. It's very difficult to debug this since the
loop is hosing my system, so it's unclear whether an unload/reload
would fix the issue.

Brett: Do you know the cause of the loop?

Thanks guys,

Sean

On Mon, Dec 13, 2010 at 10:33 AM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> On 12/13/2010 12:22 PM, Sean Paul wrote:
>> Hey Brett,
>> I've checked the switch, it's enabled. I've also tried the code on a
>> different machine (same model) with the same result.
>>
>> Sean
>>
>> On Mon, Dec 13, 2010 at 10:21 AM, Brett Rudley <brudley@broadcom.com> wrote:
>>> Check the RF disable switch on your laptop (also known as airline switch, wireless disable switch, etc).
>>> It probably got bumped to the 'disabled' position.
>
> I have noticed some instances where a new kernel will come up with rfkill hard
> blocked even when the switch is in the on position, and in one case where the
> box does not even have a switch. These have been with b43, thus no hang.
> Unloading/reloading the driver fixes the issue, which I think is caused by an
> uninitialized variable in rfkill. Thus far, I have not found a cause, and have
> not previously reported it.
>
> In any case, booting the computer with the rf switch off should not cause an
> infinite loop.
>
> Larry
>
>
