Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60851 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbcAUPHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 10:07:41 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net-libertas: Better exception handling in if_spi_host_to_card_worker()
References: <566ABCD9.1060404@users.sourceforge.net>
	<5686F0B2.5000000@users.sourceforge.net>
	<56870866.7020000@cogentembedded.com>
	<568785B3.5000905@users.sourceforge.net>
	<alpine.DEB.2.02.1601020914100.2063@localhost6.localdomain6>
Date: Thu, 21 Jan 2016 17:07:34 +0200
In-Reply-To: <alpine.DEB.2.02.1601020914100.2063@localhost6.localdomain6>
	(Julia Lawall's message of "Sat, 2 Jan 2016 09:21:37 +0100 (CET)")
Message-ID: <87si1rx96x.fsf@kamboji.qca.qualcomm.com> (sfid-20160121_160805_228479_E8530D38)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julia Lawall <julia.lawall@lip6.fr> writes:

> On Sat, 2 Jan 2016, SF Markus Elfring wrote:
>
>> >> Move the jump label directly before the desired log statement
>> >> so that the variable "err" will not be checked once more
>> >> after it was determined that a function call failed.
>> >> Use the identifier "report_failure" instead of the label "err".
>> > 
>> >    Why?
>> 
>> I suggest to reconsider the places with which such a jump label
>> is connected.
>> 
>> 
>> > The code was smart enough
>> 
>> Which action should really be performed after a failure was detected
>> and handled a bit already?
>> 
>> * Another condition check
>> 
>> * Just additional error logging
>> 
>> 
>> > and you're making it uglier that it needs to be.
>> 
>> I assume that a software development taste can evolve, can't it?
>
> So far, you have gotten several down votes for this kind of change, and no 
> enthusiasm.
>
> Admittedly, this is a trivial case, because there are no local variables, 
> but do you actually know the semantics in C of a jump into a block?  And 
> if you do know, do you think that this semantics is common knowledge?  And 
> do you really think that introducing poorly understandable code is really 
> worth saving an if test of a single variable on a non-critical path?
>
> Most of the kernel code is not performance critical at the level of a 
> single if test.  So the goal should be for the code to be easy to 
> understand and robust to change.  The code that is performance critical, 
> you should probably not touch, ever.  The people who wrote it knew what 
> was important and what was not.

Very well said! Only optimise something you can measure.

I'm dropping this patch.

-- 
Kalle Valo
