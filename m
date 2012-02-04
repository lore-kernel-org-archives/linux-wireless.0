Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46127 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2BDK2b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Feb 2012 05:28:31 -0500
Received: by vcge1 with SMTP id e1so3115473vcg.19
        for <linux-wireless@vger.kernel.org>; Sat, 04 Feb 2012 02:28:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120203055645.GA15811@vmraj-lnx.users.atheros.com>
References: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com>
	<1328112335-19265-2-git-send-email-rmanohar@qca.qualcomm.com>
	<CAJ-Vmon56yyyvU46oXBJaFpUcFWa0008S5tyBm31qTY5y2CO+g@mail.gmail.com>
	<20120203055645.GA15811@vmraj-lnx.users.atheros.com>
Date: Sat, 4 Feb 2012 02:28:30 -0800
Message-ID: <CAJ-Vmo=AXrnPAbvbfSAco8xkUQWKFLGMWKEYHMq-FsxsmqBbFA@mail.gmail.com> (sfid-20120204_112835_031395_2837D353)
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

My point is that "use self corr low" isn't exactly and only "weak
signal detection". My understanding is there's a whole heap of various
PHY twiddles that set thresholds in the OFDM/CCK decoder.
Disabling weak detection involves setting those thresholds high so
they don't trigger on weak signals.

I'd like to suggest we hold off on committing anything that really
changes the ANI behaviour without figuring out exactly what's going on
underneath the hood. I think it's worthwhile filing a bugzilla report
and stuffing that patch against the bug though, so it's not "lost".

I can get some further information next week by paying the
baseband/radio guys a visit. I'll see if we can figure out what's
going on and why your ANI changes improve in that specific
environment.

(As a side note - it'd be nice to eliminate more 'stuck beacon' issues
that relate to the radio side of things.)


Adrian
