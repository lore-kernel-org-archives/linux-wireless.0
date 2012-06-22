Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:29880 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab2FVOcw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 10:32:52 -0400
Date: Fri, 22 Jun 2012 17:32:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Kalle Valo <kvalo@adurom.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] ath9k: fix 'side effect in macro' smatch warning
Message-ID: <20120622143218.GH5390@mwanda> (sfid-20120622_163257_452122_5F83C798)
References: <1340303492-30947-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1340303492-30947-4-git-send-email-rmanohar@qca.qualcomm.com>
 <87ipej4xz0.fsf@purkki.adurom.net>
 <20120622115559.GD5390@mwanda>
 <4FE48036.1020708@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FE48036.1020708@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 22, 2012 at 07:24:54AM -0700, Ben Greear wrote:
> On 06/22/2012 04:55 AM, Dan Carpenter wrote:
> >On Fri, Jun 22, 2012 at 10:17:23AM +0300, Kalle Valo wrote:
> >>Rajkumar Manoharan<rmanohar@qca.qualcomm.com>  writes:
> >>
> >>>ath9k_get_et_stats() warn: side effect in macro
> >>>'AWDATA' doing 'i++'
> >>>
> >>>Cc: Ben Greear<greearb@candelatech.com>
> >>>Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
> >>
> >>[...]
> >>
> >>>  	do {								\
> >>>-		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BE)].elem; \
> >>>-		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BK)].elem; \
> >>>-		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VI)].elem; \
> >>>-		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VO)].elem; \
> >>>+		data[i+0] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BE)].elem; \
> >>>+		data[i+1] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BK)].elem; \
> >>>+		data[i+2] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VI)].elem; \
> >>>+		data[i+3] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VO)].elem; \
> >>>+		i += 4; \
> >>>  	} while (0)
> >>
> >>I agree with Ben, this is a useless change as the end result is still
> >>the same (the side effect is that i is increased with four). You are
> >>just hiding that from smatch and once smatch is fixed it will warn again
> >>about the same thing.
> >>
> >>I recommend fixing this properly so that the macro doesn't have any side
> >>effects.
> >
> >Uh.  Sorry, also I thought I had pushed a fix to add this to the
> >ignored macro list, but I forgot.  I've pushed it now.
> 
> The whole point of the macro is to have an affect.  This is not a general
> purpose macro..it's very specific to this local logic.
> 
> I don't think folks should be so dogmatic about these sorts of things.
> 

Right.  I have a list of macros which are expected to have side
effects but this one was only merged into linux-next recently and
had not been added to my list.

regards,
dan carpenter

