Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57168 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758634Ab2FVJVM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 05:21:12 -0400
Date: Fri, 22 Jun 2012 14:52:28 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Kalle Valo <kvalo@adurom.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/3] ath9k_hw: fix smatch warnings in spur_mitigate
Message-ID: <20120622092226.GA7934@vmraj-lnx.users.atheros.com> (sfid-20120622_112118_681469_AD92A0B6)
References: <1340303492-30947-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1340303492-30947-3-git-send-email-rmanohar@qca.qualcomm.com>
 <87bokb4xof.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87bokb4xof.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 22, 2012 at 10:23:44AM +0300, Kalle Valo wrote:
> Rajkumar Manoharan <rmanohar@qca.qualcomm.com> writes:
> 
> > This patch fixes below smatch warnings
> >
> > drivers/net/wireless/ath/ath9k/ar9003_calib.c:272
> > ar9003_hw_iqcalibrate() Error invalid range 65 to 63
> >
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> 
> [...]
> 
> > -			qCoff = qCoff & 0x7f;
> > +			qCoff &= 0x7f;
> 
> I'm curious, how does a change like this fix anything? To me it just
> looks same functionality, just a different operator is used. Am I
> missing something?

Though it doesn't make a difference, somehow it fixes smatch warning.
I agree it is not the right fix.

I just found the actual issue here that the min and max limitation
are checked before masking out the value.

   if (qCoff >= 63)
           qCoff = 63;
   else if (qCoff <= -63)
           qCoff = -63;

Later it is masked out with 0x7f.

-63 & 0x7f = 65 which is greater than the max limit 63.

Thats why smatch is throwing warning "Error invalid range 65 to 63".

-Rajkumar 
