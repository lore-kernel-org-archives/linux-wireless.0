Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0092.hostedemail.com ([216.40.44.92]:46972 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751060AbaJ0Fvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 01:51:39 -0400
Message-ID: <1414389096.15751.34.camel@perches.com> (sfid-20141027_065156_043194_64A7F4C3)
Subject: Re: [PATCH 2/2] staging: rtl8723au:core
From: Joe Perches <joe@perches.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Paul McQuade <paulmcquad@gmail.com>, linux-kernel@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Date: Sun, 26 Oct 2014 22:51:36 -0700
In-Reply-To: <wrfjegtucbgo.fsf@redhat.com>
References: <1414340332-4556-1-git-send-email-paulmcquad@gmail.com>
	 <1414350250.15751.22.camel@perches.com> <wrfjegtucbgo.fsf@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-27 at 06:45 +0100, Jes Sorensen wrote:
> Joe Perches <joe@perches.com> writes:
> > On Sun, 2014-10-26 at 16:18 +0000, Paul McQuade wrote:
> >> ERROR: spaces required around that ':' (ctx:VxE)
[]
> >> diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
[]
> >> @@ -794,28 +794,28 @@ u16 rtw_mcs_rate23a(u8 rf_type, u8 bw_40MHz, u8 short_GI_20, u8 short_GI_40,
> >>  
> >>  	if (rf_type == RF_1T1R) {
> >>  		if (mcs->rx_mask[0] & BIT(7))
> >> -			max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350):
> >> +			max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350) :
[]
> >
> > A macro could help intelligibility here - maybe something like:
> >
> > #define get_max_rate(r1, r2, r3, r4)					\
> > 	(bw_40MHz ? (short_GI_40 ? r1 : r2) : (short_GI_20 ? r3 : r4))
> > and:
> >  		if (mcs->rx_mask[0] & BIT(7))
> > 			max_rate = get_max_rate(1500, 1350, 722, 650);
> 
> Hiding a parameter to a macro like that is bad coding practice, so don't
> do that please!

Yes and no.

Adding the other 3 arguments to the macro doesn't help legibility.

Keeping the macro definition local to the place that it's used
can help avoid typos.


