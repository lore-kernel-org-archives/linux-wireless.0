Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pegasus.erg.abdn.ac.uk ([139.133.204.173]:37594 "EHLO
	pegasus.erg.abdn.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbbFIB7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 21:59:13 -0400
Date: Mon, 8 Jun 2015 19:58:53 -0600
From: Gerrit Renker <gerrit@erg.abdn.ac.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [WEXT]: multiple calls for SIOCGIWSTATS return same value
Message-ID: <20150608195853.239a2622@erg.abdn.ac.uk> (sfid-20150609_035916_480278_9F1CBDE9)
In-Reply-To: <1433747886.2106.5.camel@sipsolutions.net>
References: <20150606203721.28791bb3@erg.abdn.ac.uk>
	<1433747886.2106.5.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Sat, 2015-06-06 at 20:37 -0600, Gerrit Renker wrote:
> > A problem has been found in recent kernels where multiple
> > calls using SIOCGIWSTATS return the same, identical value.  
> 
> Which "value"? I believe these return a number of different values. What
> are the returned values? Are they perhaps just 0?
> 
I am primarily referring to the signal level. The first call returns a
plausible value e.g. -78dB. All subsequent calls return the same value,
regardless of receiver position (moving the laptop).

It almost looks like a static value that gets initialized and then 
does not change.

There is a similar behaviour for scan results: the signal levels reported
for stations remain the same for all subsequent calls. Previously these
also changed with time and position of receiver.

> Is the application a 32-bit application running on a 64-bit machine
> perhaps? 
Sorry forgot to mention: application and operating system both 64 bit,
the bug submitted to wavemon also mentioned 64 bit.

Thank you for the reply -- maybe this means that the root cause is in a
different part; I would not know which at the moment.
