Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45369 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbbFHHSI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 03:18:08 -0400
Message-ID: <1433747886.2106.5.camel@sipsolutions.net> (sfid-20150608_091814_064147_12630B00)
Subject: Re: [WEXT]: multiple calls for SIOCGIWSTATS return same value
From: Johannes Berg <johannes@sipsolutions.net>
To: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 08 Jun 2015 09:18:06 +0200
In-Reply-To: <20150606203721.28791bb3@erg.abdn.ac.uk> (sfid-20150607_044726_833751_BC9D05B3)
References: <20150606203721.28791bb3@erg.abdn.ac.uk>
	 (sfid-20150607_044726_833751_BC9D05B3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-06-06 at 20:37 -0600, Gerrit Renker wrote:
> A problem has been found in recent kernels where multiple
> calls using SIOCGIWSTATS return the same, identical value.

Which "value"? I believe these return a number of different values. What
are the returned values? Are they perhaps just 0?

Is the application a 32-bit application running on a 64-bit machine
perhaps? There have been bugs in that area in the past, though I don't
believe anything changed between 3.19 and 4.0. In fact, in wext nothing
really changed at all - only some internal maintenance (commit
319090bf6c75e3ad42a8c74973be5e78ae4f948f)

> This behaviour is observable both using 'iwconfig <dev>'
> and wavemon info screen, where it was reported in [1].
> 
> It looks as if this is a WEXT issue, since on the same 
> system multiple 'iw dev <devname> station dump' calls
> return different signal level values.
> 
> I can confirm the behaviour on davem 4.1.0-rc6 net tree
> at commit c46a024ea5, it has been reported on [1] for 
> fedora 21 with kernel-4.0.4-201/2 as well.
> 
> That report also stated that the behaviour does not occur
> on kernel-3.19.7-200. Have not had time to bisect yet.
> 
> Thanks for any hints that can help resolve this.

I have no idea, sorry.

johannes

