Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:36563 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbYIOQfX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 12:35:23 -0400
From: Helmut Schaa <hschaa@suse.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] Implement basic background scanning
Date: Mon, 15 Sep 2008 18:35:03 +0200
Cc: linux-wireless@vger.kernel.org
References: <200809151416.07552.hschaa@suse.de> <200809151429.46638.hschaa@suse.de> <1221494383.3700.52.camel@johannes.berg>
In-Reply-To: <1221494383.3700.52.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809151835.03786.hschaa@suse.de> (sfid-20080915_183526_909699_3FDD37B0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 15. September 2008 schrieb Johannes Berg:
> On Mon, 2008-09-15 at 14:29 +0200, Helmut Schaa wrote:
> > Basic implementation of software background scanning functionality.
> > 
> > The patch basically enhances the scanning state machine by two further
> > states (SCAN_DEFER, SCAN_OPERATION). In state SCAN_DEFER the driver is advised
> > to switch back to the operating channel while SCAN_OPERATION tells the access
> > point about being back from power saving and restarts the tx queue. Just before
> > SCAN_SET_CHANNEL sets the next channel to scan it notifies the access point
> > about going to power save state and stops the tx queue.
> > 
> > However one (still unresolved) issue is that the code does not wait for the
> > appropriate ACK from the access point after notifying the new power state.
> > 
> > Any thoughts or comments?
> 
> This doesn't play well at all with hardware assisted scan as far as I
> can tell.

Correct. The patch only adapts software scan code. The hardware assisted scan
is not touched at all but should also not be affected in an odd way.

Helmut
