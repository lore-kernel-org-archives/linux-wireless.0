Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:48848 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753516Ab0C1Wsn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 18:48:43 -0400
Date: Sun, 28 Mar 2010 15:48:29 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	luciano.coelho@nokia.com
Subject: Re: [PATCH 0/2] mac80211: cfg80211: Roam trigger support
Message-ID: <20100328224829.GA22722@jm.kir.nu>
References: <1269327754-995-1-git-send-email-juuso.oikarinen@nokia.com>
 <1269499567.5041.0.camel@jlt3.sipsolutions.net>
 <20100328194332.GA384@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100328194332.GA384@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 28, 2010 at 12:43:32PM -0700, Jouni Malinen wrote:
> On Wed, Mar 24, 2010 at 11:46:07PM -0700, Johannes Berg wrote:
> > So this is merged, anyone want to implement it in mac80211 so we can
> > start playing with it? I won't get around to it for quite a while.
> 
> How about something like this? Based on a very brief test (walk 10
> meters toward the AP and then back ;-) this seems to be doing more or
> less what I expect the feature should do.

And for those interested in playing more with this, I added support for
using the new signal strength threshold with the bgscan_simple module in
wpa_supplicant. This seemed to provide reasonable behavior in an office
environment with multiple APs and some overlapping coverage area in a
test with ath9k. I used following wpa_supplicant configuration option
for this particular test:
bgscan="simple:30:-50:300"

This uses background scan interval of 30 seconds if signal strength is
below -50 dBm and 300 seconds if above. A new scan is triggered
immediately if the signal strength drops below the threshold (or if it
drops further 4 dB and it has been more than 10 seconds from the
previous scan). Furthermore, I had manually configured the list of known
channels that the APs here are using (scan_freq parameter).

The connection did not die at any point (based on a continuous ping) and
roaming behavior seemed reasonable, i.e., signal strength did not drop
below -65 dBm or so before the new AP was already found. Background
scans are also quite tolerable when the frequency list is limited and
even more so, when remaining in the same location where the signal
strength remains above the threshold. That 300 second interval could
also be made much higher if it is desirable to avoid more or less all
background scans since the immediate scan triggered by signal strength
drop by itself should cover most use cases.

-- 
Jouni Malinen                                            PGP id EFC895FA
