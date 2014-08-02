Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0093.hostedemail.com ([216.40.44.93]:58335 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750782AbaHBG7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2014 02:59:42 -0400
Message-ID: <1406962776.1835.3.camel@joe-AO725> (sfid-20140802_090049_224382_F2C95DE8)
Subject: Re: [PATCH] ath10k: fix wmi service bitmap debug
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Fri, 01 Aug 2014 23:59:36 -0700
In-Reply-To: <87k36r5ra2.fsf@kamboji.qca.qualcomm.com>
References: <1406628239-31322-1-git-send-email-michal.kazior@tieto.com>
	 <87k36r5ra2.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-08-02 at 09:39 +0300, Kalle Valo wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
> 
> > The 10.x and main firmware branches have
> > conflicting WMI service bitmap definitions.
> >
> > This also fixes WMI services parsing on big-endian
> > hosts and changes debugfs output to be more human
> > friendly.
> >
> > Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> 
> [...]
> 
> > +	SVCSTR(WMI_SERVICE_TX_ENCAP)
> > +	SVCSTR(WMI_SERVICE_BURST)
> > +	SVCSTR(WMI_SERVICE_SMART_ANTENNA_SW_SUPPORT)
> > +	SVCSTR(WMI_SERVICE_SMART_ANTENNA_HW_SUPPORT)
> >  	default:
> > -		return "UNKNOWN SERVICE\n";
> > +		return NULL;
> 
> This introduces a new checkpatch warning:
> 
> drivers/net/wireless/ath/ath10k/wmi.h:214: ERROR: spaces required around that ':' (ctx:VxE)
> 
> But I think that's just a false warning and I should ignore it. Any
> other ideas?

I don't get a warning with this patch.

What's the last git commit id of the checkpatch version
you used?

$ ./scripts/checkpatch.pl --strict ath10k.diff  
total: 0 errors, 0 warnings, 0 checks, 471 lines checked


