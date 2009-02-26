Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54621 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254AbZBZS52 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 13:57:28 -0500
Date: Thu, 26 Feb 2009 20:57:10 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] nl80211: Authentication and association events
Message-ID: <20090226185710.GA22925@jm.kir.nu> (sfid-20090226_195735_691767_BACBB799)
References: <20090218200210.GA13955@jm.kir.nu> <1234988740.4023.51.camel@johannes.local> <20090220192557.GA17914@jm.kir.nu> <1235440527.4455.45.camel@johannes.local> <20090226143758.GB24380@jm.kir.nu> <1235666926.4099.2.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1235666926.4099.2.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 26, 2009 at 08:48:46AM -0800, Johannes Berg wrote:
> On Thu, 2009-02-26 at 16:37 +0200, Jouni Malinen wrote:
> > On Mon, Feb 23, 2009 at 05:55:27PM -0800, Johannes Berg wrote:
> > > Should we have some more code in cfg80211 to keep track of the BSSes
> > > we're authenticated/the one we're associated to, and have some commands
> > > to query those from userspace?
> > 
> > It would probably be useful to add this eventually. Whatever is
> > requesting the association has most of the information, but it would be
> > could to allow other applications have access to it and also remove the
> > need to store that in the control application.
> 
> I guess we'll kinda need that to have iwconfig print out something useful.

Actually, iwconfig works fine in my current version since it just uses
the information from same functions that were used in
net/mac80211/mlme.c. In other words, when I complete association with an
external SME (wpa_supplicant), iwconfig can still show the BSSID etc.
info.

I'm now able to complete authentication and association in two steps and
use only nl80211 for it (i.e., no WEXT code needed in driver_nl80211.c
for auth/assoc/deauth/disassoc processing). The mlme.c changes are not
the cleanest possible and there are still couple of places where mlme.c
shows its SME nature by deciding to automatically do something, but
other than that, this seems to be functional.

-- 
Jouni Malinen                                            PGP id EFC895FA
