Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:60155 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbXKXUAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 15:00:44 -0500
Date: Sat, 24 Nov 2007 12:00:16 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: mabbas <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org,
	Dan Williams <dcbw@redhat.com>, linville@tuxdriver.com
Subject: Re: wpa_supplicant/key deletion with all-zeroes mac (was: security
	question)
Message-ID: <20071124200016.GK8672@jm.kir.nu> (sfid-20071124_200056_437591_F9ECD0D7)
References: <4743E5DF.9040603@linux.intel.com> <1195658254.12000.23.camel@johannes.berg> <20071122043722.GC8672@jm.kir.nu> <1195736126.6323.86.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1195736126.6323.86.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 22, 2007 at 01:55:26PM +0100, Johannes Berg wrote:

> > > > wpa_supplicant will 
> > > > receives this event then call mac80211 to remove any old security key, 
> > > > the problem it will pass 00:00:00:00:00:00 as station address. 

> Can you look into it then please?

It looks like this was fixed more than a year ago.. Which wpa_supplicant
version was used here? Can the problem be reproduced on something more
recent (e.g., 0.5.8 or the current 0.6.x snapshot)? If yes, I would like
to see debug log from wpa_supplicant showing what exactly happens.

The fix was to reorder clearing of the BSSID:
http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=commitdiff;h=3103d0a7f91a48ebfa0d08c6599babd0c556e6a9

-- 
Jouni Malinen                                            PGP id EFC895FA
