Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757353AbXK0Rnl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 12:43:41 -0500
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
From: Dan Williams <dcbw@redhat.com>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	drago01 <drago01@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <20071127034934.GD5698@jm.kir.nu>
References: <47494851.4070504@gmail.com>
	 <1195987773.4149.214.camel@johannes.berg> <474955E1.30603@gmail.com>
	 <1196079245.4149.255.camel@johannes.berg>
	 <1196093064.4202.46.camel@localhost.localdomain>
	 <20071127034934.GD5698@jm.kir.nu>
Content-Type: text/plain
Date: Tue, 27 Nov 2007 12:38:46 -0500
Message-Id: <1196185126.10199.9.camel@localhost.localdomain> (sfid-20071127_174344_400976_86C857D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-11-26 at 19:49 -0800, Jouni Malinen wrote:
> On Mon, Nov 26, 2007 at 11:04:24AM -0500, Dan Williams wrote:
> 
> > Because in the case of hidden SSIDs, wpa_supplicant pretty much says to
> > use ap_scan=2.
> 
> Or ap_scan=1 with scan_ssid if and only if the driver supports it..

Right; but ap_scan=1 + scan_ssid is simply a _better_ way to achieve the
same end.  All drivers should be able to handle ap_scan=2 and just
blowing the settings to the card with WEXT.  Perhaps we should introduce
a WEXT capability bit that advertises the ability to scan specific SSIDs
(at least, cfg80211 should have something like this in its capability
bits) so that some intelligence can be used here.

But the point is, select the alternate, better-working code path where
you _explicitly_ know it works, rather than trying something that might
likely fail and trying to fall back after the failure to the catch-all.
That produces a better user experience, I believe, and is more robust in
the face of crappy drivers.

> > 2) scan_ssid=1 hasn't worked consistently on all drivers because it's
> > pretty new and many drivers don't support it yet.  This is supposed to
> > make the driver/firmware send out probe request for the SSID in
> > question.
> 
> This is not only a driver issue, though. I believe there are full MAC
> cards that do not support scan request with a specific SSID and the only
> way to make them work with hidden SSIDs is to try to associate with the
> SSID (i.e., use ap_scan=2).
> 
> In theory, wpa_supplicant could try to figure out whether the scan with
> a specific SSID works or not (though, this is not that easy to do since
> old drivers are likely to just ignore the provided SSID and do a

Yeah, this seems like something you don't really want to do.  It's too
complicated, raises latency of a successful connection, and is ugly.
Don't do it :)

> wildcard scan) and if that is the case, start probing the network with
> ap_scan=2 like behavior. This would mean that it would go through the
> configured networks and try to associate with each that is enabled and
> marked with scan_ssid=1. If association is completed successfully, the
> network could be added to scan results (at this point, the driver would
> also be more likely to actually include it in the scan results, so
> proper data could now be available).
> 
> The main problem with this is that it can take quite long time to do
> this kind of association probing just to be able to get scan results.
> Furthermore, at least some cards may require a full match in security
> parameters, i.e., each SSID could potentially require multiple
> association attempts (assuming the network block was not configured with
> explicit security parameters).
> 
> Taken into account how much I like hidden SSIDs, I would likely just
> prefer to ignore the issue and try to make people use proper security
> with visible SSIDs if they want to limit access to their network. Use of
> hidden SSIDs is just plain horrible way of making clients suffer without
> any level of increased security.

Yep.  We want to encourage less breakage.  But we do run into the case
where one SSID is hidden with different security settings coming from
the same BSSID as a broadcasted SSID, which is out there in quite a few
places.  Somebody (Cisco?) must have recommended that at one point when
APs were more expensive.

Dan


