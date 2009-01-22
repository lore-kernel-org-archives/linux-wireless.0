Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:35179 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbZAVTTU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 14:19:20 -0500
Received: by ewy13 with SMTP id 13so2930121ewy.13
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 11:19:18 -0800 (PST)
Message-ID: <4978C6B4.80601@gmail.com> (sfid-20090122_201924_988895_82BE8B46)
Date: Thu, 22 Jan 2009 20:19:16 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC][RFT][PATCH] p54usb: rx refill revamp
References: <200901211450.50880.chunkeey@web.de> <200901221609.27401.chunkeey@web.de> <4978964C.8000301@gmail.com> <200901221701.59190.chunkeey@web.de>
In-Reply-To: <200901221701.59190.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Thursday 22 January 2009 16:52:44 Artur Skawina wrote:
>> Christian Lamparter wrote:
>>> On Thursday 22 January 2009 06:40:56 Artur Skawina wrote:
>>> was this with your patch to use rx_refills urb pool for tx, or without?
>> just your patch plus the fixes that i needed to get it to work, all
>> of them were in that email. The subject said RFT... ;)
>> [the line #s were off, because of some extra printks logging the queue len]
>>
> all right, could you please put a commit message in your mail as well?

I thought you had already merged the changes, but i see you only took the
first hunk. There's no point in splitting the commit, as the intermediate
result wouldn't work. You can add my s-o-b, if you feel that's necessary.
This last version seems fine, just one thing: I can't convince myself
that not queuing the work after an urb fails with urb->status==true is
safe -- what if some temporary error condition causes the rx queue to
drain? Nothing will resubmit the urbs. 
Wouldn't a usb_poison_anchored_urbs() instead of usb_kill_anchored_urbs()
in p54u_free_urbs() prevent p54u_rx_refill from resubmitting, and that early
return in the completion could then go? Or did i miss a case where it's
needed, other than stop()?

artur
