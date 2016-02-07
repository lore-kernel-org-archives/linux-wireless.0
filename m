Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:35265 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbcBGH1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2016 02:27:40 -0500
Received: by mail-lf0-f52.google.com with SMTP id l143so79454649lfe.2
        for <linux-wireless@vger.kernel.org>; Sat, 06 Feb 2016 23:27:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87k2mhro8j.fsf@purkki.adurom.net>
References: <CALGY4fuC7CHHFtp3VYtEZe_UFb_frHWK+_C+LWQVrC+0fzn4Kg@mail.gmail.com>
	<87k2mhro8j.fsf@purkki.adurom.net>
Date: Sun, 7 Feb 2016 09:27:38 +0200
Message-ID: <CANUX_P3zTJnnjFRks0Bp0zG90bHLY8iGYQngxy20pRh5ky6dmA@mail.gmail.com> (sfid-20160207_082742_958340_01E42B78)
Subject: Re: Monitor interface TX performance boost
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Nikolay Martynov <mar.kolya@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 7, 2016 at 9:09 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Nikolay Martynov <mar.kolya@gmail.com> writes:
>
>>   I'm seeing strange behavior on my intel 6300 card.
>>
>>   If I measure TX performance just after boot (iperf in tcp mode), I get this:
>>
>> [  3]  0.0-10.1 sec  11.2 MBytes  9.32 Mbits/sec
>>
>>   But if create and enable monitor interface (with command like 'sudo
>> iw phy phy0 interface add moni0 type monitor && sudo ifconfig moni0
>> up') I get this:
>>
>> [  3]  0.0-10.1 sec  34.8 MBytes  29.0 Mbits/sec
>>
>> That's about three times boost in throughput by just creating an
>> interface (without even using it).
>> Doing 'ifconfig moni0 down' bring performance back to 10Mbits range.
>>
>> Experiments are done with laptop being ~5m from router and not moving.
>> These results are repeatable, i.e. not caused by random things like
>> other stations transmitting, or channel being busy.
>>
>> Is this something expected? Is there any reason performance can be as
>> good without monitor interface existing?
>
> Maybe the monitor mode disables power save automatically?
>

That could be an option although I remember to have disabled power
save by default (cough..).
That happened in 3.17 IIRC.
