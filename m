Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:59034 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752550Ab1LOHhf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 02:37:35 -0500
Received: by lagu2 with SMTP id u2so822911lag.9
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 23:37:31 -0800 (PST)
Subject: Re: [PATCH] wl12xx: Restore testmode ABI
From: Luciano Coelho <coelho@ti.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <87y5uwfsce.fsf@purkki.adurom.net>
References: <1322738024-16626-1-git-send-email-pontus.fuchs@gmail.com>
	 <87y5uwfsce.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 09:37:27 +0200
Message-ID: <1323934647.2800.176.camel@cumari> (sfid-20111215_083738_165334_2F0F5305)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Thu, 2011-12-01 at 13:23 +0200, Kalle Valo wrote: 
> Pontus Fuchs <pontus.fuchs@gmail.com> writes:
> 
> > Commit 80900d0140a7648587982c8f299830e900e49165 accidently broke
> > the ABI for testmode commands. Restore the ABI again.
> >
> 
> [...]
> 
> > --- a/drivers/net/wireless/wl12xx/testmode.c
> > +++ b/drivers/net/wireless/wl12xx/testmode.c
> > @@ -37,6 +37,7 @@ enum wl1271_tm_commands {
> >  	WL1271_TM_CMD_TEST,
> >  	WL1271_TM_CMD_INTERROGATE,
> >  	WL1271_TM_CMD_CONFIGURE,
> > +	WL1271_TM_CMD_NVS_PUSH,		/* Not in use. Keep to not break ABI */
> 
> Better to call it WL1271_TM_CMD_UNUSED1, or something like that, so that
> it really stays unused.

As we discussed briefly on IRC, I think it's a better idea to keep it as
is.  If anyone still uses it (despite the comment saying it's not in
use), we will return -EOPNOTSUPP.

-- 
Cheers,
Luca.

