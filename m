Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:41411 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752980AbZBXRHW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 12:07:22 -0500
Date: Tue, 24 Feb 2009 19:07:10 +0200
From: Jouni Malinen <j@w1.fi>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Add module parameter to disable hardware crypto
Message-ID: <20090224170710.GA7246@jm.kir.nu> (sfid-20090224_180725_965319_F1D3F128)
References: <20090224114201.GB21933@jm.kir.nu> <200902241715.49803.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200902241715.49803.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 24, 2009 at 05:15:49PM +0100, Michael Buesch wrote:
> On Tuesday 24 February 2009 12:42:01 Jouni Malinen wrote:
> >  #define CHAN2G(_freq, _idx)  { \
> > @@ -1587,7 +1591,7 @@ int ath_attach(u16 devid, struct ath_sof
> >  		IEEE80211_HW_SUPPORTS_PS |
> >  		IEEE80211_HW_PS_NULLFUNC_STACK;
> >  
> > -	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah))
> > +	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah) || modparam_nohwcrypt)
> >  		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
> 
> Are you sure this is correct?

I have no reason to believe otherwise.

> The hardware capability doesn't magically change by switching a modparam.

Of course not.

> Either the HW is MFP capable or it isn't.

It is not that simple. Hardware is MFP capable with software
encryption/decryption in all cases; it just may not work correctly if
hardware acceleration is used with older hardware revisions.

> If hwcrypto is disabled (set_key returns error), mac80211 should be smart
> enough to do crypto (including MFP) in software anyway.

Yes and that is exactly what the patch is doing.. If nohwcrypt=1,
mac80211 takes care of crypto and MFP can be used. If nohwcrypt=0, MFP
is disabled for older hardware revisions (but enabled for new ones that
handle MFP without issues in hw crypto).

-- 
Jouni Malinen                                            PGP id EFC895FA
