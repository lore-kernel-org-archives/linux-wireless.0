Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-17.dex002.intermedia.net ([64.78.21.83]:22558 "EHLO
	dhost002-17.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932887AbXDBPyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2007 11:54:12 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Mon, 2 Apr 2007 08:54:05 -0700
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: Re: SIOCSIWAP behavior question
Message-ID: <20070402155405.GA2706@devicescape.com>
References: <1175521655.9859.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1175521655.9859.15.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 02, 2007 at 09:47:35AM -0400, Dan Williams wrote:
> Should setting a BSSID trigger a disconnection event from the driver?

Just the act of setting BSSID? No.

> Obviously a disconnect event shouldn't be triggered if the BSSID being
> set is the same BSSID the card is already associated with.  Or does that
> mean "reassociate unconditionally" ?

I would ike to see disconnect event only if the driver/stack notices
that it cannot complete association and based on this, believes its
association to the ESS is lost.

> But suppose we have two APs in the same ESS with obviously different
> BSSIDs.  The card automatically associates with one BSSID, but
> wpa_supplicant decides it likes the other BSSID and calls SIOCSIWAP to
> lock to that one during the association process.  Should the driver
> issue an IWAP event of 00:00:00:00:00:00 before attempting
> re-association with the BSSID that wpa_supplicant wants?

I would not like to see this. I see this as re-association within the
same ESS and the driver/stack should just report the new BSSID after
successful re-association. The exact same behavior should apply here
regardless of whether BSSID was set (sort of forced re-association) or
not (driver/stack re-associating, e.g., due to signal strength
difference).

> The libertas driver currently does this; it sometimes confuses
> wpa_supplicant and is arguably wrong behavior because drivers don't
> issue disconnection events when auto-roaming from BSSID to BSSID in the
> same ESS.
> 
> Conversely, if you have two access points 'linksys' with different
> BSSIDs that really _are_ two different ESSs, this would screw up
> userspace tools if a disconnect _wasn't_ sent.  But in this case
> automatic tools have more problems than driver events.

I would rather not see disconnect event in either case. User space tools
should react to BSSID change event by determining whether the old
network configuration is still valid. This could be done, e.g., by
pinging the default gateway (IP and/or MAC layer) and re-running DHCP if
needed.

-- 
Jouni Malinen                                            PGP id EFC895FA
