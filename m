Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43958 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750Ab1DMBiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 21:38:09 -0400
Received: by gwaa18 with SMTP id a18so68327gwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 18:38:08 -0700 (PDT)
Message-ID: <4DA4FE7C.8070807@lwfinger.net>
Date: Tue, 12 Apr 2011 20:38:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>
CC: Igor Plyatov <plyatov@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: rt2800usb: page allocation failure
References: <4DA471DC.7080308@gmail.com> <4DA49332.8000403@lwfinger.net> <20110412212236.GA8877@sig21.net>
In-Reply-To: <20110412212236.GA8877@sig21.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/12/2011 04:22 PM, Johannes Stezenbach wrote:
>
> I don't think the allocation uses the MTU, rather rt2x00queue_alloc_rxskb()
> uses some hw specific constants.  No idea if these can be reduced,
> but multi-page GFP_ATOMIC allocations can easily fail.

That is likely. Those hw specific constants add up to 40 bytes, thus the major 
part is actual buffer. That is set at 3840 bytes, thus I don't understand why 
the request was order 1.

> However, I'm not sure why an 8kB allocation fails if the oom dump
> says 2*8kB are available.  I guess it has something to do with
> the GFP_ATOMIC.

My guess is that those 8kB buffers were freed between the failure and the dump. 
The actual allocation is done by dev_alloc_skb() through a call to __alloc_skb() 
with GFP_ATOMIC, thus we have no chance to change this.

@Igor: The buffer size is set in the define for AGGREGATION_SIZE located in 
drivers/net/wireless/rt2x00/rt2x00queue.h. Reducing that will cut the buffer 
size request, but might not help the problem.

Larry
