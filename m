Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53002 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab1KPKwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 05:52:24 -0500
Received: by vcbfk1 with SMTP id fk1so192858vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 02:52:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGXE3d8oPL9POJEZdb4urFVQXjPY2W8HYePLc2F804=W7nCfSw@mail.gmail.com>
References: <20111116100915.GA2191@redhat.com>
	<CAGXE3d8oPL9POJEZdb4urFVQXjPY2W8HYePLc2F804=W7nCfSw@mail.gmail.com>
Date: Wed, 16 Nov 2011 11:52:23 +0100
Message-ID: <CAOZOX0Wa4gquXeMrh_1U2kJvJQttQDQ9pWNVT5jjoHOxZxL4jg@mail.gmail.com> (sfid-20111116_115226_930104_E69EE378)
Subject: Re: [PATCH] rt2800pci: handle spurious interrupts
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Amir Hedayaty <hedayaty@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 16, 2011 at 11:46 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> On Wed, Nov 16, 2011 at 11:09 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> +       /*
>> +        * Some devices can generate interrupts with empty CSR register, we
>> +        * "handle" such irq's to prevent interrupt controller treat them as
>> +        * spurious interrupts and disable irq line.
>> +        */
>>        if (!reg)
>> -               return IRQ_NONE;
>> +               return IRQ_HANDLED;
>
> What if this interrupt belongs to a different device on a shared interrupt line?
> In case reg is zero we can't be sure our device generated this interrupt, right?

In the bugzilla report  Stanislaw indicated that even when rt2800pci
indicates IRQ_HANDLED,
all other drivers on the same interruptline will still get the interrupt event.

Ivo
