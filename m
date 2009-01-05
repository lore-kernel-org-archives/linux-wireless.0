Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:50378 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752390AbZAEJtw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 04:49:52 -0500
Date: Mon, 5 Jan 2009 11:49:40 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alina Friedrichsen <x-alina@gmx.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Invalid BSSID handling?
Message-ID: <20090105094940.GA28304@jm.kir.nu> (sfid-20090105_104955_477694_693274AC)
References: <20090103000028.302750@gmx.net> <1231023437.4629.1.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1231023437.4629.1.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 03, 2009 at 11:57:17PM +0100, Johannes Berg wrote:
> On Sat, 2009-01-03 at 01:00 +0100, Alina Friedrichsen wrote:
> > The madwifi accepts all BSSIDs except 00:00:00:00:00:00 and
> > ff:ff:ff:ff:ff:ff. Should mac80211 allow all BSSIDs like madwifi, or
> > should it better treat multicast MAC addresses as 00:00:00:00:00:00,
> > or an other handling?
> 
> Even though the standard asks you to use locally administered addresses
> for IBSS, I don't see this as a requirement since they just want to
> guarantee uniqueness and if you're assigning manually you rely on
> different methods for uniqueness.

For locally administered bit, I would agree, but I would still avoid
using any multicast address as the BSSID. It could cause undesired
behavior for RX filtering.

-- 
Jouni Malinen                                            PGP id EFC895FA
