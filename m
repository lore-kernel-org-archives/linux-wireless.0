Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:45433 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907Ab3KBHda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Nov 2013 03:33:30 -0400
Date: Sat, 2 Nov 2013 09:33:19 +0200
From: Jouni Malinen <j@w1.fi>
To: Arend van Spriel <arend@broadcom.com>
Cc: "Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Introduce critical protocol indication for p2p
 connection.
Message-ID: <20131102073319.GA3507@w1.fi> (sfid-20131102_083342_452996_411E9267)
References: <1383230452-12608-1-git-send-email-usdutt@qti.qualcomm.com>
 <1383230593.14302.1.camel@jlt4.sipsolutions.net>
 <26F3B0343EE4744AA14EEEF9E1E534511F7A65CC@aphydexd01a>
 <1383233115.14302.2.camel@jlt4.sipsolutions.net>
 <26F3B0343EE4744AA14EEEF9E1E534511F7A6606@aphydexd01a>
 <52729681.5020004@broadcom.com>
 <26F3B0343EE4744AA14EEEF9E1E534511F7A8160@aphydexd01a>
 <5273A784.4040900@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5273A784.4040900@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 01, 2013 at 02:07:16PM +0100, Arend van Spriel wrote:
> On 11/01/2013 12:25 PM, Undekari, Sunil Dutt wrote:
> >The host driver / firmware performs (initiates) a scan on the STA interface in the process of finding a better BSS to roam. This scan is offloaded to the driver / firmware for a better roam experience.
> >This scans would definitely affect the p2p connection triggered by the supplicant.
> >Thus, I was suggesting a way to extend the already existing critical protocol indications to also include p2p protocol/connections, so that drivers can defer the scan's (any off channel operations for that matter) on any other interface during this period.
> 
> I got that. What I meant to say is that you can defer the roaming
> related scans when cfg80211 does a .add_virtual_intf() call to the
> driver and recommence upon .del_virtual_intf(). I guess this
> effectively disables roaming, right?

That sounds quite excessive. The case here is a multi-channel
concurrency capable device which has a station connection and
wpa_supplicant is about to go through P2P group formation. I see no
reason to disable roaming, but it would sound useful to avoid doing the
background scans for that at the exact time of the group formation
(couple of seconds in most cases).

Currently, there is no way for wpa_supplicant to clearly indicate to the
driver that it is about to run through number of quick operations
(offchannel Action frame exchange for GO Negotiation, single channel
scan, WPS association + EAPOL exchange, data connection association +
4-way handshake). The driver can guess that this is happening (or could
use really ugly hacks to see what Action frames are exchanged and
determine next likely operation based on that) and as such, would not
know how to configure the firmware to avoid background scans for the
station interface during this full sequence.

While the background scan should in most cases not completely break the
process even with inconvenient timing (or well, hitting one in middle of
the three frame GO Negotiation would have potential to time out that
exchange), it would be nice if this common sequence could be optimized
to avoid extra latencies and to be more robust in general since there is
a 15 second timeout for group formation and quite a bit shorter timeouts
in practice for the individual operations within the sequence.

-- 
Jouni Malinen                                            PGP id EFC895FA
