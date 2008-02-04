Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb.errno.com ([69.12.149.25]:3522 "EHLO ebb.errno.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbYBDRgc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 12:36:32 -0500
Message-ID: <47A74923.8040201@errno.com> (sfid-20080204_173636_325121_2ED6D623)
Date: Mon, 04 Feb 2008 09:19:31 -0800
From: Sam Leffler <sam@errno.com>
MIME-Version: 1.0
To: Kalle Valo <kalle.valo@nokia.com>
CC: Tomas Winkler <tomasw@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: Re: cfg80211 API changes
References: <1ba2fa240802030539h132c7365g1bc1c20b1c560c0@mail.gmail.com>	<1ba2fa240802030555v28873634wceff4ecea67d3530@mail.gmail.com>	<1202049444.4188.125.camel@johannes.berg>	<1ba2fa240802030651x58ab6c63yd1b4d9ccaa2ecd42@mail.gmail.com> <87ve55b74j.fsf@nokia.com>
In-Reply-To: <87ve55b74j.fsf@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> Tomas Winkler <tomasw@gmail.com> writes:
>
>   
>>> TBH, that confused me completely since the rate scale algorithm tells
>>> the hardware what rate to use so why does the hw need to assign a
>>> different rate in the tx status?
>>>       
>> I see.  Rate scale algorithm only tels FW from what rate to start
>> transmission. FW is responsible to do downscaling.  Which is quite
>> reasonable as retransmission is real time process. Instead of
>> retransmitting on the same rate FW downscales. T X response provides
>> to the rate scaling algorithm the successful rate.
>>     
>
> I just want to point out this is an important feature when the bus is
> very slow, for example SPI bus in embedded devices. Retransfering
> frames through SPI for every rate restransmit would make such a device
> extremely slow.
>   

I don't know of a part that does repeated DMA to implement retransmit; 
do you have an example?

Regardless, the original issue is independent; good devices support 
multi-rate retransmit so the final tx rate may not be the same as the 
rate specified for the initial series.  Whether this is done in fw or hw 
doesn't matter.

    Sam
