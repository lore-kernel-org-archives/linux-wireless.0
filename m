Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30770 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab2B0PKu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 10:10:50 -0500
Subject: Re: iwlwifi WPA-TKIP crypto failure after group rekeying
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	651199@bugs.debian.org, Andreas Gustafsson <olangu@impressions.se>,
	Marco d'Itri <md@Linux.IT>,
	Gabriel Kerneis <kerneis@pps.jussieu.fr>
In-Reply-To: <1330333354.3483.6.camel@jlt3.sipsolutions.net>
References: <1330320802.8460.105.camel@deadeye>
	 (sfid-20120227_063327_782741_C11A1DED)  <1330333354.3483.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Feb 2012 05:59:38 -0800
Message-ID: <1330351178.12612.3.camel@wwguy-huron> (sfid-20120227_161055_804666_59EBD9B1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben/Johannes,

On Mon, 2012-02-27 at 10:02 +0100, Johannes Berg wrote:
> Hi Ben,
> 
> Thanks for the report.
> 
> On Mon, 2012-02-27 at 05:33 +0000, Ben Hutchings wrote:
> > Several Debian users (cc'd) have reported a regression in iwlagn in
> > Linux 3.1, not fixed in 3.2.  The full bug log is at:
> > 
> > http://bugs.debian.org/651199
> > 
> > To summarise, a WPA-TKIP managed connection stops passing traffic and
> > the kernel log shows the message "WPA: Group rekeying".  This apparently
> > doesn't happen if the connection is in heavy use at the time or with
> > module parameter swcrypto=1.  WPA2 is not affected either.
> 
> I think this is due to my patch "iwlagn: rewrite HW crypto" which
> accidentally broke key *removal* (of all things), which causes issues
> when the first GTK is removed on the second rekeying.
> 
> This patch
> http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi.git;a=commitdiff;h=5dcbf480473f6c3f06ad2426b7517038a2a18911
> 
> should fix it. Wey has sent it to John, but he hasn't picked it up yet
> for some reason -- it's also marked for stable.
> 
> It'd be great to get confirmation that this is the problem, I'm not sure
> I'll find time today to reproduce the problem.
> 
John merge the patch 5 days ago anf yuo can find it in wireless-testing
tree

authorJohannes Berg <johannes.berg@intel.com> Fri, 17 Feb 2012 17:47:14
+0000 (09:47 -0800) committerJohn W. Linville <linville@tuxdriver.com>
Tue, 21 Feb 2012 19:45:26 +0000 (14:45 -0500)
commit5dcbf480473f6c3f06ad2426b7517038a2a18911
tree66d2cbefee018ff46d499e0aeab573aa94558353tree | snapshot
parent7be081539e540517d5e1fcbf96b8080074afbf08commit | diff

Wey

> 


