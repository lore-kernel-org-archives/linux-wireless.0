Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58213 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaEWOpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 10:45:12 -0400
Date: Fri, 23 May 2014 10:40:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Kalle Valo <kvalo@adurom.com>, linux-wireless@vger.kernel.org,
	jim.epost@gmail.com
Subject: Re: [PATCH] ath9k: fix build error with disabled debug
Message-ID: <20140523144058.GB13311@tuxdriver.com> (sfid-20140523_164518_435744_8C5CA483)
References: <1400668835-22335-1-git-send-email-zefir.kurtisi@neratec.com>
 <877g5e3qfg.fsf@purkki.adurom.net>
 <537F038C.7050305@neratec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <537F038C.7050305@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 23, 2014 at 10:15:08AM +0200, Zefir Kurtisi wrote:
> On 05/22/2014 03:15 PM, Kalle Valo wrote:
> > Zefir Kurtisi <zefir.kurtisi@neratec.com> writes:
> > 
> >> DFS pulse interval printing is only available
> >> when CONFIG_ATH9K_DEBUGFS is set.
> >>
> >> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
> > 
> > [...]
> > 
> >> --- a/drivers/net/wireless/ath/ath9k/dfs.c
> >> +++ b/drivers/net/wireless/ath/ath9k/dfs.c
> >> @@ -178,12 +178,14 @@ void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
> >>  	pe.ts = mactime;
> >>  	if (ath9k_postprocess_radar_event(sc, &ard, &pe)) {
> >>  		struct dfs_pattern_detector *pd = sc->dfs_detector;
> >> +#ifdef CONFIG_ATH9K_DEBUGFS
> > 
> > IMHO config_enabled() is much nicer than ifdef.
> > 
> 
> Actually, I dislike both of them.
> 
> While this is for debug printing only, it is still a bad idea to use variables in
> debugfs dependent space and splatter source code with required checks. I'll move
> that into a different context and post a follow-up patch.
> 
> 
> John, please drop this one.

Actually, I merged it yesterday.  Please submit your follow-up patch
on top of this one.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
