Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51895 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932181AbbFIHdL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 03:33:11 -0400
Message-ID: <1433835188.1892.5.camel@sipsolutions.net> (sfid-20150609_093320_660364_1CB3C389)
Subject: Re: [WEXT]: multiple calls for SIOCGIWSTATS return same value
From: Johannes Berg <johannes@sipsolutions.net>
To: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 09 Jun 2015 09:33:08 +0200
In-Reply-To: <20150608195853.239a2622@erg.abdn.ac.uk>
References: <20150606203721.28791bb3@erg.abdn.ac.uk>
	 <1433747886.2106.5.camel@sipsolutions.net>
	 <20150608195853.239a2622@erg.abdn.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-06-08 at 19:58 -0600, Gerrit Renker wrote:

> I am primarily referring to the signal level. The first call returns a
> plausible value e.g. -78dB. All subsequent calls return the same value,
> regardless of receiver position (moving the laptop).
> 
> It almost looks like a static value that gets initialized and then 
> does not change.
> 
> There is a similar behaviour for scan results: the signal levels reported
> for stations remain the same for all subsequent calls. Previously these
> also changed with time and position of receiver.

You mean BSSes, not stations, right? This is very strange - it seems
those should be two entirely different code paths in the kernel.

What driver are you using? But then again, you said nl80211/iw works,
right? Then the driver shouldn't matter.

Do you think you'd be able to use tracing?

trace-cmd report -e cfg80211 -e mac80211

would report the calls to/from the driver and could perhaps shed some
light. If you can record this, send me the resulting trace.dat file
(compressed) off-list.

johannes

