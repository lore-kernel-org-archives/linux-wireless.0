Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51798 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbaH1Hnr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 03:43:47 -0400
Message-ID: <1409211818.2505.12.camel@jlt4.sipsolutions.net> (sfid-20140828_094353_045901_0C42215E)
Subject: Re: [PATCH] Support DTPC IE (from Cisco Client eXtensions)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 28 Aug 2014 09:43:38 +0200
In-Reply-To: <E1XLZxt-0002h9-Um@pannekake.samfundet.no> (sfid-20140824_174436_455216_80D556D9)
References: <20140824103728.GA2938@sesse.net>
	 <E1XLZxt-0002h9-Um@pannekake.samfundet.no>
	 (sfid-20140824_174436_455216_80D556D9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-08-24 at 12:08 +0200, Steinar H. Gunderson wrote:
> Linux already supports 802.11h, where the access point can tell the
> client to reduce its transmission power. However, 802.11h is only
> defined for 5 GHz, where the need for this is much smaller than on
> 2.4 GHz.
> 
> Cisco has their own solution, called DTPC (Dynamic Transmit Power
> Control).  Cisco APs on a controller sometimes but not always send
> 802.11h; they always send DTPC, even on 2.4 GHz. This patch adds support
> for parsing and honoring the DTPC IE if there is no 802.11h element;
> the format is not documented, but very simple.
> 
> Tested (on top of wireless.git and on 3.16.1) against a Cisco Aironet
> 1142 joined to a Cisco 2504 WLC, by setting various transmit power
> levels for the given access points and observing the results.
> The Wireshark 802.11 dissector agrees with the interpretation of the
> element, except for negative numbers, which seem to never happen
> anyway.

Can you say *why* we want this? Does it yield better behaviour on a
Cisco deployment?

johannes

