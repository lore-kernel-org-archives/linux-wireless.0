Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49171
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753061AbXLGMeJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 07:34:09 -0500
Date: Fri, 07 Dec 2007 04:34:07 -0800 (PST)
Message-Id: <20071207.043407.72593148.davem@davemloft.net> (sfid-20071207_123418_301238_07D2D2FD)
To: mb@bu3sch.de
Cc: jt@hpl.hp.com, shaddy_baddah@hotmail.com,
	linux-wireless@vger.kernel.org, dsd@gentoo.org,
	johannes@sipsolutions.net
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
From: David Miller <davem@davemloft.net>
In-Reply-To: <200712071235.11969.mb@bu3sch.de>
References: <20071206214341.GA6821@bougret.hpl.hp.com>
	<20071206.195214.09557695.davem@davemloft.net>
	<200712071235.11969.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Buesch <mb@bu3sch.de>
Date: Fri, 7 Dec 2007 12:35:11 +0100

> So, how do we handle unaligned data in userspace then?
> A _lot_ of applications are broken if that's right what you say.

Applications make sure data is always properly aligned, that's how
it's handled.  I don't see what the big mystery is. :-)

In the rare cases where these bugs pop up, they simply get fixed.

And you should be thankful these things are being explicitly
flagged as errors on at least some platforms, they could be
silent performance problems otherwise.
