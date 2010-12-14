Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:17661 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab0LNO0k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 09:26:40 -0500
Received: from kpbe20.cbf.corp.google.com (kpbe20.cbf.corp.google.com [172.25.105.84])
	by smtp-out.google.com with ESMTP id oBEEQcm2021797
	for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 06:26:38 -0800
Received: from qwh6 (qwh6.prod.google.com [10.241.194.198])
	by kpbe20.cbf.corp.google.com with ESMTP id oBEEQa1e023829
	for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 06:26:36 -0800
Received: by qwh6 with SMTP id 6so802286qwh.21
        for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 06:26:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7A94256FD72B884D9E7C55586C3CBCEE13856A1786@SJEXCHCCR01.corp.ad.broadcom.com>
References: <AANLkTimqTaTJYinS-AyyjwR2hD+zLYuzjC6W0jDXMyB9@mail.gmail.com>
	<7A94256FD72B884D9E7C55586C3CBCEE13856A173D@SJEXCHCCR01.corp.ad.broadcom.com>
	<AANLkTikL8M-nbCuhj4UmYVYEX-5ba2rRthTMFqbYqmwp@mail.gmail.com>
	<4D06670B.90200@lwfinger.net>
	<AANLkTikYRuLi_8iXFnisH6g+-TmKPvvz2ERobq8Bjab9@mail.gmail.com>
	<7A94256FD72B884D9E7C55586C3CBCEE13856A1786@SJEXCHCCR01.corp.ad.broadcom.com>
Date: Tue, 14 Dec 2010 09:26:36 -0500
Message-ID: <AANLkTi=NdBsXA-6Wj8MPDaggzmFMCDcKo7n8NQE6UjH1@mail.gmail.com>
Subject: Re: brcm80211 locking up
From: Sean Paul <seanpaul@google.com>
To: Brett Rudley <brudley@broadcom.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brett,
I've been testing on a Lenovo S10-3t, with the 4313 chipset. I've
tried 2 other S10-3t units with the same result (making doubly sure
the switch was in the on position). I haven't tried another model with
the 4313 in it.

Is it possible that Larry's experiences with the b43 driver and rfkill
are related?

Thanks,

Sean

On Mon, Dec 13, 2010 at 2:32 PM, Brett Rudley <brudley@broadcom.com> wrote:
>
>> -----Original Message-----
>> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>> owner@vger.kernel.org] On Behalf Of Sean Paul
>> Sent: Monday, December 13, 2010 10:39 AM
>> To: Larry Finger
>> Cc: Brett Rudley; linux-wireless@vger.kernel.org
>> Subject: Re: brcm80211 locking up
>>
>> Hi Larry,
>> Thanks for the insight. It's very difficult to debug this since the
>> loop is hosing my system, so it's unclear whether an unload/reload
>> would fix the issue.
>>
>> Brett: Do you know the cause of the loop?
>
>> Two issues:
>
> - Something on your machine is forcing the radio off.
> - The driver isn't handling the radio off condition during load.
>
> The latter is on our todo list and I just haven't had time to deal with yet.
>
> The former is odd... I haven't seen this before (except for when my RF switch was actually off).
>
> What machine is this and have you seen the problem on any other type of machines?  Does it happen all the time, some of the time?
>
> Brett
>
>
>
