Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52880 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758722Ab2BJAzI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 19:55:08 -0500
Received: by wgbdt10 with SMTP id dt10so2255178wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 16:55:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmokAdqKMMsrHpuj1fo-Y7c96DCq2NbFGiRGMAsGaw6Na5w@mail.gmail.com>
References: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com>
	<1328112335-19265-2-git-send-email-rmanohar@qca.qualcomm.com>
	<CAJ-Vmon56yyyvU46oXBJaFpUcFWa0008S5tyBm31qTY5y2CO+g@mail.gmail.com>
	<20120203055645.GA15811@vmraj-lnx.users.atheros.com>
	<CAJ-Vmo=AXrnPAbvbfSAco8xkUQWKFLGMWKEYHMq-FsxsmqBbFA@mail.gmail.com>
	<20120206071012.GA6534@vmraj-lnx.users.atheros.com>
	<CAJ-VmokAdqKMMsrHpuj1fo-Y7c96DCq2NbFGiRGMAsGaw6Na5w@mail.gmail.com>
Date: Thu, 9 Feb 2012 16:55:06 -0800
Message-ID: <CAJ-Vmomw=1FCOidVqnRbUa-9PXHorTjriinWf+TXSUjc5y-GBA@mail.gmail.com> (sfid-20120210_015513_669504_E6C40DAA)
Subject: Re: [PATCH 2/2] ath9k_hw: improve ANI processing and rx desensitizing parameters
From: Adrian Chadd <adrian@freebsd.org>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Paul Stewart <pstew@google.com>,
	Susinder Gulasekaran <susinder@qca.qualcomm.com>,
	Suresh Chandrasekaran <csuresh@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've done some digging here. Yes, you're right, the big clobber isn't
the right solution.

What I've been told is:

* with such a strong blocker and a weak signal (~ 5dB maximum above
blocker) that the strong signal detection logic won't fire;
* and if weak signal detection is disabled entirely as it's done at
the moment, you will likely decode very little.

So the solution of disabling sfcorr_low is right (as that's supposed
to be for super-low signals and in the presence of such a blocker, it
won't ever help) and leaving the first level low threshold detection
is "right".

I still can't help but wonder if there's a situation where the big
"disable" is needed.

Eg, in the presence of a very strong signal (ie, where strong signal
detection will fire) but a weak blocker; you may wish to disable both
so you don't end up with high levels of spurious weak signal
detections and possibly OFDM restarts (ie, the hardware would then
detect an increase in power during a weak OFDM frame decode -> OFDM
restart.)

So how about we treat this as an excuse to turn OFDM weak signal
detection into three levels - entirely on, disable low weak detect,
disable medium weak detect - and see if this is enough. I'd like to
not break things for existing users where the "big thunk" is good
enough.

What do you think?


Adrian
