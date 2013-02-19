Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39571 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789Ab3BSRUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 12:20:35 -0500
Received: by mail-wi0-f174.google.com with SMTP id hi8so5111685wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Feb 2013 09:20:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1302192034420.7450@icf.org.ru>
References: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru>
	<20130219134028.GA26332@pandem0nium>
	<alpine.DEB.2.02.1302191752110.31254@icf.org.ru>
	<CAJ-VmomPkPvABSJtdb6Y=fDNxyd_XtE6sk9yWQzw9qC7rjkwiA@mail.gmail.com>
	<alpine.DEB.2.02.1302192034420.7450@icf.org.ru>
Date: Tue, 19 Feb 2013 09:20:33 -0800
Message-ID: <CAJ-VmokUJtowcO0AWpyFLoLN0R0KowETb1BOyjN66rzPSDhjOQ@mail.gmail.com> (sfid-20130219_182038_331167_C1DB3585)
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
From: Adrian Chadd <adrian@freebsd.org>
To: Georgiewskiy Yuriy <bottleman@icf.org.ru>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What's _supposed_ to happen on channel change is this:

* There's supposed to be an initial set of calibrations done, including NF;
* the time-adjusted noise floor history for that channel is written out;
* The last set ANI parameters for that channel are written out.

The theory being that the NF and ANI results for a channel are channel
specific and not global.

_However_ this may or may not be correct or working correctly. ANI
doesn't run for long enough during a channel scan to properly figure
out channel conditions. But on a very noisy channel, you may need some
specifically detuned parameters in order to receive successfully.

This is why I was kinda hoping someone would step up and write some
PHY visualisation tools. :-) There's plenty of counters from the
Atheros MAC and PHY hardware; they just need to be logged and graphed!



adrian
