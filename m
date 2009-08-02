Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from imr-ma05.mx.aol.com ([64.12.100.31]:45099 "EHLO
	imr-ma05.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbZHBIwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 04:52:54 -0400
Message-ID: <4A755234.2030005@netscape.net>
Date: Sun, 02 Aug 2009 02:45:40 -0600
From: Patrick Simmons <linuxrocks123@netscape.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: David Miller <davem@davemloft.net>, mb@bu3sch.de,
	linux-wireless@vger.kernel.org, dsd@gentoo.org, kune@deine-taler.de
Subject: Re: [PATCH] Fix SPARC64 unaligned access in zd_mac_rx
References: <1249029583.29587.46.camel@johannes.local>	 <20090731.222350.254918321.davem@davemloft.net>	 <200908011240.17229.mb@bu3sch.de>	 <20090801.091207.217317135.davem@davemloft.net>	 <4A74EEB2.6040400@netscape.net> <1249199441.2007.7.camel@johannes.local>	 <4A754D31.7010709@netscape.net> <1249202040.2007.48.camel@johannes.local>
In-Reply-To: <1249202040.2007.48.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sun, 2009-08-02 at 02:24 -0600, Patrick Simmons wrote:
>
>   
>> It does look wrong, now that I look at it further, but I'm pretty sure 
>> that what was happening was that only the lower 8 bits of the 
>> dereferenced value were being accessed. 
>>     
>
> Yes, you're right, because buffer is a "u8 *", I initially thought that
> it didn't take a pointer, but that wouldn't work, of course.
>
>   
>>  What's odd is that it works on 
>> my machine, though.  Whatever.  Your version is clearer, in any case.
>>
>> What follows is hopefully the last version of this patch.
>>     
>
> Looks good, but I think you should resubmit with
>  * a changed subject (e.g. "zd1211rw: fix unaligned access in zd_mac_rx")
>  * a standalone patch description so John doesn't have to pick it out of
>    your first patch etc.
>
>
> Thanks!
> johannes
>
>   
Sure thing; here it comes.  Thanks for the review.

--Patrick
