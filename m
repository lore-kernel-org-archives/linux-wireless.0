Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:47965 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab2FVL4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 07:56:36 -0400
Date: Fri, 22 Jun 2012 14:55:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH 3/3] ath9k: fix 'side effect in macro' smatch warning
Message-ID: <20120622115559.GD5390@mwanda> (sfid-20120622_135639_607991_DE24F820)
References: <1340303492-30947-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1340303492-30947-4-git-send-email-rmanohar@qca.qualcomm.com>
 <87ipej4xz0.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87ipej4xz0.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 22, 2012 at 10:17:23AM +0300, Kalle Valo wrote:
> Rajkumar Manoharan <rmanohar@qca.qualcomm.com> writes:
> 
> > ath9k_get_et_stats() warn: side effect in macro
> > 'AWDATA' doing 'i++'
> >
> > Cc: Ben Greear <greearb@candelatech.com>
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> 
> [...]
> 
> >  	do {								\
> > -		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BE)].elem; \
> > -		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BK)].elem; \
> > -		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VI)].elem; \
> > -		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VO)].elem; \
> > +		data[i+0] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BE)].elem; \
> > +		data[i+1] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BK)].elem; \
> > +		data[i+2] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VI)].elem; \
> > +		data[i+3] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VO)].elem; \
> > +		i += 4; \
> >  	} while (0)
> 
> I agree with Ben, this is a useless change as the end result is still
> the same (the side effect is that i is increased with four). You are
> just hiding that from smatch and once smatch is fixed it will warn again
> about the same thing.
> 
> I recommend fixing this properly so that the macro doesn't have any side
> effects.

Uh.  Sorry, also I thought I had pushed a fix to add this to the
ignored macro list, but I forgot.  I've pushed it now.

I don't think this check has ever found a bug.  These bugs are very
rare and we are careful about macro side effects in the kernel.  I
have disabled the check by default and it's only enabled when you
pass --spammy.  I told the Ruby people I was going to do this
earlier in the week but I've been out of the office and delayed.

regards,
dan carpenter

