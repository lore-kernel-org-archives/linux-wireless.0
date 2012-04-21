Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:20926 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2DUO5r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2012 10:57:47 -0400
Date: Sat, 21 Apr 2012 17:59:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Kalle Valo <kvalo@adurom.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] wireless: at76c50x: allocating too much data
Message-ID: <20120421145952.GL27101@mwanda> (sfid-20120421_165752_513893_6F799D06)
References: <20120420064705.GE22649@elgon.mountain>
 <CAGRGNgVgtAYknmpB_8Q0OpcUWFjTxBistG+RNs1ORDZeckGsWw@mail.gmail.com>
 <20120420091449.GI27101@mwanda>
 <87vcku9sob.fsf@purkki.adurom.net>
 <20120421124523.GS6498@mwanda>
 <alpine.DEB.2.02.1204211548090.1987@hadrien>
 <20120421145140.GU6498@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120421145140.GU6498@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 21, 2012 at 05:51:41PM +0300, Dan Carpenter wrote:
> On Sat, Apr 21, 2012 at 03:51:44PM +0200, Julia Lawall wrote:
> > Looking for x = ... sizeof(x) ... I get 9 reports.  In most cases it
> > looks like sizeof(x) is coincidentally the same as the size that is
> > wanted.  Two cases that look like they could have some noticible
> > effect are:
> > 
> > arch/xtensa/platforms/iss/network.c, line 789
> > drivers/block/cciss.c, line 4211
> > 
> 
> Clever.  You'd need to restrict it to places where x was a  pointer.
> That's better than my check which was specific to kmalloc().  (So
> uh...  I'm going to rewrite mine as well to be more generic.  :P)
> 

The other thing would be to look for places that do:
	func(x, sizeof(x);

Of course, you've found a lot of memset()/memcpy() bugs like that in
the past, but probably it could be made more generic so it checks
every function.

regards,
dan carpenter

