Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hofr.at ([212.69.189.236]:43332 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbbFNGTo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jun 2015 02:19:44 -0400
Date: Sun, 14 Jun 2015 08:19:41 +0200
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Nicholas Mc Guire <hofrat@osadl.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	Joe Perches <joe@perches.com>,
	Daniele Alessandrelli <daniele.alessandrelli@gmail.com>,
	Aleh Suprunovich <br@ahlamon.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG ?] staging: rtl8723au: condition with no effect
Message-ID: <20150614061941.GA27959@opentech.at> (sfid-20150614_081958_881243_0624757B)
References: <1434191497-5611-1-git-send-email-hofrat@osadl.org> <wrfjy4jn1dri.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <wrfjy4jn1dri.fsf@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 13 Jun 2015, Jes Sorensen wrote:

> Nicholas Mc Guire <hofrat@osadl.org> writes:
> > scanning for trivial bug-patters with coccinelle spatches returned:
> > ./drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c:1395
> > 	WARNING: condition with no effect (if branch == else)
> >
> > drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c - line numbers from 4.1-rc7
> > 1395    if (bWithoutHWSM) {
> > 1396            /* value16 |= (APDM_HOST | FSM_HSUS |/PFM_ALDN); */
> > 1397            /*  2010/08/31 According to Filen description, we need to
> > 1398                use HW to shut down 8051 automatically. */
> > 1399            /*  Because suspend operation need the asistance of 8051
> > 1400                to wait for 3ms. */
> > 1401            value16 = APDM_HOST | AFSM_HSUS | PFM_ALDN;
> > 1402    } else {
> > 1403            value16 = APDM_HOST | AFSM_HSUS | PFM_ALDN;
> > 1404    }
> > 1405 
> > 1406    rtl8723au_write16(padapter, REG_APS_FSMCO, value16);    /* 0x4802 */
> >
> > Not clear what the intent is but this looks like a typo/bug in the assigment
> > of value16 as the condition here has no effect.
> 
> Doesn't look like a typo, looks like someone at some point had commented
> out PFM_ALDN in the bWithoutHWSM case. Why they did that and then later
> overrode it, I have no idea.
>
as far as its traceable in git log if == else was in there from the
very beginning (including that comment) - both the if and else were
updated in commit cffca68d7b2f ("staging: rtl8723au: _DisableAnalog(): Avoid
zero-init variables unnecessaril") but without changing PFM_ALDN - as there
are no comments to the meaning of these bits in the header file there is
no way to really come up with a resonable patch. anyway its either wrong 
settings or the condition should be removed.

thx!
hofrat
