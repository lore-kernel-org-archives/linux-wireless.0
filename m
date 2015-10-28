Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:32823 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbbJ1TOD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 15:14:03 -0400
Received: by oiad129 with SMTP id d129so10732075oia.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2015 12:14:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d866527bb2404c9f895960173159744a@SC-EXCH04.marvell.com>
References: <CAGHP0pK5452ixOHr0uWY=o2S2JvgoqVx8X7r6ZnQ=ezxqNg1UA@mail.gmail.com>
 <d866527bb2404c9f895960173159744a@SC-EXCH04.marvell.com>
From: Chris Kuethe <chris.kuethe@gmail.com>
Date: Wed, 28 Oct 2015 12:13:42 -0700
Message-ID: <CAGHP0pJEnqvkRgtVprGxBqOd_c9m-ybE9L_9zAtJS=c7=LbckQ@mail.gmail.com> (sfid-20151028_201408_261651_176C44E6)
Subject: Re: problems with mwifiex_usb, hangs under load, firmware in bad state
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 28, 2015 at 7:15 AM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> Thanks for reporting the problem. These two messages are actually warnings and not genuine error. They are expected during heavy traffic.
> I will submit a patch to suppress them. Meanwhile you can comment them out in your code.

Done.

>> Occasionally I'll also see
>>     usb 1-2: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed
>
> Do your machine have enough space when this error occurs? Can you check if this problem is still observed when above two error messages are suppressed?

Yes. I have lots of free space and memory. This problem is
reproducible when after removing those two error logs.

> Can you remove those two messages and share the log to me for analysis?

Link to log sent via private email.

> Also, share if there is any definite procedure so that we can try to recreate the issue at our end.

My test is simply to run some big wgets in a loop and wait for the
errors. Sometimes it happens after a few hundred MB, sometimes after a
few GB.

-- 
GDB has a 'break' feature; why doesn't it have 'fix' too?
