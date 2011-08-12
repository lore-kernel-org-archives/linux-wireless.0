Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4366 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab1HLNb7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 09:31:59 -0400
Date: Fri, 12 Aug 2011 16:31:50 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] nl80211/cfg80211: Add extra IE configuration to AP
 mode setup
Message-ID: <20110812133150.GA2408@jouni.qca.qualcomm.com> (sfid-20110812_153202_945657_CA2AE134)
References: <20110810205556.GA3821@jouni.qca.qualcomm.com>
 <1313152228.4022.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1313152228.4022.4.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 12, 2011 at 02:30:28PM +0200, Johannes Berg wrote:
> On Wed, 2011-08-10 at 23:55 +0300, Jouni Malinen wrote:
> > The NL80211_CMD_NEW_BEACON command is, in practice, requesting AP mode
> > operations to be started. Add new attributes to provide extra IEs
> > (e.g., WPS IE, P2P IE) for drivers that build Beacon, Probe Response,
> > and (Re)Association Response frames internally (likely in firmware).
> 
> Out of curiosity, how would such a driver implement WPS to start with?

These new attributes are provided to allow that to be done easily, i.e.,
the driver will request the firmware to add the extra IEs (WPS/P2P IE)
to the frames that need them. Whenever the IEs change, a _SET_BEACON
command is used to update the IE contents (just like we do with the full
Beacon template). I'm assuming here that the driver (or well, firmware)
is building rest of the IEs both based on internal knowledge of the
channel and security policy (the newly added attributes). This is
similar to how WPS is normally run with many drivers that use private
WEXT ioctls and the new attributes allow them to move to nl80211 more
easily.

-- 
Jouni Malinen                                            PGP id EFC895FA
