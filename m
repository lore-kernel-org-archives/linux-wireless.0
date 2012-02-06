Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8825 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2BFHJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 02:09:55 -0500
Date: Mon, 6 Feb 2012 12:40:14 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@google.com>,
	Susinder Gulasekaran <susinder@qca.qualcomm.com>,
	Suresh Chandrasekaran <csuresh@qca.qualcomm.com>
Subject: Re: [PATCH 2/2] ath9k_hw: improve ANI processing and rx
 desensitizing parameters
Message-ID: <20120206071012.GA6534@vmraj-lnx.users.atheros.com> (sfid-20120206_080959_980068_693CD667)
References: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1328112335-19265-2-git-send-email-rmanohar@qca.qualcomm.com>
 <CAJ-Vmon56yyyvU46oXBJaFpUcFWa0008S5tyBm31qTY5y2CO+g@mail.gmail.com>
 <20120203055645.GA15811@vmraj-lnx.users.atheros.com>
 <CAJ-Vmo=AXrnPAbvbfSAco8xkUQWKFLGMWKEYHMq-FsxsmqBbFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAJ-Vmo=AXrnPAbvbfSAco8xkUQWKFLGMWKEYHMq-FsxsmqBbFA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 04, 2012 at 02:28:30AM -0800, Adrian Chadd wrote:
> My point is that "use self corr low" isn't exactly and only "weak
> signal detection". My understanding is there's a whole heap of various
> PHY twiddles that set thresholds in the OFDM/CCK decoder.
> Disabling weak detection involves setting those thresholds high so
> they don't trigger on weak signals.
> 
> I'd like to suggest we hold off on committing anything that really
> changes the ANI behaviour without figuring out exactly what's going on
> underneath the hood. I think it's worthwhile filing a bugzilla report
> and stuffing that patch against the bug though, so it's not "lost".
> 
> I can get some further information next week by paying the
> baseband/radio guys a visit. I'll see if we can figure out what's
> going on and why your ANI changes improve in that specific
> environment.
> 
> (As a side note - it'd be nice to eliminate more 'stuck beacon' issues
> that relate to the radio side of things.)
> 
Adrian,

To be very precise, there are two types of weak signal detection logic in our
baseband -

1) normal weak signal detection logic - involves thresholds m1_thresh,
   m2_thresh, m2_Count_thr
2) low weak signal detection logic - involves thresholds m1_thresh_low,
   m2_thresh_low, m2_count_thr_low

Type 2 is intended to handle low weak signals and internally baseband logic does
averaging over larger time windows compared to type 1. In current ANI code,
both types 1) and 2) are clubbed together and called as "weak signal detection".

What we've found in extensive testing is that disabling type 1 and type 2 form of
weak signal detection logic together causes "beacon miss". Disabling both types
1 and type 2 together is definitely harmful to our receiver as it cannot receive
even medium strength signals. Disabling type 2 alone is completely safe which
is what we're doing in this change.  

For disabling type 2 logic alone there is a register field named
"use_self_corr_low". So instead of maxing out threshold values of 3-4 registers
we simply set use_self_corr_low=0 saving register writes. Hepe this could
clarify your question.

--
Rajkumar
