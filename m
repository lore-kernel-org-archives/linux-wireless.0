Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:52250 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933571Ab3BSSd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 13:33:27 -0500
Received: by mail-we0-f181.google.com with SMTP id t44so5843391wey.26
        for <linux-wireless@vger.kernel.org>; Tue, 19 Feb 2013 10:33:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20771.50338.434076.484711@gargle.gargle.HOWL>
References: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru>
	<20130219134028.GA26332@pandem0nium>
	<alpine.DEB.2.02.1302191752110.31254@icf.org.ru>
	<CAJ-VmomPkPvABSJtdb6Y=fDNxyd_XtE6sk9yWQzw9qC7rjkwiA@mail.gmail.com>
	<alpine.DEB.2.02.1302192034420.7450@icf.org.ru>
	<CAJ-VmokUJtowcO0AWpyFLoLN0R0KowETb1BOyjN66rzPSDhjOQ@mail.gmail.com>
	<20771.50338.434076.484711@gargle.gargle.HOWL>
Date: Tue, 19 Feb 2013 10:33:25 -0800
Message-ID: <CAJ-VmokAP6hSxjGDUu7Q5rSg3dvxfLapQBSLgYCvWc9b0YEPgA@mail.gmail.com> (sfid-20130219_193340_092918_749DC5B6)
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
From: Adrian Chadd <adrian@freebsd.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Georgiewskiy Yuriy <bottleman@icf.org.ru>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's easy enough to diagnose - just enable NF cal logging. Look at
what's being read back from the initial NF cal and what's being
written into the time-series average.

It may be that something dumb is happening, like there's no
per-channel history, or the history from the wrong channel is being
used on a new channel.

I know the reference driver has a couple of options (per-channel NF
history or shared NF history with a "scan" not using the history
buffer..)



adrian
