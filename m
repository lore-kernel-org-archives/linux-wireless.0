Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:28162 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070Ab2DUOvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2012 10:51:46 -0400
Date: Sat, 21 Apr 2012 16:51:44 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Julia Lawall <julia.lawall@lip6.fr>, Kalle Valo <kvalo@adurom.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] wireless: at76c50x: allocating too much data
In-Reply-To: <20120421145140.GU6498@mwanda>
Message-ID: <alpine.DEB.2.02.1204211650310.1987@hadrien> (sfid-20120421_165150_500489_B8468BCF)
References: <20120420064705.GE22649@elgon.mountain> <CAGRGNgVgtAYknmpB_8Q0OpcUWFjTxBistG+RNs1ORDZeckGsWw@mail.gmail.com> <20120420091449.GI27101@mwanda> <87vcku9sob.fsf@purkki.adurom.net> <20120421124523.GS6498@mwanda> <alpine.DEB.2.02.1204211548090.1987@hadrien>
 <20120421145140.GU6498@mwanda>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Sat, 21 Apr 2012, Dan Carpenter wrote:

> On Sat, Apr 21, 2012 at 03:51:44PM +0200, Julia Lawall wrote:
>> Looking for x = ... sizeof(x) ... I get 9 reports.  In most cases it
>> looks like sizeof(x) is coincidentally the same as the size that is
>> wanted.  Two cases that look like they could have some noticible
>> effect are:
>>
>> arch/xtensa/platforms/iss/network.c, line 789
>> drivers/block/cciss.c, line 4211
>>
>
> Clever.  You'd need to restrict it to places where x was a  pointer.

Yes, I didn't put the whole thing:

@r expression@
expression *x;
position p;
@@

x@p = <+... sizeof(x) ...+>

julia

> That's better than my check which was specific to kmalloc().  (So
> uh...  I'm going to rewrite mine as well to be more generic.  :P)
>
> regards,
> dan carpenter
>
>
