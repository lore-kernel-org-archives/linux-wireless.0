Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab2B0JCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 04:02:42 -0500
Subject: Re: iwlwifi WPA-TKIP crypto failure after group rekeying
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	651199@bugs.debian.org, Andreas Gustafsson <olangu@impressions.se>,
	Marco d'Itri <md@Linux.IT>,
	Gabriel Kerneis <kerneis@pps.jussieu.fr>
In-Reply-To: <1330320802.8460.105.camel@deadeye> (sfid-20120227_063327_782741_C11A1DED)
References: <1330320802.8460.105.camel@deadeye>
	 (sfid-20120227_063327_782741_C11A1DED)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Feb 2012 10:02:34 +0100
Message-ID: <1330333354.3483.6.camel@jlt3.sipsolutions.net> (sfid-20120227_100247_251787_F8487642)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

Thanks for the report.

On Mon, 2012-02-27 at 05:33 +0000, Ben Hutchings wrote:
> Several Debian users (cc'd) have reported a regression in iwlagn in
> Linux 3.1, not fixed in 3.2.  The full bug log is at:
> 
> http://bugs.debian.org/651199
> 
> To summarise, a WPA-TKIP managed connection stops passing traffic and
> the kernel log shows the message "WPA: Group rekeying".  This apparently
> doesn't happen if the connection is in heavy use at the time or with
> module parameter swcrypto=1.  WPA2 is not affected either.

I think this is due to my patch "iwlagn: rewrite HW crypto" which
accidentally broke key *removal* (of all things), which causes issues
when the first GTK is removed on the second rekeying.

This patch
http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi.git;a=commitdiff;h=5dcbf480473f6c3f06ad2426b7517038a2a18911

should fix it. Wey has sent it to John, but he hasn't picked it up yet
for some reason -- it's also marked for stable.

It'd be great to get confirmation that this is the problem, I'm not sure
I'll find time today to reproduce the problem.

johannes

