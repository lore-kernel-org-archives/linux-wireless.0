Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:50820 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab2DUMnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2012 08:43:04 -0400
Date: Sat, 21 Apr 2012 15:45:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] wireless: at76c50x: allocating too much data
Message-ID: <20120421124523.GS6498@mwanda> (sfid-20120421_144309_032325_BCC732AF)
References: <20120420064705.GE22649@elgon.mountain>
 <CAGRGNgVgtAYknmpB_8Q0OpcUWFjTxBistG+RNs1ORDZeckGsWw@mail.gmail.com>
 <20120420091449.GI27101@mwanda>
 <87vcku9sob.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <87vcku9sob.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 20, 2012 at 09:14:44PM +0300, Kalle Valo wrote:
> Dan Carpenter <dan.carpenter@oracle.com> writes:
> 
> > On Fri, Apr 20, 2012 at 06:57:00PM +1000, Julian Calaby wrote:
> >> > -       struct mib_local *m = kmalloc(sizeof(struct mib_phy), GFP_KERNEL);
> >> > +       struct mib_local *m = kmalloc(sizeof(struct mib_local), GFP_KERNEL);
> >> 
> >> Would it be better practice to use sizeof(*m)?
> >> 
> >
> > That was my temptation as well...  But I decided to make it match
> > with the surrounding code.  I'm happy to resend if people want.
> 
> IMHO sizeof(*m) is better and I tend to use it.
> 
> Related to this: I have a bad habit of sometimes dropping '*' from
> sizeof()? Is there a tool which could spot that?
> 

That's what I was working on for Smatch when I sent this patch.

The odd thing is that I can't find any bugs like this in the kernel.
If sizeof(foo) is less than sizeof(*foo), which is probably the
normal case, then these get caught early on in testing.

Still I think people must have done manual audits as well...  It
feels too clean to be natural.

regards,
dan carpenter
