Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:33607 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbcEQPO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 11:14:27 -0400
Received: by mail-io0-f181.google.com with SMTP id f89so27366586ioi.0
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2016 08:14:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <878tz9p4z7.fsf@purkki.adurom.net>
References: <5500469A22567C4BAF673A6E86AFA3A4022D20D2594E@IR-CENTRAL.corp.innerrange.com>
	<878tz9p4z7.fsf@purkki.adurom.net>
Date: Tue, 17 May 2016 17:14:26 +0200
Message-ID: <CAGXE3d8hme7it1uKxW8HTH=S_PvfE-J-Mzvj+WaaLPr=dxiv4Q@mail.gmail.com> (sfid-20160517_171431_273862_EAADB8F6)
Subject: Re: rt2800 maximum clients in access point mode
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Craig McQueen <craig.mcqueen@innerrange.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 17, 2016 at 8:34 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Craig McQueen <craig.mcqueen@innerrange.com> writes:
>
>> What is the maximum number of clients that an rt2800 device can
>> support simultaneously while in access point mode?
>>
>> I've had a look through the Linux kernel code and searched online, but
>> haven't been able to find an answer so far.
>
> If you find the answer, please submit a patch to set
> wiphy->max_ap_assoc_sta in the driver. That way the limit is clearly
> visible and hostapd can make use of it.

As far as I remember, rt2800 has a limited key table (222 entries
according to the comments in the code).
Adding more STAs worked fine for me last time I tried (couple of years
ago). In that
case rt2800 should fall back to software crypto.

Helmut
