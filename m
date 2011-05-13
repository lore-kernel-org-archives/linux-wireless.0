Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756437Ab1EMKpo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:45:44 -0400
Date: Fri, 13 May 2011 12:45:25 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, eliad@wizery.com
Subject: Re: [PATCH v3 1/3] cfg80211/nl80211: add support for scheduled scans
Message-ID: <20110513104524.GA14971@redhat.com> (sfid-20110513_124548_315996_39387F1C)
References: <1305122977-6740-1-git-send-email-coelho@ti.com>
 <1305122977-6740-2-git-send-email-coelho@ti.com>
 <20110512150530.GB2171@redhat.com>
 <1305217201.12586.949.camel@cumari>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1305217201.12586.949.camel@cumari>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 12, 2011 at 07:20:01PM +0300, Luciano Coelho wrote:
> > > The idea is that the hardware can perform scan automatically and filter on
> > > desired results without waking up the host unnecessarily.
> > 
> > Can you elaborate more about this?
> 
> Some devices require very low power consumption, like mobile phones and
> other mobile devices, as you know. ;)
> 
> With this feature, we can offload the scanning entirely to the wireless
> chip, when we're not connected but looking for APs to connect to, so the
> host can keep sleeping and consuming very low power.
> 
> Let's say you're looking for an AP with SSID "myap".  You can keep your
> device scanning for it, so that it's able to connect automatically when
> it shows up without having to keep your device's main CPU awake and
> consuming power.  When "myap" shows in the scan results, the main CPU is
> awoken and the device can connect to it.

I see, thanks for the explanations.

> > > Add NL80211_CMD_START_SCHED_SCAN and NL80211_CMD_STOP_SCHED_SCAN
> > > commands to the nl80211 interface.  When results are available they are
> > > reported by NL80211_CMD_SCHED_SCAN_RESULTS events.  The userspace is
> > > informed when the scheduled scan has stopped with a
> > > NL80211_CMD_SCHED_SCAN_STOPPED event, which can be triggered either by
> > > the driver or by a call to NL80211_CMD_STOP_SCHED_SCAN.
> > > 
> > > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > > ---
> > >  include/linux/nl80211.h |   25 +++++
> > >  include/net/cfg80211.h  |   57 +++++++++++
> > >  net/wireless/core.c     |   12 ++-
> > >  net/wireless/core.h     |    7 ++
> > >  net/wireless/nl80211.c  |  250 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  net/wireless/nl80211.h  |    4 +
> > >  net/wireless/scan.c     |   70 +++++++++++++
> > >  7 files changed, 424 insertions(+), 1 deletions(-)
> > 
> > And explain, why all of this is needed, instead of modify existing scan
> > code and reuse existing infrastructure. This sched_scan does not seems to
> > be something different than normal hardware scan we have already, or I'm
> > wrong.
> 
> It is something different.  At first, I was thinking about modifying the
> existing scan mechanism.  But it turned out to be too complicated,

I wonder if at least at user space we could have some consolidations, i.e.
merge NL80211_CMD_START_SCHED_SCAN to NL80211_CMD_TRIGGER_SCAN, and
create new command NL80211_CMD_CANCEL_SCAN like NL80211_CMD_STOP_SCHED_SCAN
but worked also on normal scan. Anyway this probably does not matter now,
since patches were applied, and we have that API now.

> because the scheduled scan is a long-term operation and the normal scan
> is done for a very short time (and the rest of the stack assumes it will
> complete quickly enough as not to interfere with the connection.

Hmm, is this drawback of implementation or can not be done technically
(question to myself :-) ? I can image that in ideal case hardware scanning
will not affect normal operation, no matter how long it will take.
Software scan is much worse, since we have to change channels manually.
We currently share code between software scan and hardware scan in
mac80211. Perhaps separating hw and sw scan code, would be a good idea
and allow to consolidate hw scan and sched scan. I planning to look
at this more closely.

Thanks
Stanislaw
