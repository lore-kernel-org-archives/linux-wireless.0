Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:48612 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760182Ab2FVL6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 07:58:16 -0400
Date: Fri, 22 Jun 2012 14:57:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] ath9k_hw: fix smatch warnings in spur_mitigate
Message-ID: <20120622115747.GE5390@mwanda> (sfid-20120622_135818_445205_CB6BF144)
References: <1340303492-30947-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1340303492-30947-3-git-send-email-rmanohar@qca.qualcomm.com>
 <87bokb4xof.fsf@purkki.adurom.net>
 <20120622092226.GA7934@vmraj-lnx.users.atheros.com>
 <877guz4lm9.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <877guz4lm9.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 22, 2012 at 02:44:14PM +0300, Kalle Valo wrote:
> Rajkumar Manoharan <rmanohar@qca.qualcomm.com> writes:
> 
> >> > -			qCoff = qCoff & 0x7f;
> >> > +			qCoff &= 0x7f;
> >> 
> >> I'm curious, how does a change like this fix anything? To me it just
> >> looks same functionality, just a different operator is used. Am I
> >> missing something?
> >
> > Though it doesn't make a difference, somehow it fixes smatch warning.
> > I agree it is not the right fix.
> 
> Ok, maybe it's just that smatch isn't clever enough with the &= operator.
> Dan?

Ugh...  I think it's debugging code that leaked into the wild.  I
will remove that.

regards,
dan carpenter

