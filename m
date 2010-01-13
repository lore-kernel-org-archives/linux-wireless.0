Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:60896 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518Ab0AMLbn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 06:31:43 -0500
Date: Wed, 13 Jan 2010 13:30:00 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211/mac80211: Add TX/RX commands for Action frames
Message-ID: <20100113113000.GA20835@jm.kir.nu>
References: <20100113101126.GA12548@jm.kir.nu>
 <1263377951.5093.326.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1263377951.5093.326.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 13, 2010 at 11:19:11AM +0100, Johannes Berg wrote:
> On Wed, 2010-01-13 at 12:11 +0200, Jouni Malinen wrote:
> > This patch adds couple of to-do items to handle rejecting of unknown
> > Action frames. This is required by IEEE 802.11, but we do not
> > currently handle it in mac80211. To do this properly with optional
> > user space control of some Action frame subtypes, a new mechanism will
> > be needed to register user space handlers and to unregister these when
> > the netlink socket is closed.
> 
> I'm not sure we should be adding this before we at least add the API to
> register for this from userspace, if somebody starts using it now it'll
> be effectively broken when that fix comes along, no?

Assuming the later change in mac80211 is to start rejecting Action
frames for which there is no known internal handler or register user
space handler, the applications using this without the new registration
mechanism would indeed need to be updated.

If we can be relatively confident on what exactly is needed for the
registration to handle some Action frames, we could add the dummy
nl80211 command for now and then implement mac80211 (and even cfg80211)
parts of it separately. This would allow cleaner update with
applications that actually followed the rules and used the
registration command now even if we were not to enforce its use (and we
probably should not enforce it anyway since it might be acceptable to
transmit some Action frames without expecting to ever process incoming
Action frames).

One problem with the registration mechanism is that it may not be
obvious at this point what exactly we want to export into user space in
the future and what gets handled inside the kernel. One obvious place
would be to do register to process all Action frames of a specific
category, but that may not be enough since it is possible that some
categories will be handled both in kernel and in applications.

The mechanism for specifying which Action frames are handled will likely
need to be quite extensible.. This would require at least one attribute
for specifying the Category value. Then based on the Category value, we
may need to be able to specify the Action Value as an option attribute.
In addition, the vendor specific Action and Public Action fields would
need to get OUI as another optional attribute. With vendor specific
values, we may even need yet another optional attribute to specify the
subtype of the vendor specific information since some protocols may be
handled in kernel and some in applications (i.e., more than one
application for the same vendor OUI).

-- 
Jouni Malinen                                            PGP id EFC895FA
