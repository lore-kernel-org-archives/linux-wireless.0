Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36723 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbcCGKwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 05:52:00 -0500
Received: by mail-lb0-f181.google.com with SMTP id x1so125470958lbj.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Mar 2016 02:51:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160307095945.GD23699@redhat.com>
References: <20160301103612.GC29736@c50.bag.software> <20160307095945.GD23699@redhat.com>
From: Vishal Thanki <vishalthanki@gmail.com>
Date: Mon, 7 Mar 2016 11:51:39 +0100
Message-ID: <CAC3a_SCjeyDN6m6d=XRBs0FRjqvPM+e8hL5z6uT9h-e_23iajA@mail.gmail.com> (sfid-20160307_115205_024815_C45B5C80)
Subject: Re: rt2x00queue: rt2800usb: NULL pointer crash while during USB disconnect
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 7, 2016 at 10:59 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Hi,
>
> On Tue, Mar 01, 2016 at 11:36:13AM +0100, Vishal Thanki wrote:
>> I observed a NULL pointer access crash during my testing on a custom AM33xx
>> based board with RT5572 USB wifi module. The kernel log is attached with
>> the mail. With initial debugging, I think that the USB disconnect
>> event was triggered while there was an pending/incomplete URB request
>> present. As a part of USB disconnect, the driver cleanup deallocated
>> queues. However the completion of pending URB tried to access the queue,
>> which resulted in the NULL pointer crash.
>>
>> I added a check in the queue helper routines and with that I did not see
>> the problem. The patch for the same is also attached with the email.
>> Please suggest if that is the right way to address the problem.
>
> Fix is not correct as we can crash at any other point if we get callback
> from pending urb after resources are freed. What should be done is
> create a list of pending urbs (possibly using usb_anchor structure and
> primitives) and kill urb's before freeing resources.
>

Thank you for the reply. I will prepare the patch as suggested.

Vishal

> Stanislaw
