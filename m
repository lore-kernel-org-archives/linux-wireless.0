Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:54661 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab2JTQvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Oct 2012 12:51:38 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so1317570oag.19
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2012 09:51:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201210191000.41350.chunkeey@googlemail.com>
References: <CAMr9ZPkS3TXg7XDNzeor7zXED7cUUqcGdrb53OFGtr0N8Hh5Ng@mail.gmail.com>
	<201210191000.41350.chunkeey@googlemail.com>
Date: Sat, 20 Oct 2012 09:51:37 -0700
Message-ID: <CAMr9ZPnqjyqhoRuafBu=uxrQSxGNSe3oQYMX+--2aoLv4OW=BQ@mail.gmail.com> (sfid-20121020_185141_661659_33C9BB55)
Subject: Re: Receive BlockAckReq and BlockAck on carl9170 driver
From: Javier Lopez <jlopex@cozybit.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Christian,

Thanks for your comments, they helped a lot. Now we are able to
receive the frames on carl9170_handle_mpdu on mesh mode.

After setting the monitor interface we noticed that the traps were not
called but the frames were received. So we checked the traps and we
saw that they were placed before the frame was correctly aligned.

Then removing the CARL9170_RX_FILTER_CTL_OTHER did the rest.

Thanks,

Jlo

On Fri, Oct 19, 2012 at 1:00 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> Hello,
>
> On Friday, October 19, 2012 05:57:57 AM Javier Lopez wrote:
>> We are trying to receive BlockAckReq and BlockAck on carl9170 driver.
>> We've been playing with CARL9170_RX_FILTER_CTL_OTHER and
>> CARL9170_RX_FILTER_CTL_BACKR rx filters but we cannot see
>> those frames on the traps we have on carl9170_handle_mpdu
>> function.
> Do you have an example of such a frame trap? And what operation
> mode do you use? Normal station, adhoc, AP or mesh? Are the
> BA/BARs for directed to the carl9170-device, or are they for
> someone else? ---
>
>> Is it not possible to receive those frames on driver?
> Do you get these frames on a secondary monitor interface?
>
> Regards,
>         Chr



-- 
Javier Lopez
Software Engineer
cozybit Inc.
