Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50234 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758451Ab3BSQb3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 11:31:29 -0500
Received: by mail-we0-f174.google.com with SMTP id r6so5805438wey.5
        for <linux-wireless@vger.kernel.org>; Tue, 19 Feb 2013 08:31:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1302191752110.31254@icf.org.ru>
References: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru>
	<20130219134028.GA26332@pandem0nium>
	<alpine.DEB.2.02.1302191752110.31254@icf.org.ru>
Date: Tue, 19 Feb 2013 08:31:25 -0800
Message-ID: <CAJ-VmomPkPvABSJtdb6Y=fDNxyd_XtE6sk9yWQzw9qC7rjkwiA@mail.gmail.com> (sfid-20130219_173133_844657_8DD165D7)
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
From: Adrian Chadd <adrian@freebsd.org>
To: Georgiewskiy Yuriy <bottleman@icf.org.ru>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, ANI does adjust some of its parameters based on the beacon
signal level. It uses that as an estimate for how "strong" the signal
is likely to be and tunes the baseband to either be highly sensitive
or slightly on the deafer side.

If you have many sources of beacons (read: ibss, mesh, TDMA in my
case) then that particular feature of ANI can't be used and it should
be disabled. The code should be special casing it.

I suggest someone writes a bunch of test functions:

* whether we see no beacons (ie, AP mode)
* whether we see one set of beacons (ie, STA mode)
* whether we see multiple sets of beacons (ie ,everything else)

.. and then modify the ANI code to work with the above.



adrian
