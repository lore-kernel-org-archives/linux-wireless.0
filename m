Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1LLJxf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 04:53:35 -0500
Subject: Re: [PATCH] mac80211: Do not request FIF_BCN_PRBRESP_PROMISC for
 HW scan.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org, Bartosz.Markowski@tieto.com,
	Janusz.Dziedzic@tieto.com
In-Reply-To: <CAMG6FYgO_LPwMWL1K1+PPVqZJkVj4gaQiyB+PX-NtOe1aPH1aw@mail.gmail.com> (sfid-20111212_103223_331258_A1DB4C07)
References: <CAMG6FYgGB12s+vTGRuKb1E8qzwMa3=kV2pm5ZFQ=BO4WqqZSRQ@mail.gmail.com>
	 <1323680444.3442.5.camel@jlt3.sipsolutions.net>
	 <CAMG6FYgO_LPwMWL1K1+PPVqZJkVj4gaQiyB+PX-NtOe1aPH1aw@mail.gmail.com>
	 (sfid-20111212_103223_331258_A1DB4C07)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Dec 2011 10:53:33 +0100
Message-ID: <1323683613.3442.34.camel@jlt3.sipsolutions.net> (sfid-20111212_105338_898563_1E0039FF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-12-12 at 10:31 +0100, Dmitry Tarnyagin wrote:
> On Mon, Dec 12, 2011 at 10:00 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sun, 2011-12-11 at 22:47 +0100, Dmitry Tarnyagin wrote:
> >> ieee80211_configure_filter code used local->scanning as a boolean value
> >> when it was a bit mask. Bits SCAN_HW_SCANNING, SCAN_COMPLETED, SCAN_ABORTED
> >> should not set FIF_BCN_PRBRESP_PROMISC filter.
> >
> > Seems right -- although the probresp-promisc filter thing is debatable
> > and I think the changelog should be more explicit about it, maybe saying
> > that the driver can always change that by itself in the hw scan callback
> > if it requires it... That part isn't really only bugfix, it's a semantic
> > change.
> >
> Well, then the semantic should be at least consistent. Scan code does
> not specially
> configure filter for hw scans, nor after scan complete. But any 3rd
> party config-filter
> requests during an active scan enable probresp-promisc.

Yeah, and I don't disagree with this change -- all I'm saying is that
the commit log should reflect that because otherwise somebody later
looking at this change will be scratching their head :)

johannes

