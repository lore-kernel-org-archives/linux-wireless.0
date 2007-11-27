Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:49826 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbXK0DuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 22:50:09 -0500
Date: Mon, 26 Nov 2007 19:49:34 -0800
From: Jouni Malinen <j@w1.fi>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	drago01 <drago01@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	Zhu Yi <yi.zhu@intel.com>
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
Message-ID: <20071127034934.GD5698@jm.kir.nu> (sfid-20071127_035016_352047_C8523E5B)
References: <47494851.4070504@gmail.com> <1195987773.4149.214.camel@johannes.berg> <474955E1.30603@gmail.com> <1196079245.4149.255.camel@johannes.berg> <1196093064.4202.46.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1196093064.4202.46.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 26, 2007 at 11:04:24AM -0500, Dan Williams wrote:

> Because in the case of hidden SSIDs, wpa_supplicant pretty much says to
> use ap_scan=2.

Or ap_scan=1 with scan_ssid if and only if the driver supports it..

> 2) scan_ssid=1 hasn't worked consistently on all drivers because it's
> pretty new and many drivers don't support it yet.  This is supposed to
> make the driver/firmware send out probe request for the SSID in
> question.

This is not only a driver issue, though. I believe there are full MAC
cards that do not support scan request with a specific SSID and the only
way to make them work with hidden SSIDs is to try to associate with the
SSID (i.e., use ap_scan=2).

In theory, wpa_supplicant could try to figure out whether the scan with
a specific SSID works or not (though, this is not that easy to do since
old drivers are likely to just ignore the provided SSID and do a
wildcard scan) and if that is the case, start probing the network with
ap_scan=2 like behavior. This would mean that it would go through the
configured networks and try to associate with each that is enabled and
marked with scan_ssid=1. If association is completed successfully, the
network could be added to scan results (at this point, the driver would
also be more likely to actually include it in the scan results, so
proper data could now be available).

The main problem with this is that it can take quite long time to do
this kind of association probing just to be able to get scan results.
Furthermore, at least some cards may require a full match in security
parameters, i.e., each SSID could potentially require multiple
association attempts (assuming the network block was not configured with
explicit security parameters).

Taken into account how much I like hidden SSIDs, I would likely just
prefer to ignore the issue and try to make people use proper security
with visible SSIDs if they want to limit access to their network. Use of
hidden SSIDs is just plain horrible way of making clients suffer without
any level of increased security.

-- 
Jouni Malinen                                            PGP id EFC895FA
