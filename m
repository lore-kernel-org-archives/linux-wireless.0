Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46255 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab2BCF4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 00:56:31 -0500
Date: Fri, 3 Feb 2012 11:26:47 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@google.com>,
	Susinder Gulasekaran <susinder@qca.qualcomm.com>,
	Suresh Chandrasekaran <csuresh@qca.qualcomm.com>
Subject: Re: [PATCH 2/2] ath9k_hw: improve ANI processing and rx
 desensitizing parameters
Message-ID: <20120203055645.GA15811@vmraj-lnx.users.atheros.com> (sfid-20120203_065645_245274_C55526C2)
References: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1328112335-19265-2-git-send-email-rmanohar@qca.qualcomm.com>
 <CAJ-Vmon56yyyvU46oXBJaFpUcFWa0008S5tyBm31qTY5y2CO+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <CAJ-Vmon56yyyvU46oXBJaFpUcFWa0008S5tyBm31qTY5y2CO+g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 02, 2012 at 02:09:10PM -0800, Adrian Chadd wrote:
> Hi, questions below:
> 
> On 1 February 2012 08:05, Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:
> >
> > This patch improves ANI operations by switching among the immunity
> > levels based on PHY errors and beacon rssi which will adjust receiver
> > desensitizing parameters. The changes are
> 
> What environments are you seeing this bad behaviour in? I'd just like
> to be sure that this won't mess up the behaviour of ANI for other
> chips, other environments and other operating modes.
>
The actual test was done in AP mode in controlled environment with rx signal
level of -50 dBm and with interference of -45 dBm at STA side. In such scenario
beacon miss was observered and drastic hit in throughput at OFDM ani level 9 after
enabling the Weak signal detection. Not changing the any of weak signal detection
thresholds and retaining the ini values improved the throughput at higher ANI
levels.
> > * Irrespective of opmode, the Weak Signal Detection is with the current
> >  immunity level value.
> 
Again with AP mode enabling/disabling the Weak signal detection is not working.
It was verified from the register (use_self_corr_low). So that it will
configure the WSD with current ofdm immunity level, if there is mismatch b/w
configured WSD state and selected immunity level's WSD state.

> I didn't think that weak signal detection was a single bit in the PHY.
> It looks like you've just deleted all the threshold settings and are
> turning on/off using low self correlation.
>
As menstion above, the thresh values are continue to retain the init values.
Based on the test results, it is enough to update use_self_corr_low state.

> Have a read of the (very early, AR5212 era?) ANI patent:
> 
> http://www.freepatentsonline.com/7349503.pdf
> 
> If this has changed (ie, if in Osprey it's done differently) then it
> should likely be documented in the driver somewhere.
> 
> IF this all works then great, but I'd really like to try and better
> understand/document the "why" aspects of it. ANI is .. fiddly, and
> there aren't any tools available for ath9k (+freebsd) wireless
> developers to really understand the impact of ANI.
>
--
Rajkumar
