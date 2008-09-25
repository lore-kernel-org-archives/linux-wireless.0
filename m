Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbYIYQ6r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 12:58:47 -0400
Subject: Re: [PATCH] wireless: consolidate on a single escape_essid
	implementation
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <1222332205.10563.26.camel@johannes.berg>
References: <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
	 <20080924232453.GG9187@tesla> <20080924233234.GE3639@tuxdriver.com>
	 <200809250834.07781.hs4233@mail.mn-solutions.de>
	 (sfid-20080925_083440_223989_866F07A7)  <1222332205.10563.26.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 12:57:43 -0400
Message-Id: <1222361863.14444.18.camel@localhost.localdomain> (sfid-20080925_185851_642978_A90BDB40)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-09-25 at 10:43 +0200, Johannes Berg wrote:
> On Thu, 2008-09-25 at 08:34 +0200, Holger Schurig wrote:
> > > the libertas, ipw2100, and ipw2200 drivers don't use cfg80211
> > > (at least for now).
> > 
> > Yeah, Dan once spoke about using cfg80211 for libertas, but at 
> > that time I didn't saw the point.
> > 
> > Hmm, I actually don't see the point now :-)
> 
> Well, you'll want to take advantage of the regulatory code and the
> scanning stuff I'm working on...

Yes.  I want common regulatory code, if nothing else then common
functions for:

channel <-> frequency conversion
common regulatory domains and their restrictions
common BSS structure for scan results
common scan result translation handlers

Two options for scan result handling:

--------------------------------------------------------------------------
1) common GIWSCAN processing function that takes a callback.  This
callback would be executed until it returns FALSE to signify no further
scan results.  Callback prototype:

bool scan_res_hook(struct common_bss *bss, void *user_data);

'bss' would simply be a _single_ common bss structure allocated at the
start of iteration, and zeroed each time before calling the hook.  The
scan hook then fills that common BSS structure with information from its
own internal scan list.  The GIWSCAN processor then handles translation
into the actual WEXT event stream or nl80211 formats.

--------------------------------------------------------------------------
2) common GIWSCAN processing function that takes a list of common BSS
structures that the driver stores internally.  The common BSS structure
would have a "void *driver_data" pointer in which the driver could keep
driver-specific data items, but the driver would be responsible for
setting all available information in the common BSS structure when the
firmware provides scan results.  lib80211 provides common allocation,
deallocation, bss entry aging, ref/unref, and free-list fetching.


This would remove a good chunk of code from airo, atmel, and libertas at
least, which are the drivers that I've converted to this sort of scan
results handling system in the past.  Most of the old ieee80211's BSS
structure stuff was applicable, but it had too many Intel-specific bits
in it too (like the SECLEVEL stuff).

Thoughts?

Dan


