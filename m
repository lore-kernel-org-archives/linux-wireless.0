Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pegasus.erg.abdn.ac.uk ([139.133.204.173]:38123 "EHLO
	pegasus.erg.abdn.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbbFJC0M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 22:26:12 -0400
Date: Tue, 9 Jun 2015 20:25:58 -0600
From: Gerrit Renker <gerrit@erg.abdn.ac.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [WEXT]: multiple calls for SIOCGIWSTATS return same value
Message-ID: <20150609202558.208609e7@erg.abdn.ac.uk> (sfid-20150610_042615_542544_B0798F46)
In-Reply-To: <1433835188.1892.5.camel@sipsolutions.net>
References: <20150606203721.28791bb3@erg.abdn.ac.uk>
	<1433747886.2106.5.camel@sipsolutions.net>
	<20150608195853.239a2622@erg.abdn.ac.uk>
	<1433835188.1892.5.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 09 Jun 2015 09:33:08 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:
> > There is a similar behaviour for scan results: the signal levels reported
> > for stations remain the same for all subsequent calls. Previously these
> > also changed with time and position of receiver.  
> 
> You mean BSSes, not stations, right? This is very strange - it seems
> those should be two entirely different code paths in the kernel.
> 
> What driver are you using? But then again, you said nl80211/iw works,
> right? Then the driver shouldn't matter.
> 
> Do you think you'd be able to use tracing?

Many thanks for providing the patch. I just tried it and it fixed both problems
(access point signal level/quality and signal level reported for BSSes in scan
result). Not sure if trace results are still needed, but I can do that if needed.

Will also work on porting wavemon to nl80211 now.

Thanks again,
Gerrit
