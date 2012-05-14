Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2223 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949Ab2ENJGT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 05:06:19 -0400
Message-ID: <4FB0CB01.3000507@broadcom.com> (sfid-20120514_110623_183400_B601A407)
Date: Mon, 14 May 2012 11:06:09 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>
cc: linux-wireless@vger.kernel.org, "Julia Lawall" <julia@diku.dk>
Subject: Re: net: wireless: add brcm80211 drivers
References: <20120513174333.GB4280@elgon.mountain>
 <4FB0AF4B.9070606@broadcom.com> <20120514083415.GA16999@mwanda>
In-Reply-To: <20120514083415.GA16999@mwanda>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/14/2012 10:34 AM, Dan Carpenter wrote:
> On Mon, May 14, 2012 at 09:07:55AM +0200, Arend van Spriel wrote:
>> Thanks for running smatch. I will look in the current code base and fix
>> this. Just out of curiosity: Another static checker used regularly is
>> Coccinelle. What are the pros and cons of smatch compared to Coccinelle?
>>
>> Gr. AvS
> 
> That's a tricky question because of my obvious bias as the author
> of Smatch, and I'm not an expert on Coccinelle.  ;)

 ;-)

> Smatch works on the preprocessed code and Coccinelle works on .c
> code.  So some things are easier to check for in Coccinelle.  I've
> generally found hacks to get the information I need in Smatch but
> sometimes it's gnarly.  So a one liner in Coccinelle is twenty lines
> of code in Smatch which require in depth knowledge of Smatch and
> Sparse.
> 
> Smatch doesn't fix the bugs it finds.

+1 for Coccinelle.

> The other advantage for Coccinelle is that you can run it on other
> architecture's code without setting up a cross compile environment.
> 
> What Smatch does that Coccinelle doesn't is that it tries to track
> the values of all the variables.  This means you can detect array
> overflows, for example.  Smatch tries to track values across
> function calls as well, with the recent database work.

I guess Oracle knows a thing or two about databases.

> That's really the long term goal of Smatch, to track the value of
> every variable in the kernel.  But there is still a lot of work to
> do.  :P

Enjoy and thanks for taking time to explain.

Gr. AvS

