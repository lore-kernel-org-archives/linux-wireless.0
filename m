Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp01.msg.oleane.net ([62.161.4.1]:57826 "EHLO
	smtp01.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbaBFQit convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 11:38:49 -0500
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Felix Fietkau'" <nbd@openwrt.org>,
	<linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A3190173371A@sbs2003.acksys.local> <52F39F41.2010300@openwrt.org>
In-Reply-To: <52F39F41.2010300@openwrt.org>
Subject: RE: ATH9K software retry
Date: Thu, 6 Feb 2014 17:38:38 +0100
Message-ID: <009301cf2359$e35f0330$aa1d0990$@acksys.fr> (sfid-20140206_173907_697661_A1762952)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Message d'origine-----
> De : Felix Fietkau [mailto:nbd@openwrt.org]
> Envoyé : jeudi 6 février 2014 15:42
> À : Cedric VONCKEN; linux-wireless@vger.kernel.org
> Objet : Re: ATH9K software retry
> 
> On 2014-02-06 14:06, Cedric VONCKEN wrote:
> > In xmit.c the function ath_tx_complete_aggr test if the fi->retries <
> > ATH_MAX_SW_RETRIES.
> >
> > If this condition is true, ATH9K handle software retry.
> >
> > Minstrel set in the frame one or more rates, for each rate minstrel
> > set a retries count. I think is sufficient.
> >
> > Why ATH9K need to manage the software retries?
> The retries configured for minstrel_ht are used for hardware retries of
single
> frames and full A-MPDU transmissions. Software retries are used for
> individual subframes that are sent as part of A-MPDUs.
> This is required, because failed subframes are frequent with higher MCS
rates
> and A-MPDU.
> 
Is it possible to only applied software retrying for A-MPDU frame with more
one frame?
If I correctly understood the code, the function ath_tx_count_frames return
the number of frame in the A-MPDU. If nframes == 1 we don't use the software
retry.

> > With the test we have a minimal of 30 retries (ATH_MAX_SW_RETRIES is
> > set to 30).

Regards

Cedric Voncken

