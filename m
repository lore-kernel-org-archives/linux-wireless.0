Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:55402 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933152Ab3BSSbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 13:31:22 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20771.50338.434076.484711@gargle.gargle.HOWL> (sfid-20130219_193126_375628_72143122)
Date: Tue, 19 Feb 2013 23:59:54 +0530
To: Adrian Chadd <adrian@freebsd.org>
Cc: Georgiewskiy Yuriy <bottleman@icf.org.ru>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
In-Reply-To: <CAJ-VmokUJtowcO0AWpyFLoLN0R0KowETb1BOyjN66rzPSDhjOQ@mail.gmail.com>
References: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru>
	<20130219134028.GA26332@pandem0nium>
	<alpine.DEB.2.02.1302191752110.31254@icf.org.ru>
	<CAJ-VmomPkPvABSJtdb6Y=fDNxyd_XtE6sk9yWQzw9qC7rjkwiA@mail.gmail.com>
	<alpine.DEB.2.02.1302192034420.7450@icf.org.ru>
	<CAJ-VmokUJtowcO0AWpyFLoLN0R0KowETb1BOyjN66rzPSDhjOQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd wrote:
> What's _supposed_ to happen on channel change is this:
> 
> * There's supposed to be an initial set of calibrations done, including NF;
> * the time-adjusted noise floor history for that channel is written out;
> * The last set ANI parameters for that channel are written out.
> 
> The theory being that the NF and ANI results for a channel are channel
> specific and not global.
> 
> _However_ this may or may not be correct or working correctly. ANI
> doesn't run for long enough during a channel scan to properly figure
> out channel conditions. But on a very noisy channel, you may need some
> specifically detuned parameters in order to receive successfully.

I think there are bugs in the NF calibration code in ath9k. I see
wild fluctuations in the signal level before and after nfcal happens, and
this happens in all the chips I tested - AR9285, AR9485, AR9565. Since
nfcal is triggered as part of the ANI calibration routine, this would cause
issues.

Sujith
