Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbXD0RqQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 13:46:16 -0400
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andy Green <andy@warmcat.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1177687364.3565.36.camel@johannes.berg>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
	 <200704251634.16604.flamingice@sourmilk.net>
	 <46312067.9090005@linux.intel.com>
	 <200704262023.52833.flamingice@sourmilk.net>
	 <1177684132.21025.36.camel@localhost.localdomain>
	 <20070427164208.25434f11@griffin.suse.cz>
	 <1177685793.21025.52.camel@localhost.localdomain>
	 <463213D7.9070604@warmcat.com>  <1177687364.3565.36.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 13:49:22 -0400
Message-Id: <1177696162.30796.4.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-04-27 at 17:22 +0200, Johannes Berg wrote:
> On Fri, 2007-04-27 at 16:16 +0100, Andy Green wrote:
> 
> > Yeah but this isn't "in hardware" -- it's in firmware: software that
> > runs of a different, vendor-specific, CPU.
> 
> [...]
> 
> Guys, this discussion is deteriorating rapidly!
> 
> The diff to rip out the hw_scan callback is tiny, and since it'd need to
> be worked on anyway to add notification when scanning is done, IMHO it
> is little more work to remove the scan now and add it back in one patch
> including the notification. That just pushes the problem back to those
> people who want/need it and then they can decide if it's worth the
> effort and if they can show that it brings enough advantages.

This discussion has made it pretty clear that if hw_scan ever goes out,
it's going to be really difficult to get it back _in_ at all, even if it
works.

Dan

> The current cfg80211 scanning API is pretty much modeled on the 802.11
> MLME interface and as such should be easy to push through to the
> firmware if necessary, even through mac80211.
> 
> johannes

