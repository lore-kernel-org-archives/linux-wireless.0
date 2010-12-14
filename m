Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:59968 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759573Ab0LNUE6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 15:04:58 -0500
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id oBEK4uIO015049
	for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 12:04:56 -0800
Received: from qyk10 (qyk10.prod.google.com [10.241.83.138])
	by wpaz33.hot.corp.google.com with ESMTP id oBEK0gme016659
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 12:04:55 -0800
Received: by qyk10 with SMTP id 10so1145177qyk.7
        for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 12:04:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=NdBsXA-6Wj8MPDaggzmFMCDcKo7n8NQE6UjH1@mail.gmail.com>
References: <AANLkTimqTaTJYinS-AyyjwR2hD+zLYuzjC6W0jDXMyB9@mail.gmail.com>
	<7A94256FD72B884D9E7C55586C3CBCEE13856A173D@SJEXCHCCR01.corp.ad.broadcom.com>
	<AANLkTikL8M-nbCuhj4UmYVYEX-5ba2rRthTMFqbYqmwp@mail.gmail.com>
	<4D06670B.90200@lwfinger.net>
	<AANLkTikYRuLi_8iXFnisH6g+-TmKPvvz2ERobq8Bjab9@mail.gmail.com>
	<7A94256FD72B884D9E7C55586C3CBCEE13856A1786@SJEXCHCCR01.corp.ad.broadcom.com>
	<AANLkTi=NdBsXA-6Wj8MPDaggzmFMCDcKo7n8NQE6UjH1@mail.gmail.com>
Date: Tue, 14 Dec 2010 15:04:55 -0500
Message-ID: <AANLkTino-9swQA66WoSxsYuVvHgaGCaStoeimvd6Q4Os@mail.gmail.com>
Subject: Re: brcm80211 locking up
From: Sean Paul <seanpaul@google.com>
To: Brett Rudley <brudley@broadcom.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brett,
Could we, in the interim, turn off the radio disabled check until the
driver is properly fixed? I've hard-coded it to false which seems to
work for me.

Thanks,

Sean

On Tue, Dec 14, 2010 at 9:26 AM, Sean Paul <seanpaul@google.com> wrote:
> Hi Brett,
> I've been testing on a Lenovo S10-3t, with the 4313 chipset. I've
> tried 2 other S10-3t units with the same result (making doubly sure
> the switch was in the on position). I haven't tried another model with
> the 4313 in it.
>
> Is it possible that Larry's experiences with the b43 driver and rfkill
> are related?
>
> Thanks,
>
> Sean
>
> On Mon, Dec 13, 2010 at 2:32 PM, Brett Rudley <brudley@broadcom.com> wrote:
>>
>>> -----Original Message-----
>>> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>>> owner@vger.kernel.org] On Behalf Of Sean Paul
>>> Sent: Monday, December 13, 2010 10:39 AM
>>> To: Larry Finger
>>> Cc: Brett Rudley; linux-wireless@vger.kernel.org
>>> Subject: Re: brcm80211 locking up
>>>
>>> Hi Larry,
>>> Thanks for the insight. It's very difficult to debug this since the
>>> loop is hosing my system, so it's unclear whether an unload/reload
>>> would fix the issue.
>>>
>>> Brett: Do you know the cause of the loop?
>>
>>> Two issues:
>>
>> - Something on your machine is forcing the radio off.
>> - The driver isn't handling the radio off condition during load.
>>
>> The latter is on our todo list and I just haven't had time to deal with yet.
>>
>> The former is odd... I haven't seen this before (except for when my RF switch was actually off).
>>
>> What machine is this and have you seen the problem on any other type of machines?  Does it happen all the time, some of the time?
>>
>> Brett
>>
>>
>>
>
