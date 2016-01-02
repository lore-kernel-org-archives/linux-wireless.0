Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:37553 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbcABKNb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 05:13:31 -0500
Subject: Re: net-libertas: Better exception handling in
 if_spi_host_to_card_worker()
To: SF Markus Elfring <elfring@users.sourceforge.net>,
	Julia Lawall <julia.lawall@lip6.fr>
References: <566ABCD9.1060404@users.sourceforge.net>
 <5686F0B2.5000000@users.sourceforge.net>
 <56870866.7020000@cogentembedded.com>
 <568785B3.5000905@users.sourceforge.net>
 <alpine.DEB.2.02.1601020914100.2063@localhost6.localdomain6>
 <5687939E.7010701@users.sourceforge.net>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
From: Arend van Spriel <aspriel@gmail.com>
Message-ID: <5687A2C7.3000704@gmail.com> (sfid-20160102_111356_885749_81D438BE)
Date: Sat, 2 Jan 2016 11:13:27 +0100
MIME-Version: 1.0
In-Reply-To: <5687939E.7010701@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02-01-16 10:08, SF Markus Elfring wrote:
>>> I assume that a software development taste can evolve, can't it?
>>
>> So far, you have gotten several down votes for this kind of change,
> 
> I am curious when more contributors will share corresponding opinions.

Let's burn some cycles on this while the holidays give me time to do so.
"software development taste" is another term for "coding style". In
every project battles are fought over this between friends and foes. I
have never seen much evolution going on in this area.

>> and no enthusiasm.
> 
> How many software designers and developers can become enthusiastic
> about better exception handling to some degree?

I had to  take a look at this particular patch and I have to say that I
don't see, using your favorite term, evolution at work. It looks more
like the result of inbred. What the patch tries to do is avoid the extra
'if (err)'. Setting coding style aside, the question is whether there is
a good metric for the patch. So does it really safe processing time? Did
you look at the resulting assembly code for different target architectures?

You got pushed back on the change so you have to come up with solid
arguments for your change instead of spewing ideas about evolution in
software development. Running Coccinelle is one thing, but understanding
the results and what you are ultimately proposing to be changed is more
important.

Regards,
Arend

>> The code that is performance critical, you should probably not touch, ever.
> 
> I imagine that technical evolution will result in further considerations
> so that "unchangeable" components can be adjusted once more.
> 
> 
>> The people who wrote it knew what was important and what was not.
> 
> I might come along at some places where the affected knowledge will also evolve.
> 
> Regards,
> Markus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
