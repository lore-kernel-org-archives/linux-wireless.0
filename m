Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbXKZQJJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 11:09:09 -0500
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: drago01 <drago01@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <1196079245.4149.255.camel@johannes.berg>
References: <47494851.4070504@gmail.com>
	 (sfid-20071125_100303_057404_A213DFC8) <1195987773.4149.214.camel@johannes.berg>
	 <474955E1.30603@gmail.com>
	 (sfid-20071125_110054_527140_84EF41E2)  <1196079245.4149.255.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 26 Nov 2007 11:04:24 -0500
Message-Id: <1196093064.4202.46.camel@localhost.localdomain> (sfid-20071126_160915_051768_66BBB620)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-11-26 at 13:14 +0100, Johannes Berg wrote:
> > what works:
> > connect to a hidden ssid with ap_scan=1 in wpa_supplicant.conf
> > what does not work:
> > connect to a hidden ssid with ap_scan=2 in wpa_supplicant.conf
> > ---
> > for non mac80211 drivers its the opposite ie.  ap_scan=2 can connect to 
> > hidden ssid while ap_scan=1 works
> > (thats also whats documented in the wpa_supplicant docs and what nm uses).
> > 
> > so NM can't support mac80211 and non mac80211 drivers at the same time 
> > without ugly hacks due to this issue.
> 
> That's weird. But why does it use ap_scan=2 to start with? With
> mac80211, ap_scan=1 is *much* much better because it lets wpa_supplicant
> control much of roaming, mac80211 really is designed that way.

Because in the case of hidden SSIDs, wpa_supplicant pretty much says to
use ap_scan=2.

There are a few problems here:

1) Historically, some drivers worked better with ap_scan=1 (madwifi),
others worked better with ap_scan=2 (many fullmac drivers)

2) scan_ssid=1 hasn't worked consistently on all drivers because it's
pretty new and many drivers don't support it yet.  This is supposed to
make the driver/firmware send out probe request for the SSID in
question.

So basically, we're up shit creek without a paddle.  You have to use
ap_scan=2 on some cards because they don't support specific-ssid
scanning (with scan_ssid=1) to find the BSS you want to connect to, but
some cards can handle ap_scan=1+scan_ssid=1 OK.

NM has logic to cache the BSSIDs of APs you've connected to before, and
to match those up with an SSID when it sees them in the scan list if the
AP isn't broadcasting the SSID.  Unfortunately, that information isn't
available to wpa_supplicant because wpa_supplicant doesn't have an
interface to handle that sort of thing.  Therefore, when faced with an a
request to connect to a hidden network, wpa_supplicant must rely
_entirely_ on the driver Doing The Right Thing with scan_ssid=1 or
ap_scan=2, and that almost never works due to inconsistency in driver
implementation.

Dan

> I don't see why ap_scan=2 doesn't work though, can you enable some
> wpa_supplicant debugging and send me the logs? Or can you turn off
> encryption and see if you can connect to a hidden SSID? I'd think it
> should work because we do a directed scan so the probe response should
> tell us the SSID.
> 
> johannes

