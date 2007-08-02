Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:33973 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754711AbXHBQds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 12:33:48 -0400
Message-ID: <46B20760.5000406@lwfinger.net>
Date: Thu, 02 Aug 2007 11:33:36 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC V3] bcm43xx-mac80211: Provide information to allow transmission  rate decreases
References: <46b1fa6d.d4l4DujAaAR2ORZf%Larry.Finger@lwfinger.net> <200708021805.17004.mb@bu3sch.de>
In-Reply-To: <200708021805.17004.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Thursday 02 August 2007, Larry Finger wrote:
>> Michael,
>>
>> I couldn't find any long/short indication in the header, so I added a bool that
>> is set when the frame is sent.
> 
> This is not going to work.
> 
> But we can do this differently.
> You can do something like:
> 
> if (!status->acked && !tx_control->noack)
> 	excessive_retries = 1;
> 
> So we don't need to care about the retry count.
> 
> Anyway. I don't know why we need excessive_retries _at_ _all_.
> The rc algorithm does already know if the frame succeed or failed
> anyway.

Yes, it does, but it only looks at the potential for reduction if excessive retries is set. Why? 
Because it was coded that way! As I said earlier, I don't want to get involved there.

I'll try to implement it as above.

Larry

