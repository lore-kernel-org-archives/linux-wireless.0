Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51029 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbYJ0N37 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 09:29:59 -0400
Date: Mon, 27 Oct 2008 09:28:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Chr <chunkeey@web.de>, mcgrof <mcgrof@gmail.com>
Subject: Re: build warnings
Message-ID: <20081027132858.GA20389@tuxdriver.com> (sfid-20081027_143017_357927_6C8D24FF)
References: <1224923050.27353.1.camel@johannes.berg> <1ba2fa240810270330u15e3ce04y9d077904f48e04e7@mail.gmail.com> <1397eb932d5573ecf093fcbc82c02adb.squirrel@secure.sipsolutions.net> <1ba2fa240810270341l9332ec3qeee761ba764d5617@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240810270341l9332ec3qeee761ba764d5617@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 27, 2008 at 12:41:22PM +0200, Tomas Winkler wrote:
> On Mon, Oct 27, 2008 at 12:34 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > Tomas Winkler wrote:
> >> On Sat, Oct 25, 2008 at 10:24 AM, Johannes Berg
> >> <johannes@sipsolutions.net> wrote:
> >>> just FYI in case you haven't seen them. the p54 one looks like a genuine
> >>> problem.
> >>>
> >>> drivers/net/wireless/iwlwifi/iwl-scan.c:69: warning: 'scan_tx_ant'
> >>> defined but not used
> >>
> >> Strange. This variable was removed in 'iwlwifi: unify tx antenna toggling'
> >> patch
> >
> > odd. maybe I don't have the right tree here. Just mentioning the warnings
> > because in my experienced different gcc versions differ.
> >
> Really odd, the lines are just not there. Try to diff to
> wireless-testing master branch.

I advise you do the same -- I see the warning too.

The fault would seem to lie somewhere between me and git -- that bit
seems to have been added back with "wireless: consolidate on a single
escape_essid implementation".  Presumably this happened when I rebased
those patches, although I don't recall having done any manual fixups
that I could have flubbed.

Anyway, don't worry -- I'll take care of this one.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
