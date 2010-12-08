Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:54379 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331Ab0LHTYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 14:24:49 -0500
Received: by fxm18 with SMTP id 18so1472147fxm.2
        for <linux-wireless@vger.kernel.org>; Wed, 08 Dec 2010 11:24:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101206212502.GA31434@monopoli.naic.edu>
References: <AANLkTinLaa+dOiq67DAt+KYfnxUEkNgWEiE2x1NtT9RE@mail.gmail.com>
	<AANLkTim-hexpFnV_DfKGM53vWo1-5W6fbK4e+jLnb5fB@mail.gmail.com>
	<20101203202321.GA21937@monopoli.naic.edu>
	<AANLkTi=qvZ-Uj1T=9Xc8LyyxKvgNw4CKV8Zx2fDfo4uH@mail.gmail.com>
	<20101204033646.GA22662@monopoli.naic.edu>
	<AANLkTik=nbdNUU7gzO9V17fHWZibc2LjuXDgpeRDztoM@mail.gmail.com>
	<20101204134732.GA24216@monopoli.naic.edu>
	<AANLkTinU+Xv+gNSTJnEz_tYPhcXRf=kEfkyyeuN0QPFt@mail.gmail.com>
	<20101206042812.GB28134@monopoli.naic.edu>
	<AANLkTimC4NkPhpmOUWHvWpCZGvXjM1GkZCUja=Qhr=9N@mail.gmail.com>
	<20101206212502.GA31434@monopoli.naic.edu>
Date: Wed, 8 Dec 2010 19:24:47 +0000
Message-ID: <AANLkTi=YawLwmnJeKX+dFe4mW1vbGbQnD2z4qQV0_3q3@mail.gmail.com>
Subject: Re: orinoco_cs module and WPA not working
From: Dave Kilroy <kilroyd@googlemail.com>
To: Giacomo Comes <comes@naic.edu>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 6, 2010 at 9:25 PM, Giacomo Comes <comes@naic.edu> wrote:
> On Mon, Dec 06, 2010 at 06:43:04PM +0000, Dave Kilroy wrote:
>> > The only issue still not fixed is the suspend/resume timeout.
>> > Can you help also with that?
>>
>> Absolutely. With the latest patches, please just do a suspend resume,
>> and post the dmesg output. Also let me know what the value of
>> CONFIG_HERMES_CACHE_FW_ON_INIT is.
>
> CONFIG_HERMES_CACHE_FW_ON_INIT=y
>
> Attached is the outpur of dmesg after suspend/resume
>
> As you can see, the driver is unable to load the firmware,
> therefore WPA is not available after resume:

I've had a look at the log. Things aren't working as I'd expect.
orinoco_init is being called on resume, which I don't think used to
happen. That is what is causing the request for firmware, and the
delay on resume.

Instead I only expected orinoco_up to get called. I'll dig around to
see whether that's a change in the kernel. It might be distro specific
though. Do you know if suse works differently on suspend/resume? i.e
explicitly 'modprobe -r'ing drivers


Dave.
