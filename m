Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbbFMVsD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2015 17:48:03 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	Joe Perches <joe@perches.com>,
	Daniele Alessandrelli <daniele.alessandrelli@gmail.com>,
	Aleh Suprunovich <br@ahlamon.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG ?] staging: rtl8723au: condition with no effect
References: <1434191497-5611-1-git-send-email-hofrat@osadl.org>
Date: Sat, 13 Jun 2015 17:48:01 -0400
In-Reply-To: <1434191497-5611-1-git-send-email-hofrat@osadl.org> (Nicholas Mc
	Guire's message of "Sat, 13 Jun 2015 12:31:37 +0200")
Message-ID: <wrfjy4jn1dri.fsf@redhat.com> (sfid-20150613_234811_800177_C1B4F54C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nicholas Mc Guire <hofrat@osadl.org> writes:
> scanning for trivial bug-patters with coccinelle spatches returned:
> ./drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c:1395
> 	WARNING: condition with no effect (if branch == else)
>
> drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c - line numbers from 4.1-rc7
> 1395    if (bWithoutHWSM) {
> 1396            /* value16 |= (APDM_HOST | FSM_HSUS |/PFM_ALDN); */
> 1397            /*  2010/08/31 According to Filen description, we need to
> 1398                use HW to shut down 8051 automatically. */
> 1399            /*  Because suspend operation need the asistance of 8051
> 1400                to wait for 3ms. */
> 1401            value16 = APDM_HOST | AFSM_HSUS | PFM_ALDN;
> 1402    } else {
> 1403            value16 = APDM_HOST | AFSM_HSUS | PFM_ALDN;
> 1404    }
> 1405 
> 1406    rtl8723au_write16(padapter, REG_APS_FSMCO, value16);    /* 0x4802 */
>
> Not clear what the intent is but this looks like a typo/bug in the assigment
> of value16 as the condition here has no effect.

Doesn't look like a typo, looks like someone at some point had commented
out PFM_ALDN in the bWithoutHWSM case. Why they did that and then later
overrode it, I have no idea.

Jes


