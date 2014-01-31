Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redpinesignals.com ([203.196.161.92]:19976 "EHLO
	mail.redpinesignals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121AbaAaKzp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 05:55:45 -0500
Message-ID: <52EB8137.1000405@redpinesignals.com> (sfid-20140131_115547_927331_FC36082C)
Date: Fri, 31 Jan 2014 16:25:51 +0530
From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3.13.1 3/9] rsi: Packet queueing/dequeueing to device
References: <52EA75B5.5040002@redpinesignals.com>	 (sfid-20140130_170030_682221_D838173E) <1391103351.4323.23.camel@jlt4.sipsolutions.net>
In-Reply-To: <1391103351.4323.23.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WMM is being implemented in the hardware, the packets are 
being scheduled similarly to help out the scheduling in the 
hardware. Will consider the cases when multiple devices are 
using the same driver and incorporate the changes.  

Regards,
Jahnavi

On 01/30/2014 11:05 PM, Johannes Berg wrote:
On Thu, 2014-01-30 at 21:24 +0530, Jahnavi wrote:

>> +#ifdef USE_SDIO_INTF
>> +static unsigned int pkt_count;
>> +#endif
>> +static unsigned int selected_qnum, pkt_cnt;
> static variables are a really bad idea, especially ones like this. Have
> you ever thought about more than one USB device being plugged in to the
> same machine? :)
>
> Also, I'm not sure trying to implement QoS in software is a great idea,
> or does it only look like that's what you're doing?
>
> johannes
>
>
>


