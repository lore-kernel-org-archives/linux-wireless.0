Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:59002 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab2K0MqA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 07:46:00 -0500
Message-ID: <1354020320.950.84.camel@cumari.coelho.fi> (sfid-20121127_134603_988498_18C73EFD)
Subject: Re: [PATCH 03/20] wlcore: Allow memory access when the FW crashes
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>, Ido Yariv <ido@wizery.com>
Date: Tue, 27 Nov 2012 14:45:20 +0200
In-Reply-To: <CA+XVXfexJew14BSu79JC2OPnQMiEaw6--bOwwbDDCkr=wQMy4w@mail.gmail.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
	 <1353998701-18171-4-git-send-email-arik@wizery.com>
	 <1354008888.950.62.camel@cumari.coelho.fi>
	 <CA+XVXfexJew14BSu79JC2OPnQMiEaw6--bOwwbDDCkr=wQMy4w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 13:54 +0200, Arik Nemtsov wrote:
> On Tue, Nov 27, 2012 at 11:34 AM, Luciano Coelho <coelho@ti.com> wrote:
> > On Tue, 2012-11-27 at 08:44 +0200, Arik Nemtsov wrote:
> >> From: Ido Yariv <ido@wizery.com>
> >>
> >> When the no_recovery flag is used, the recovery work will not restart
> >> the FW and the state will not be set to 'on'. To enable post-mortem
> >> analysis, allow memory access in the 'restarting' state.
> >>
> >> Also, since the FW might not be operational, don't fail the read/write
> >> operations if elp_wakeup fails.
> >>
> >> Reported-by: Arkady Miasnikov <a-miasnikov@ti.com>
> >> Signed-off-by: Ido Yariv <ido@wizery.com>
> >> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> >> ---
> >
> > This is weird.  This patch is already in (d5560238) and the one here is
> > actually just part of it and probably won't apply.
> 
> Heh. It seems Eliad and I are to blame (all the rebases can really
> mess with the mind).

Yeah, all these internal rebases suck.


> There's a patch by Eliad to reverse the patch you just mentioned:
> 
> commit fd8e73af670e6b57708eafe927f5d0364018b4e5
> Author: Eliad Peller <eliad@wizery.com>
> Date:   Wed Nov 14 02:28:26 2012 +0200
> 
>     wlcore: don't allow access to FW mem when chip is off
> 
> (which I submitted earlier in my part 1 series)
> 
> And the current patch simply cancels it out. So please ignore the
> previous patch as well as this one. Good catch :)

Okay, I'll ignore this one and Eliad's in the previous series.

--
Luca.

