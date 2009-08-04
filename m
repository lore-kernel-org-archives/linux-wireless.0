Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-150-144.gdrpmi.dsl-w.verizon.net ([71.115.150.144]:60796
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbZHDPh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 11:37:27 -0400
Message-ID: <4A7855B3.1040007@erley.org>
Date: Tue, 04 Aug 2009 11:37:23 -0400
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Richard Farina <sidhayn@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [DISCUSS] Implement non standard channel widths
References: <4A74D5F5.8090409@erley.org> <1249201869.2007.45.camel@johannes.local> <4A77AA0A.2030205@gmail.com>
In-Reply-To: <4A77AA0A.2030205@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Richard Farina wrote:
> Johannes Berg wrote:
>> Then, finally, I'd add a new channel type, NL80211_CHANNEL_TYPE_5MHZ.
>> Document it to imply that HT is being turned off, of course. Now this
>> bit should be really simple.
>>
>>   
> But why? There is no reason mcs rates can't be used on 5/10 Mhz channels
> as far as I know. Bad enough these channels are running at half and
> quarter rates, if you can use mcs why not?
> 
> Just my 0.02
> 
> thanks,
> Rick Farina

My thought on this topic is: design everything so these COULD be supported,
but wait until someone tests/implements this functionality with a driver
and needs support for them.  If I understood Johannes' description of things
correctly, if it was found that a driver could do mcs rates in other channel
widths, it'd be as simple as adding the values to the bitfields and that 
driver testing/implementing that functionality.  

What I guess it's come around to is:

1.  Change the way the current functionality is implemented
2.  Add additional values as it's added. 

What I believe johannes was saying is, during the implementation of 5/10mhz 
channels, disable ht/mcs modes up front, until someone shows/implements it.

Pat
