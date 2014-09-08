Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38498 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbaIHIx3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 04:53:29 -0400
Message-ID: <1410166400.7983.9.camel@jlt4.sipsolutions.net> (sfid-20140908_105332_298823_1E956690)
Subject: Re: [PATCH v6 2/2] mac80211: support DTPC IE (from Cisco Client
 eXtensions)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 08 Sep 2014 10:53:20 +0200
In-Reply-To: <E1XPB2h-0008WO-MS@pannekake.samfundet.no> (sfid-20140903_155617_247529_E6B6D8C2)
References: <20140903133328.GC18933@sesse.net>
	 <E1XPB2h-0008WO-MS@pannekake.samfundet.no>
	 (sfid-20140903_155617_247529_E6B6D8C2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-09-03 at 06:48 -0700, Steinar H. Gunderson wrote:
> Linux already supports 802.11h, where the access point can tell the
> client to reduce its transmission power. However, 802.11h is only
> defined for 5 GHz, where the need for this is much smaller than on
> 2.4 GHz.
> 
> Cisco has their own solution, called DTPC (Dynamic Transmit Power
> Control). Cisco APs on a controller sometimes but not always send
> 802.11h; they always send DTPC, even on 2.4 GHz. This patch adds support
> for parsing and honoring the DTPC IE in addition to the 802.11h
> element (they do not always contain the same limits, so both must
> be honored); the format is not documented, but very simple.
> 
> Tested (on top of wireless.git and on 3.16.1) against a Cisco Aironet
> 1142 joined to a Cisco 2504 WLC, by setting various transmit power
> levels for the given access points and observing the results.
> The Wireshark 802.11 dissector agrees with the interpretation of the
> element, except for negative numbers, which seem to never happen
> anyway.

Applied both.

johannes

