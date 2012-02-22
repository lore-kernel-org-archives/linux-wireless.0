Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39388 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab2BVS56 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 13:57:58 -0500
Subject: Re: [RFC] cfg80211: 80Mhz Bandwidth channel flags in 5Gig band
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh <maheshp@posedge.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1329933458.4657.2.camel@jlt3.sipsolutions.net> (sfid-20120222_185746_860409_0CF57D5F)
References: <f17c700977012ada368da4f339b9c639@posedge.com>
	 (sfid-20120222_185112_125868_ED7DF18C)  <1329933458.4657.2.camel@jlt3.sipsolutions.net>
	 (sfid-20120222_185746_860409_0CF57D5F)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Feb 2012 19:57:52 +0100
Message-ID: <1329937072.4657.4.camel@jlt3.sipsolutions.net> (sfid-20120222_195836_735719_3A2758BA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-02-22 at 18:57 +0100, Johannes Berg wrote:
> On Wed, 2012-02-22 at 23:21 +0530, Mahesh wrote:
> > This change is for marking 80Mhz bandwidth supported channel flags in 
> > 5Gig band.
> 
> This patch is not only completely mangled, it also neglects to actually
> support this in the regdb etc. What's the point?

I should elaborate. Something like this code is needed, but right now
the regulatory database contains things like

        (5150 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS

which means at most 40 MHz can be used.

In your patch, you don't even check this maximum bandwidth, which is a
bug, but even if you did the database would have to be changed.

Also, we probably really need to introduce handling of spectral power
limits to make this worthwhile?

johannes

