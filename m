Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:51120 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab1FVG7P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 02:59:15 -0400
Date: Wed, 22 Jun 2011 07:02:12 +0000
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, mb@bu3sch.de,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ssb: fix ssb clock rate according to broadcom source
Message-ID: <20110622070212.076777c0@Nokia-N900> (sfid-20110622_085918_161722_E601748F)
In-Reply-To: <4E010EE6.9060605@lwfinger.net>
References: <1308681113-4706-1-git-send-email-hauke@hauke-m.de>
	<1308682400-25953-1-git-send-email-hauke@hauke-m.de>
	<4E010EE6.9060605@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 21 Jun 2011 16:36:38 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> On 06/21/2011 01:53 PM, Hauke Mehrtens wrote:
> > This fix was done according to si_clock_rate function in broadcom siutils.c
> >
> > Signed-off-by: Hauke Mehrtens<hauke@hauke-m.de>
> > ---
> >   drivers/ssb/main.c |    4 ++--
> >   1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
> > index e568664..57b7b64 100644
> > --- a/drivers/ssb/main.c
> > +++ b/drivers/ssb/main.c
> > @@ -1002,8 +1002,8 @@ u32 ssb_calc_clock_rate(u32 plltype, u32 n, u32 m)
> >   	switch (plltype) {
> >   	case SSB_PLLTYPE_6: /* 100/200 or 120/240 only */
> >   		if (m&  SSB_CHIPCO_CLK_T6_MMASK)
> > -			return SSB_CHIPCO_CLK_T6_M0;
> > -		return SSB_CHIPCO_CLK_T6_M1;
> > +			return SSB_CHIPCO_CLK_T6_M1;
> > +		return SSB_CHIPCO_CLK_T6_M0;
> >   	case SSB_PLLTYPE_1: /* 48Mhz base, 3 dividers */
> >   	case SSB_PLLTYPE_3: /* 25Mhz, 2 dividers */
> >   	case SSB_PLLTYPE_4: /* 48Mhz, 4 dividers */
> 
> This patch sent me looking to find the public source for this routine. After 
> finding it in the source section of Broadcom-wl, I noticed there is some 
> additional code that is not implemented in the ssb version. Should this 
> additional material be implemented, or is it not applicable?

could you quote that function here? That would be way easier to get what were talking about.

