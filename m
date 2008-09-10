Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbYIJNKM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 09:10:12 -0400
Subject: Re: [PATCH] mac80211: add pre- and post-scan hooks
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221033061.12266.10.camel@johannes.berg>
References: <1214149401.8585.2.camel@localhost.localdomain>
	 (sfid-20080622_174624_286344_54D543FD)  <1221033061.12266.10.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 09:09:27 -0400
Message-Id: <1221052167.4648.9.camel@localhost.localdomain> (sfid-20080910_151017_369906_7A8E63AC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-09-10 at 09:51 +0200, Johannes Berg wrote:
> On Sun, 2008-06-22 at 11:43 -0400, Dan Williams wrote:
> > mrv8k has commands that get called before and after the scan has been
> > done to save and restore hardware state.  Add optional callbacks to
> > mac80211 to enable low-level drivers to know when the stack is about to
> > start scanning, and when it's done.
> 
> Was just talking to Sujith about something on IRC and realised that
> maybe this is required to turn off IBSS beaconing when leaving the
> channel for a scan?

Most cards to the beaconing in hardware/firmware with a given template,
right?  If so this sounds quite plausible.  Does beaconing not get
paused now?

Dan

