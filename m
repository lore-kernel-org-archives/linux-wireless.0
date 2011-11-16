Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54613 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab1KPLB7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 06:01:59 -0500
Received: by ywt32 with SMTP id 32so4617002ywt.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 03:01:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOZOX0Wa4gquXeMrh_1U2kJvJQttQDQ9pWNVT5jjoHOxZxL4jg@mail.gmail.com>
References: <20111116100915.GA2191@redhat.com>
	<CAGXE3d8oPL9POJEZdb4urFVQXjPY2W8HYePLc2F804=W7nCfSw@mail.gmail.com>
	<CAOZOX0Wa4gquXeMrh_1U2kJvJQttQDQ9pWNVT5jjoHOxZxL4jg@mail.gmail.com>
Date: Wed, 16 Nov 2011 12:01:59 +0100
Message-ID: <CAGXE3d-O7vn+cZJ-Z-jYwt_oyiRTA01uz+70j7cy9xCkWAi1Gw@mail.gmail.com> (sfid-20111116_120203_062168_13F3EA53)
Subject: Re: [PATCH] rt2800pci: handle spurious interrupts
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Amir Hedayaty <hedayaty@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 16, 2011 at 11:52 AM, Ivo Van Doorn <ivdoorn@gmail.com> wrote:
> On Wed, Nov 16, 2011 at 11:46 AM, Helmut Schaa
> <helmut.schaa@googlemail.com> wrote:
>> On Wed, Nov 16, 2011 at 11:09 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>>> +       /*
>>> +        * Some devices can generate interrupts with empty CSR register, we
>>> +        * "handle" such irq's to prevent interrupt controller treat them as
>>> +        * spurious interrupts and disable irq line.
>>> +        */
>>>        if (!reg)
>>> -               return IRQ_NONE;
>>> +               return IRQ_HANDLED;
>>
>> What if this interrupt belongs to a different device on a shared interrupt line?
>> In case reg is zero we can't be sure our device generated this interrupt, right?
>
> In the bugzilla report  Stanislaw indicated that even when rt2800pci
> indicates IRQ_HANDLED,
> all other drivers on the same interruptline will still get the interrupt event.

Ah, ok. Should be fine with me then ...

Thanks.
