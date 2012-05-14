Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:35397
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755681Ab2ENLpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 07:45:36 -0400
Date: Mon, 14 May 2012 13:45:33 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: Re: net: wireless: add brcm80211 drivers
In-Reply-To: <20120514083415.GA16999@mwanda>
Message-ID: <alpine.DEB.2.02.1205141345101.2160@localhost6.localdomain6> (sfid-20120514_134539_988391_E610BC9D)
References: <20120513174333.GB4280@elgon.mountain> <4FB0AF4B.9070606@broadcom.com> <20120514083415.GA16999@mwanda>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 14 May 2012, Dan Carpenter wrote:

> On Mon, May 14, 2012 at 09:07:55AM +0200, Arend van Spriel wrote:
>> Thanks for running smatch. I will look in the current code base and fix
>> this. Just out of curiosity: Another static checker used regularly is
>> Coccinelle. What are the pros and cons of smatch compared to Coccinelle?
>>
>> Gr. AvS
>
> That's a tricky question because of my obvious bias as the author
> of Smatch, and I'm not an expert on Coccinelle.  ;)
>
> Smatch works on the preprocessed code and Coccinelle works on .c
> code.  So some things are easier to check for in Coccinelle.  I've
> generally found hacks to get the information I need in Smatch but
> sometimes it's gnarly.  So a one liner in Coccinelle is twenty lines
> of code in Smatch which require in depth knowledge of Smatch and
> Sparse.
>
> Smatch doesn't fix the bugs it finds.
>
> The other advantage for Coccinelle is that you can run it on other
> architecture's code without setting up a cross compile environment.
>
> What Smatch does that Coccinelle doesn't is that it tries to track
> the values of all the variables.  This means you can detect array
> overflows, for example.  Smatch tries to track values across
> function calls as well, with the recent database work.
>
> That's really the long term goal of Smatch, to track the value of
> every variable in the kernel.  But there is still a lot of work to
> do.  :P

That all seems accurate to me :)

julia
